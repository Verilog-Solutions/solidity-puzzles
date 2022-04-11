// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./IDAOVictim.sol";

contract DAOVictim is IDAOVictim {
    mapping(address => uint256) amounts;

    constructor() payable {
        // need some intial fund to be exploit
    }

    function deposit() external payable {
        amounts[msg.sender] += msg.value;
    }

    function withdraw(address to) external {
        uint256 amount = amounts[msg.sender];
        payable(to).transfer(amount);
        amounts[msg.sender] = 0;
    }
}
