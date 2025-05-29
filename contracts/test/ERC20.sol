// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../BnwSwapERC20.sol";

contract ERC20 is BnwSwapERC20 {
    constructor(uint _totalSupply) {
        _mint(msg.sender, _totalSupply);
    }
}
