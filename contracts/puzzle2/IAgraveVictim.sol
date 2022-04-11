// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

interface IAgraveVictim {
    function deposit(uint256 amount) external;

    function withdraw(address recipient) external;
}
