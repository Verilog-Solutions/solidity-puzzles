const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Puzzle 1", function () {

    const ONE_ETHER = ethers.utils.parseUnits("1.0", "ether");
    const initialBalance = ONE_ETHER;
    const POINT_ONE_ETHER = ethers.utils.parseUnits("0.1", "ether");
    const depositAmount = POINT_ONE_ETHER;
    let daoVictim;
    let daoAttacker;
    let owner;
    let addr1;
    let attacker;

    before(async function () {
        [owner, addr1, attacker] = await ethers.getSigners();

        const DAOVictim = await ethers.getContractFactory("DAOVictim");
        daoVictim = await DAOVictim.deploy({ value: initialBalance });
        await daoVictim.deployed();

        const DAOAttacker = await ethers.getContractFactory("DAOAttacker");
        daoAttacker = await DAOAttacker.deploy(daoVictim.address);
        await daoAttacker.deployed();
    });

    it("Test1: DAOVictim should be initialize with proper initial fund. ", async function () {
        const currentBalance = await ethers.provider.getBalance(daoVictim.address);
        expect(currentBalance).to.equal(initialBalance);
    });

    it("Test2: Legit user can store ether into DAOVictim.", async function () {
        const beforeBalanceUser1 = await addr1.getBalance();
        const beforeBalanceDAOVictim = await ethers.provider.getBalance(daoVictim.address);

        await daoVictim.connect(addr1).deposit({ value: depositAmount });

        const afterBalanceUser1 = await addr1.getBalance();
        const afterBalanceDAOVictim = await ethers.provider.getBalance(daoVictim.address);

        // BigNumber can not use built-in arithmetics:
        // https://docs.ethers.io/v5/api/utils/bignumber/#BigNumber--methods

        //expect(beforeBalanceUser1.sub(afterBalanceUser1)).to.equal(depositAmount);
        // ^ we cannot run this test since sending txn takes gas from user1's balance
        expect(afterBalanceDAOVictim.sub(beforeBalanceDAOVictim)).to.equal(depositAmount);
    });

    it("Test3: Legit user can withdraw ether from DAOVictim.", async function () {
        const beforeBalanceDAOVictim = await ethers.provider.getBalance(daoVictim.address);

        // User1 has deposited ether into DAOVictim in Test2,
        // so we do withdraw
        await daoVictim.connect(addr1).withdraw(addr1.address);

        const afterBalanceDAOVictim = await ethers.provider.getBalance(daoVictim.address);

        expect(beforeBalanceDAOVictim.sub(afterBalanceDAOVictim)).to.equal(depositAmount);
    });


    it("Attack: Attacker can withdraw ether from DAOVictim.", async function () {
        const beforeBalanceDAOVictim = await ethers.provider.getBalance(daoVictim.address);
        const beforeBalanceAttacker = await ethers.provider.getBalance(daoAttacker.address);

        console.log("beforeBalanceAttacker: " + beforeBalanceAttacker.toString());
        console.log("beforeBalanceDAOVictim: " + beforeBalanceDAOVictim.toString());

        // User1 has deposited ether into DAOVictim in Test2,
        // so we do withdraw
        await daoAttacker.connect(attacker).attack({ value: depositAmount });

        const afterBalanceDAOVictim = await ethers.provider.getBalance(daoVictim.address);
        const afterBalanceAttacker = await ethers.provider.getBalance(daoAttacker.address);

        // About `above` and `below`:
        // https://ethereum-waffle.readthedocs.io/en/latest/matchers.html#bignumbers
        expect(afterBalanceAttacker.sub(beforeBalanceAttacker)).to.above(depositAmount);
        // ^ attacker gets more than he deposit
        expect(afterBalanceDAOVictim).to.below(beforeBalanceDAOVictim.sub(depositAmount));
        // ^ victim losses more than attacker should take

        console.log("afterBalanceAttacker: " + afterBalanceAttacker.toString());
        console.log("afterBalanceDAOVictim: " + afterBalanceDAOVictim.toString());

    });
});
