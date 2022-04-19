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
import "../contracts/puzzle1/DAOAttacker.sol";
import "../contracts/puzzle1/DAOVictim.sol";

// import "../contracts/puzzle1/interface/IDAOVictim.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract puzzle1_test {
	DAOVictim victim;
	DAOAttacker attacker;

	/// 'beforeAll' runs before all other tests
	/// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
	/// #sender: account-0
	/// #value: 1000000000000000000
	function beforeAll() public payable {
		// <instantiate contract>

		console.log("address account0", msg.sender);
		victim = new DAOVictim{ value: msg.value }(); // initiate DAOVictim with initial funds
		attacker = new DAOAttacker(victim);

		console.log("attacker balance", address(attacker).balance);
	}

	/// Test1: DAOVictim should be initialize with proper initial fund.
	function test_DAOVictim_Initalize() public {
		Assert.ok(
			address(victim).balance == 1 ether,
			"victim contract should be intialized with value 100 "
		);
	}

	/// Attack: Attacker can withdraw more ether from DAOVictim.
	/// #sender: account-1
	/// #value: 500000000000000000
	function attack() public payable {
		uint256 depositAmount = msg.value; // 0.5 ether

		uint256 beforeBalanceAttacker = address(attacker).balance;

		attacker.attack{ value: depositAmount }();

		uint256 afterBalanceAttacker = address(attacker).balance;

		Assert.greaterThan(
			afterBalanceAttacker - beforeBalanceAttacker,
			depositAmount,
			"Attacker should be able to withdraw more funds"
		);
	}
}
