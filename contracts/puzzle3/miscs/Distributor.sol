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

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { Whitelistable } from "./Whitelistable.sol";
import { IDistributor } from "../interface/IDistributor.sol";

/// @title Distributor
/// @notice A Distributor to distribite tokens
/// @author Verilog Solutions
contract Distributor is IDistributor, Ownable, Whitelistable {
	IERC20 public token;

	constructor(IERC20 tokenAddr) {
		token = IERC20(tokenAddr);
	}

	function distribute(address recipient, uint256 amount)
		external
		override
		onlyWhitelist
	//only the PensionVictim contract address is in whitelist
	{
		token.transfer(recipient, amount);
	}
}
