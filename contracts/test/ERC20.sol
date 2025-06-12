// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../FiotechSwapERC20.sol";

contract ERC20 is FiotechSwapERC20 {
    constructor(uint _totalSupply) {
        _mint(msg.sender, _totalSupply);
    }
}
