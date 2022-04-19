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
import "./interface/IVictim.sol";
import "./interface/IDistributor.sol";

/// @title Victim3
/// @notice Victim contract for puzzle 3
/// @author Verilog Solutions
contract Victim3 is IVictim {
	IERC20 public token;
	mapping(address => uint256) public amounts;

	constructor(IERC20 tokenAddr) {
		token = IERC20(tokenAddr);
	}

	function deposit(uint256 amount) external override {
		token.transferFrom(msg.sender, address(this), amount);
		amounts[msg.sender] += amount;
	}

	function claim(IDistributor distributor, address recipient) external override {
		uint256 amount = amounts[msg.sender];
		distributor.distribute(recipient, amount);
		// amounts[msg.sender] = 0;
	}
}
