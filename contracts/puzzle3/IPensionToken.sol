// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

interface IPensionToken {
    function transfer(address to, uint256 amount) external;

    function transferFrom(
        address holder,
        address recipient,
        uint256 amount
    ) external;
}
