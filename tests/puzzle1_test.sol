// SPDX-License-Identifier: GPL-3.0
        
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
    /// #value: 100
    function beforeAll() public payable{
        // <instantiate contract>
        victim = new DAOVictim{value:10}(); // initiate DAOVictim with initial funds
        attacker = new DAOAttacker(victim);

    }

    function checkContractInitalize() public {
        console.log("victim balance", address(victim).balance);
        Assert.ok(address(victim).balance == 10, "victim contract should be intialized with value 100 ");
    }

    /// #sender: account-1
    /// #value: 1
    function attack() payable public {
        attacker.attack{value: 1}();

        // contract funds should be 0 after attack
        console.log("victim balance", address(victim).balance);
    }



    // function checkSuccess() public {
    //     // Use 'Assert' methods: https://remix-ide.readthedocs.io/en/latest/assert_library.html
    //     Assert.ok(2 == 2, 'should be true');
    //     Assert.greaterThan(uint(2), uint(1), "2 should be greater than to 1");
    //     Assert.lesserThan(uint(2), uint(3), "2 should be lesser than to 3");
    // }

    // function checkSuccess2() public pure returns (bool) {
    //     // Use the return value (true or false) to test the contract
    //     return true;
    // }
    
    // function checkFailure() public {
    //     Assert.notEqual(uint(1), uint(1), "1 should not be equal to 1");
    // }

    // /// Custom Transaction Context: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    // /// #sender: account-1
    // /// #value: 100
    // function checkSenderAndValue() public payable {
    //     // account index varies 0-9, value is in wei
    //     Assert.equal(msg.sender, TestsAccounts.getAccount(1), "Invalid sender");
    //     Assert.equal(msg.value, 100, "Invalid value");
    // }
}
    