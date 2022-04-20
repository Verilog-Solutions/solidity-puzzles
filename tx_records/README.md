# What Is Included in Records?

## Puzzle1 Record

```
==== Setting ====
0. Address1 create Victim1 with value = 3 ether;
1. Address2 create Attacker1;
==== Legit User ====
2. Address1 call deposit() in Victim1 with value = 1 ether;
3. Address1 call withdraw(address to) in Victim1 with parameter: address to = address(Address1);
==== Attacker ====
4. Address2 call attack() in Attacker1 with value = 1 ether;
```

## Puzzle2 Record

```
==== Setting ====
0. token = ERC777TestToken.deploy(initialSupply);
1. Victim2 = Victim2.deploy(token.address);
2. token.connect(owner).transfer(Victim2.address, initialSupply);
3. Attacker2 = Attacker2.deploy(Victim2.address, token.address);
4. token.connect(addr1).buy(addr1.address, { value: depositAmount });
5. token.connect(attacker).buy(addr1.address, { value: depositAmount });
==== Legit User ====
6. token.connect(addr1).increaseAllowance(Victim2.address, depositAmount);
7. Victim2.connect(addr1).deposit(depositAmount);
8. Victim2.connect(addr1).withdraw(addr1.address);
==== Attacker ====
9. token.connect(attacker).increaseAllowance(Attacker2.address, depositAmount);
10. Attacker2.connect(attacker).attack(depositAmount);
```
