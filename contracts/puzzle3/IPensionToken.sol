// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

interface IPensionToken {
    function balanceOf(address owner) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external;

    function transferFrom(
        address holder,
        address recipient,
        uint256 amount
    ) external;

    function increaseAllowance(
        address spender, 
        uint256 addedValue
    ) external;
}
