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
