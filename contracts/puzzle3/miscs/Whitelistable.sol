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

abstract contract Whitelistable is Ownable {
	mapping(address => bool) public whitelist;

	event WhitelistChanged(address user, bool whitelisted);

	modifier onlyWhitelist() {
		// solhint-disable-next-line reason-string
		require(whitelist[msg.sender], "Whitelistable: caller not whitelisted");
		_;
	}

	function addToWhitelist(address _user) external onlyOwner {
		whitelist[_user] = true;
		emit WhitelistChanged(_user, true);
	}

	function removeFromWhitelist(address _user) external onlyOwner {
		whitelist[_user] = false;
		emit WhitelistChanged(_user, false);
	}
}
