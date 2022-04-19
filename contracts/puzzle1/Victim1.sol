// SPDX-License-Identifier: GPL-3.0
/**  Do NOT use this code in production **
 __      __       _ _                _____       _       _   _                 
 \ \    / /      (_| |              / ____|     | |     | | (_)                
  \ \  / ___ _ __ _| | ___   __ _  | (___   ___ | |_   _| |_ _  ___  _ __  ___ 
   \ \/ / _ | '__| | |/ _ \ / _` |  \___ \ / _ \| | | | | __| |/ _ \| '_ \/ __|
    \  |  __| |  | | | (_) | (_| |  ____) | (_) | | |_| | |_| | (_) | | | \__ \
     \/ \___|_|  |_|_|\___/ \__, | |_____/ \___/|_|\__,_|\__|_|\___/|_| |_|___/
                             __/ |                                             
                            |___/                                              
                                                                                                                                                                                                                                        
Verilog Solutions Inc. https://www.verilog.solutions
Verilog is a full-stack web3 security firm, covering smart contract auditing, 
validator operations, venture investment, and incubation.
Glad to prepare and present the materials for Game Day Remix in DevConnect Amsterdam!
*/

pragma solidity 0.8.6;
import "./interface/IVictim.sol";

contract Victim1 is IVictim {
	mapping(address => uint256) public amounts;

	constructor() payable {
		// need some intial fund to be exploit
	}

	function deposit() external payable override {
		amounts[msg.sender] += msg.value;
	}

	function withdraw(address to) external override {
		uint256 amount = amounts[msg.sender];
		(bool success, ) = to.call{ value: amount }("");
		require(success, "DAO:: Withdraw failed.");
		amounts[msg.sender] = 0;
	}
}
