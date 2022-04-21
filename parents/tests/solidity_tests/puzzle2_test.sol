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

pragma solidity ^0.8.0;

// This import is automatically injected by Remix
import "remix_tests.sol";

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
// <import file to test>
import "hardhat/console.sol";
import "../../contracts/puzzle2/token/ERC777TestToken.sol";
import "../../contracts/puzzle2/Victim2.sol";
import "../../contracts/puzzle2/Attacker2.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract puzzle2_test {
	ERC777TestToken token;
	Victim2 victim;
	Attacker2 attacker;

	/// 'beforeAll' runs before all other tests
	/// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
	/// #sender: account-0
	/// #value: 100
	function beforeAll() public payable {
		// <instantiate contract>
		token = new ERC777TestToken(0); // token is minted to account-0

		victim = new Victim2(address(token));
		attacker = new Attacker2(address(victim), address(token));
	}

	/// Attacker: Attacker can withdraw more ERC777TestToken from Victim2 than he deposits
	/// #sender: account-0
	/// #value: 11000000000000000000
	function attack() public payable {
		// deposit 10 tokens to victim

		token.buy{ value: msg.value }(address(this));
		token.approve(address(attacker), 1e18);
		token.approve(address(victim), 10e18);
		victim.deposit(10e18);

		// attack
		uint256 amount = 1e18;
		uint256 balanceBeforeAttacker = token.balanceOf(address(attacker));

		attacker.attack(amount);

		uint256 balanceAfterAttacker = token.balanceOf(address(attacker));

		Assert.greaterThan(
			balanceAfterAttacker - balanceBeforeAttacker,
			amount,
			"attacker should revceive more token"
		);
	}
}
