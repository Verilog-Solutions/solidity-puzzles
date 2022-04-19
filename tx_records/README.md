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
0. abraveToken = AbraveToken.deploy(initialSupply);
1. abraveVictim = AbraveVictim.deploy(abraveToken.address);
2. abraveToken.connect(owner).transfer(abraveVictim.address, initialSupply);
3. abraveAttacker = AbraveAttacker.deploy(abraveVictim.address, abraveToken.address);
4. abraveToken.connect(addr1).buy({ value: depositAmount });
5. abraveToken.connect(attacker).buy({ value: depositAmount });
==== Legit User ====
6. abraveToken.connect(addr1).increaseAllowance(abraveVictim.address, depositAmount);
7. abraveVictim.connect(addr1).deposit(depositAmount);
8. abraveVictim.connect(addr1).withdraw(addr1.address);
==== Attacker ====
9. abraveToken.connect(attacker).increaseAllowance(abraveAttacker.address, depositAmount);
10. abraveAttacker.connect(attacker).attack(depositAmount);
```

## Puzzle3 Record

```
==== Setting ====
0. pensionToken = PensionToken.deploy(initialSupply);
1. pensionVictim = PensionVictim.deploy(pensionToken.address);
2. pensionDistributor = PensionDistributor.deploy(pensionToken.address);
3. pensionDistributor.connect(owner).addToWhitelist(pensionVictim.address);
4. pensionToken.connect(owner).transfer(pensionDistributor.address, initialSupply);
5. pensionAttacker = Attacker.deploy(
    pensionVictim.address, pensionToken.address, pensionDistributor.address);
6. pensionToken.connect(addr1).buy({ value: depositAmount });
7. pensionToken.connect(attacker).buy({ value: depositAmount });
==== Legit User ====
8. pensionToken.connect(addr1).increaseAllowance(pensionVictim.address, depositAmount);
9. pensionVictim.connect(addr1).deposit(depositAmount);
10. pensionVictim.connect(addr1).claim(pensionDistributor.address, addr1.address);
==== Attacker ====
11. pensionToken.connect(attacker).increaseAllowance(pensionAttacker.address, depositAmount);
12. pensionAttacker.connect(attacker).attack(depositAmount);
```