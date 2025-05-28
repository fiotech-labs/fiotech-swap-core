// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./BnwSwapFactory.sol";
import "./libraries/BnwSwapLibrary.sol";

contract BnwSwapRouter {
    address public factory;

    constructor(address _factory) {
        factory = _factory;
    }

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired
    ) external returns (uint amountA, uint amountB, uint liquidity) {
        (address token0, address token1) = BnwSwapLibrary.sortTokens(tokenA, tokenB);
        address pair = BnwSwapFactory(factory).getPair(token0, token1);
        if (pair == address(0)) {
            pair = BnwSwapFactory(factory).createPair(token0, token1);
        }

        (uint reserve0, uint reserve1,) = BnwSwapPair(pair).getReserves();

        if (reserve0 == 0 && reserve1 == 0) {
            (amountA, amountB) = (amountADesired, amountBDesired);
        } else {
            uint amountBOptimal = BnwSwapLibrary.quote(amountADesired, reserve0, reserve1);
            if (amountBOptimal <= amountBDesired) {
                (amountA, amountB) = (amountADesired, amountBOptimal);
            } else {
                uint amountAOptimal = BnwSwapLibrary.quote(amountBDesired, reserve1, reserve0);
                require(amountAOptimal <= amountADesired, "BnwSwapRouter: INSUFFICIENT_A");
                (amountA, amountB) = (amountAOptimal, amountBDesired);
            }
        }

        IERC20(tokenA).transferFrom(msg.sender, pair, amountA);
        IERC20(tokenB).transferFrom(msg.sender, pair, amountB);
        liquidity = BnwSwapPair(pair).mint(msg.sender);
    }

    function removeLiquidity(
        address tokenA,
        address tokenB
    ) external returns (uint amountA, uint amountB) {
        (address token0, address token1) = BnwSwapLibrary.sortTokens(tokenA, tokenB);
        address pair = BnwSwapFactory(factory).getPair(token0, token1);

        BnwSwapPair bnwSwapPair = BnwSwapPair(pair);
        uint liquidity = bnwSwapPair.balanceOf(msg.sender);
        require(liquidity > 0, "BnwSwapRouter: NO_LIQUIDITY");

        (amountA, amountB) = bnwSwapPair.burn(msg.sender);
    }

    function swapExactTokensForTokens(
        uint amountIn,
        address tokenIn,
        address tokenOut,
        address to
    ) external returns (uint amountOut) {
        (address token0, address token1) = BnwSwapLibrary.sortTokens(tokenIn, tokenOut);
        address pair = BnwSwapFactory(factory).getPair(token0, token1);
        require(pair != address(0), "BnwSwapRouter: PAIR_NOT_EXIST");

        (uint reserve0, uint reserve1,) = BnwSwapPair(pair).getReserves();
        (uint reserveIn, uint reserveOut) = tokenIn == token0 ? (reserve0, reserve1) : (reserve1, reserve0);

        amountOut = BnwSwapLibrary.getAmountOut(amountIn, reserveIn, reserveOut);

        IERC20(tokenIn).transferFrom(msg.sender, pair, amountIn);
        (uint amount0Out, uint amount1Out) = tokenIn == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
        BnwSwapPair(pair).swap(amount0Out, amount1Out, to);
    }
}
