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
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";

/// @notice simple version of ERC777. Do not use it in productions
contract ERC777TestToken is ERC20 {
	constructor(uint256 initialSupply) ERC20("ERC777 Test Token", "Token") {
		// mint some initial supply
		_mint(msg.sender, initialSupply);
	}

	// buy token with ether
	function buy(address to) external payable {
		// let's do a 1:1 exchange from eth to
		_mint(to, msg.value);
	}

	function transfer(address _to, uint256 _value) public override returns (bool) {
		require(super.transfer(_to, _value));
		callAfterTransfer(msg.sender, _to, _value);
		return true;
	}

	function transferFrom(
		address _from,
		address _to,
		uint256 _value
	) public override returns (bool) {
		require(super.transferFrom(_from, _to, _value));
		callAfterTransfer(_from, _to, _value);
		return true;
	}

	function callAfterTransfer(
		address _from,
		address _to,
		uint256 _value
	) internal {
		if (Address.isContract(_to)) {
			IERC777Recipient(_to).tokensReceived(
				address(0),
				_from,
				_to,
				_value,
				new bytes(0),
				new bytes(0)
			);
		}
	}
}
