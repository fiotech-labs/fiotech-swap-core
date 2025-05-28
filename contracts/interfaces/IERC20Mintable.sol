// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./IERC20.sol";

interface IERC20Mintable is IERC20 {
    function mint(address to, uint amount) external;
    function burn(address from, uint amount) external;
}
