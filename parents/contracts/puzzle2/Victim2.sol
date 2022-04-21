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
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";

/// @title Victim2
/// @notice Victim contract for puzzle 2
/// @author Verilog Solutions
contract Victim2 is IVictim, IERC777Recipient {
	IERC20 public token;
	mapping(address => uint256) public amounts;

	constructor(address tokenAddr) {
		token = IERC20(tokenAddr);
		// need some intial fund (in terms of AbraveToken) to be exploited
	}

	function tokensReceived(
		address operator,
		address from,
		address to,
		uint256 amount,
		bytes calldata userData,
		bytes calldata operatorData
	) external override {
		// omit all the parameter unused warnings
		operator;
		to;
		userData;
		operatorData;

		amounts[from] += amount;
	}

	function deposit(uint256 amount) external override {
		token.transferFrom(msg.sender, address(this), amount);
		//amounts[msg.sender] += amount; // this is done when tokensReceived()
	}

	function withdraw(address recipient) external override {
		uint256 amount = amounts[msg.sender];
		token.transfer(recipient, amount);
		amounts[msg.sender] = 0;
	}
}
