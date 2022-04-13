// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./interface/IDAOVictim.sol";

contract DAOVictim is IDAOVictim {
    mapping(address => uint256) amounts;

    constructor() payable {
        // need some intial fund to be exploit
    }

    function deposit() external payable override {
        amounts[msg.sender] += msg.value;
    }

    function withdraw(address to) external override {
        uint256 amount = amounts[msg.sender];
        (bool success, ) = to.call{value: amount}("");
        require(success, "DAO:: Withdraw failed.");
        amounts[msg.sender] = 0;
    }
}
