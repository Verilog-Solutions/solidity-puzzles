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
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title Token
/// @notice Test token. Do not use it in productions
/// @author Verilog Solutions
contract Token is ERC20 {
	constructor(uint256 initialSupply) ERC20("TEST Token", "T-Token") {
		_mint(msg.sender, initialSupply);
	}

	function buy() external payable {
		// let's do a 1:1 exchange from eth to pensionToken
		_mint(msg.sender, msg.value);
	}

	// all other functions (like transfer(), balanceOf() are inherited from ERC20.)
}
