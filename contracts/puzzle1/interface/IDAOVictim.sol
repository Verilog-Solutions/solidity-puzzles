// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

interface IDAOVictim {
    function deposit() external payable;

    function withdraw(address to) external;
}
