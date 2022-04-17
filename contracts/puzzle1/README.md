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
creation of DAOVictim pending...
[vm]from: 0x5B3...eddC4to: DAOVictim.(constructor)value: 3000000000000000000 weidata: 0x608...40033logs: 0hash: 0x1ec...05710
creation of DAOAttacker pending...
[vm]from: 0xAb8...35cb2to: DAOAttacker.(constructor)value: 0 weidata: 0x608...39138logs: 0hash: 0x680...08ef7
transact to DAOVictim.deposit pending ... 
[vm]from: 0x5B3...eddC4to: DAOVictim.deposit() 0xd91...39138value: 1000000000000000000 weidata: 0xd0e...30db0logs: 0hash: 0xdd0...a2729
transact to DAOVictim.withdraw pending ... 
console.log:
 Victim:: address(this) has:  4000000000000000000
 Victim:: transfer amount to address(to):  1000000000000000000
 Victim:: >>> Handing over control to address(to):  0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
 Victim:: transfer call status:  true
 
[vm]from: 0x5B3...eddC4to: DAOVictim.withdraw(address) 0xd91...39138value: 0 weidata: 0x51c...eddc4logs: 0hash: 0xda3...71b96
transact to DAOAttacker.attack pending ... 
console.log:
 Victim:: address(this) has:  4000000000000000000
 Victim:: transfer amount to address(to):  1000000000000000000
 Victim:: >>> Handing over control to address(to):  0xa131AD247055FD2e2aA8b156A11bdEc81b9eAD95
 Attacker:: >>> Taking over control from address(victim):  0xd9145CCE52D386f254917e481eB44e9943F39138
 Attacker:: Victim Balance:  3000000000000000000
 Attacker:: Balance > 1e ther, Reentering >>>  0xd9145CCE52D386f254917e481eB44e9943F39138
 Victim:: address(this) has:  3000000000000000000
 Victim:: transfer amount to address(to):  1000000000000000000
 Victim:: >>> Handing over control to address(to):  0xa131AD247055FD2e2aA8b156A11bdEc81b9eAD95
 Attacker:: >>> Taking over control from address(victim):  0xd9145CCE52D386f254917e481eB44e9943F39138
 Attacker:: Victim Balance:  2000000000000000000
 Attacker:: Balance > 1e ther, Reentering >>>  0xd9145CCE52D386f254917e481eB44e9943F39138
 Victim:: address(this) has:  2000000000000000000
 Victim:: transfer amount to address(to):  1000000000000000000
 Victim:: >>> Handing over control to address(to):  0xa131AD247055FD2e2aA8b156A11bdEc81b9eAD95
 
transact to DAOAttacker.attack errored: VM error: revert.

revert
	The transaction has been reverted to the initial state.
Note: The called function should be payable if you send value and the value you send should be less than your current balance.
Debug the transaction to get more information.
[vm]from: 0xAb8...35cb2to: DAOAttacker.attack() 0xa13...eAD95value: 1000000000000000000 weidata: 0x9e5...faafclogs: 0hash: 0x0ef...871e4
```