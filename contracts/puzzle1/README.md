# How to Replicate

tl,dr;: Running `attack()`/tests on `attack()` fails on Remix JSVM, but it works well in Hardhat node.

## With Hardhat Tests in Remix w/o hardhat node

Clone this branch and run the test (`puzzle1.test.js`).

For more details, refer to the readme doc at root dir.

My output is

```
Running tests....
 Puzzle 1
   ✓ Test1: DAOVictim should be initialize with proper initial fund.  (7 ms)
   ✓ Test2: Legit user can store ether into DAOVictim. (118 ms)
   ✓ Test3: Legit user can withdraw ether from DAOVictim. (341 ms)
beforeBalanceAttacker: 0
beforeBalanceDAOVictim: 1000000000000000000
   ✘ Attack: Attacker can withdraw ether from DAOVictim. (366 ms)
     Expected: 0
     Actual: 500000000000000000
     Message: Expected "0" to be above 500000000000000000
3 passing, 1 failing (1048 ms)
```

## With Remix Only

Clone this branch and replay `txn_record_puzzle1_bug.json`.

How to replay:
1. Open the `txn_record_puzzle1_bug.json` file, make sure it the the active tab in remix;
2. Go to `DEPLOY & RUN TRANSACTIONS` > `Transactions recorded`;
3. You will see the number is 0, but no worry, expand this toggle and click the `play` button;
4. You'll go some results like what is shown below.


```
what is done in the json file
1. Address1 create DAOVictim with value = 3 ether;
2. Address2 create DAOAttacker;
3. Address1 call deposit() in DAOVictim with value = 1 ether;
4. Address1 call withdraw(address to) in DAOVictim with parameter: address to = address(Address1);
5. Address2 call attack() in DAOAttacker with value = 1 ether;
```

My output is
```
Running 5 transaction(s) ...
(0) {
	"value": "3000000000000000000",
	"parameters": [],
	"abi": "0x5628658acaf3b5010d8b3927e0449d78c83ba9792fcc116c75ba833a63dfa7f0",
	"contractName": "DAOVictim",
	"bytecode": "I JUST REMOVE IT",
	"linkReferences": {},
	"name": "",
	"inputs": "()",
	"type": "constructor",
	"from": "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4"
}
(0) data: I JUST REMOVE IT
(1) {
	"value": "0",
	"parameters": [
		"0xDA0bab807633f07f013f94DD0E6A4F96F8742B53"
	],
	"abi": "0x28e2ec147ccaac8c352ab53bd66b8187d2ab8c0dc4b881cec5748aa81d5051b5",
	"contractName": "DAOAttacker",
	"bytecode": "I JUST REMOVE IT",
	"linkReferences": {},
	"name": "",
	"inputs": "(address)",
	"type": "constructor",
	"from": "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"
}
(1) data: I JUST REMOVE IT
[vm]from: 0x5B3...eddC4to: DAOVictim.(constructor)value: 3000000000000000000 weidata: 0x608...40033logs: 0hash: 0xad2...14169
(2) {
	"value": "1000000000000000000",
	"parameters": [],
	"to": "0xDA0bab807633f07f013f94DD0E6A4F96F8742B53",
	"abi": "0x5628658acaf3b5010d8b3927e0449d78c83ba9792fcc116c75ba833a63dfa7f0",
	"name": "deposit",
	"inputs": "()",
	"type": "function",
	"from": "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4"
}
(2) data: 0xd0e30db0
[vm]from: 0xAb8...35cb2to: DAOAttacker.(constructor)value: 0 weidata: 0x608...42b53logs: 0hash: 0x952...2a76f
(3) {
	"value": "0",
	"parameters": [
		"0x5B38Da6a701c568545dCfcB03FcB875f56beddC4"
	],
	"to": "0xDA0bab807633f07f013f94DD0E6A4F96F8742B53",
	"abi": "0x5628658acaf3b5010d8b3927e0449d78c83ba9792fcc116c75ba833a63dfa7f0",
	"name": "withdraw",
	"inputs": "(address)",
	"type": "function",
	"from": "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4"
}
(3) data: 0x51cff8d90000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4
[vm]from: 0x5B3...eddC4to: DAOVictim.deposit() 0xDA0...42B53value: 1000000000000000000 weidata: 0xd0e...30db0logs: 0hash: 0x465...061f1
console.log:
 Victim:: address(this) has:  4000000000000000000
 Victim:: transfer amount to address(to):  1000000000000000000
 Victim:: >>> Handing over control to address(to):  0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
 Victim:: transfer call status:  true
 
(4) {
	"value": "1000000000000000000",
	"parameters": [],
	"to": "0xA831F4e5dC3dbF0e9ABA20d34C3468679205B10A",
	"abi": "0x28e2ec147ccaac8c352ab53bd66b8187d2ab8c0dc4b881cec5748aa81d5051b5",
	"name": "attack",
	"inputs": "()",
	"type": "function",
	"from": "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"
}
(4) data: 0x9e5faafc
[vm]from: 0x5B3...eddC4to: DAOVictim.withdraw(address) 0xDA0...42B53value: 0 weidata: 0x51c...eddc4logs: 0hash: 0xf40...2cdf6
console.log:
 Victim:: address(this) has:  4000000000000000000
 Victim:: transfer amount to address(to):  1000000000000000000
 Victim:: >>> Handing over control to address(to):  0xA831F4e5dC3dbF0e9ABA20d34C3468679205B10A
 Attacker:: >>> Taking over control from address(victim):  0xDA0bab807633f07f013f94DD0E6A4F96F8742B53
 Attacker:: Victim Balance:  3000000000000000000
 Attacker:: Balance > 1e ther, Reentering >>>  0xDA0bab807633f07f013f94DD0E6A4F96F8742B53
 Victim:: address(this) has:  3000000000000000000
 Victim:: transfer amount to address(to):  1000000000000000000
 Victim:: >>> Handing over control to address(to):  0xA831F4e5dC3dbF0e9ABA20d34C3468679205B10A
 Attacker:: >>> Taking over control from address(victim):  0xDA0bab807633f07f013f94DD0E6A4F96F8742B53
 Attacker:: Victim Balance:  2000000000000000000
 Attacker:: Balance > 1e ther, Reentering >>>  0xDA0bab807633f07f013f94DD0E6A4F96F8742B53
 Victim:: address(this) has:  2000000000000000000
 Victim:: transfer amount to address(to):  1000000000000000000
 Victim:: >>> Handing over control to address(to):  0xA831F4e5dC3dbF0e9ABA20d34C3468679205B10A
 
VM error: revert.

revert
	The transaction has been reverted to the initial state.
Note: The called function should be payable if you send value and the value you send should be less than your current balance.
Debug the transaction to get more information.. Execution failed at 4
[vm]from: 0xAb8...35cb2to: DAOAttacker.attack() 0xA83...5B10Avalue: 1000000000000000000 weidata: 0x9e5...faafclogs: 0hash: 0xaad...d2bdc

```