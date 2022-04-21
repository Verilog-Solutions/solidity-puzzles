# What Is Included in Records?

## Puzzle1 Record

```
==== Setting ====
0. Address1 create DAOVictim with value = 3 ether;
1. Address2 create DAOAttacker;
==== Legit User ====
2. Address1 call deposit() in DAOVictim with value = 1 ether;
3. Address1 call withdraw(address to) in DAOVictim with parameter: address to = address(Address1);
==== Attacker ====
4. Address2 call attack() in DAOAttacker with value = 1 ether;
```

## Puzzle2 Record

```
==== Setting ====
0. erc777Token = ERC777Token.deploy(initialSupply);
1. victim = Victim.deploy(erc777Token.address);
2. erc777Token.connect(owner).transfer(victim.address, initialSupply);
3. attacker = Attacker.deploy(victim.address, erc777Token.address);
4. erc777Token.connect(addr1).buy({ value: depositAmount });
5. erc777Token.connect(addr2).buy({ value: depositAmount });
==== Legit User ====
6. erc777Token.connect(addr1).approve(victim.address, depositAmount);
7. victim.connect(addr1).deposit(depositAmount);
8. victim.connect(addr1).withdraw(addr1.address);
==== Attacker ====
9. erc777Token.connect(addr2).approve(attacker.address, depositAmount);
10. attacker.connect(addr2).attack(depositAmount);
```
