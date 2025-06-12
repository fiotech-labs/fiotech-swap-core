// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IFiotechSwapCallee {
    function fiotechSwapCall(address sender, uint amount0, uint amount1, bytes calldata data) external;
}
