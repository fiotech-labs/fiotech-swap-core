// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./interfaces/IERC20.sol";

contract BnwSwapPair {
    address public factory;
    address public token0;
    address public token1;

    uint112 private reserve0;
    uint112 private reserve1;
    uint32 private blockTimestampLast;

    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(
        address indexed sender,
        uint amount0,
        uint amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint amountIn0,
        uint amountIn1,
        uint amountOut0,
        uint amountOut1,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    constructor() {
        factory = msg.sender;
    }

    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, "BnwSwapPair: FORBIDDEN");
        token0 = _token0;
        token1 = _token1;
    }

    function _update(uint balance0, uint balance1) private {
        reserve0 = uint112(balance0);
        reserve1 = uint112(balance1);
        blockTimestampLast = uint32(block.timestamp);
        emit Sync(reserve0, reserve1);
    }

    function getReserves() external view returns (uint112, uint112, uint32) {
        return (reserve0, reserve1, blockTimestampLast);
    }

    function mint(address to) external returns (uint liquidity) {
        (uint112 _reserve0, uint112 _reserve1, ) = this.getReserves();
        uint balance0 = IERC20(token0).balanceOf(address(this));
        uint balance1 = IERC20(token1).balanceOf(address(this));
        uint amount0 = balance0 - _reserve0;
        uint amount1 = balance1 - _reserve1;

        if (totalSupply == 0) {
            liquidity = sqrt(amount0 * amount1);
        } else {
            liquidity = min(
                (amount0 * totalSupply) / _reserve0,
                (amount1 * totalSupply) / _reserve1
            );
        }

        require(liquidity > 0, "BnwSwapPair: INSUFFICIENT_LIQUIDITY_MINTED");
        balanceOf[to] += liquidity;
        totalSupply += liquidity;
        _update(balance0, balance1);
        emit Mint(msg.sender, amount0, amount1);
    }

    function burn(address to) external returns (uint amount0, uint amount1) {
        // (uint112 _reserve0, uint112 _reserve1, ) = this.getReserves();
        uint balance0 = IERC20(token0).balanceOf(address(this));
        uint balance1 = IERC20(token1).balanceOf(address(this));

        uint liquidity = balanceOf[msg.sender]; // use msg.sender
        amount0 = (liquidity * balance0) / totalSupply;
        amount1 = (liquidity * balance1) / totalSupply;
        require(
            amount0 > 0 && amount1 > 0,
            "BnwSwapPair: INSUFFICIENT_LIQUIDITY_BURNED"
        );

        balanceOf[msg.sender] = 0;
        totalSupply -= liquidity;
        IERC20(token0).transfer(to, amount0);
        IERC20(token1).transfer(to, amount1);

        balance0 = IERC20(token0).balanceOf(address(this));
        balance1 = IERC20(token1).balanceOf(address(this));
        _update(balance0, balance1);
        emit Burn(msg.sender, amount0, amount1, to);
    }

    function swap(uint amountOut0, uint amountOut1, address to) external {
        require(
            amountOut0 > 0 || amountOut1 > 0,
            "BnwSwapPair: INSUFFICIENT_OUTPUT_AMOUNT"
        );
        (uint112 _reserve0, uint112 _reserve1, ) = this.getReserves();
        require(
            amountOut0 < _reserve0 && amountOut1 < _reserve1,
            "BnwSwapPair: INSUFFICIENT_LIQUIDITY"
        );

        if (amountOut0 > 0) IERC20(token0).transfer(to, amountOut0);
        if (amountOut1 > 0) IERC20(token1).transfer(to, amountOut1);

        uint balance0 = IERC20(token0).balanceOf(address(this));
        uint balance1 = IERC20(token1).balanceOf(address(this));
        uint amountIn0 = balance0 > _reserve0 - amountOut0
            ? balance0 - (_reserve0 - amountOut0)
            : 0;
        uint amountIn1 = balance1 > _reserve1 - amountOut1
            ? balance1 - (_reserve1 - amountOut1)
            : 0;
        require(
            amountIn0 > 0 || amountIn1 > 0,
            "BnwSwapPair: INSUFFICIENT_INPUT_AMOUNT"
        );

        _update(balance0, balance1);
        emit Swap(msg.sender, amountIn0, amountIn1, amountOut0, amountOut1, to);
    }

    function min(uint x, uint y) private pure returns (uint z) {
        z = x < y ? x : y;
    }

    function sqrt(uint y) private pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}
