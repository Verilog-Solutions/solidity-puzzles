# What Is Included in Records?

## Puzzle1 Record

```
1. Address1 create DAOVictim with value = 3 ether;
2. Address2 create DAOAttacker;
3. Address1 call deposit() in DAOVictim with value = 1 ether;
4. Address1 call withdraw(address to) in DAOVictim with parameter: address to = address(Address1);
5. Address2 call attack() in DAOAttacker with value = 1 ether;
```

## Puzzle2 Record

```
1. abraveToken = AbraveToken.deploy(initialSupply);
2. abraveVictim = AbraveVictim.deploy(abraveToken.address);
3. abraveToken.connect(owner).transfer(abraveVictim.address, initialSupply);
4. abraveAttacker = AbraveAttacker.deploy(abraveVictim.address, abraveToken.address);
5. abraveToken.connect(addr1).buy({ value: depositAmount });
6. abraveToken.connect(attacker).buy({ value: depositAmount });
7. abraveToken.connect(addr1).increaseAllowance(abraveVictim.address, depositAmount);
8. abraveVictim.connect(addr1).deposit(depositAmount);
9. abraveVictim.connect(addr1).withdraw(addr1.address);
10. abraveToken.connect(attacker).increaseAllowance(abraveAttacker.address, depositAmount);
11. abraveAttacker.connect(attacker).attack(depositAmount);
```

## Puzzle3 Record

```
1. pensionToken = PensionToken.deploy(initialSupply);
2. pensionVictim = PensionVictim.deploy(pensionToken.address);
3. pensionDistributor = PensionDistributor.deploy(pensionToken.address);
4. pensionDistributor.connect(owner).addToWhitelist(pensionVictim.address);
5. pensionToken.connect(owner).transfer(pensionDistributor.address, initialSupply);
6. pensionAttacker = PensionAttacker.deploy(
    pensionVictim.address, pensionToken.address, pensionDistributor.address);
7. pensionToken.connect(addr1).buy({ value: depositAmount });
8. pensionToken.connect(attacker).buy({ value: depositAmount });
9. pensionToken.connect(addr1).increaseAllowance(pensionVictim.address, depositAmount);
10. pensionVictim.connect(addr1).deposit(depositAmount);
11. pensionVictim.connect(addr1).claim(pensionDistributor.address, addr1.address);
12. pensionToken.connect(attacker).increaseAllowance(pensionAttacker.address, depositAmount);
13. pensionAttacker.connect(attacker).attack(depositAmount);
```