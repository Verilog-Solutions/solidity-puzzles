const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Puzzle 2", function () {

    const ONE_TEN_TOKEN = ethers.utils.parseUnits("10.0", 18);
    const initialSupply = ONE_TEN_TOKEN;
    const ONE_TOKEN = ethers.utils.parseUnits("1.0", 18);
    const depositAmount = ONE_TOKEN;
    let agraveToken;
    let agraveVictim;
    let agraveAttacker;
    let owner;
    let addr1;
    let attacker;

    before(async function () {
        [owner, addr1, attacker] = await ethers.getSigners();

        const AgraveToken = await ethers.getContractFactory("AgraveToken");
        agraveToken = await AgraveToken.deploy(initialSupply);
        await agraveToken.deployed();

        const AgraveVictim = await ethers.getContractFactory("AgraveVictim");
        agraveVictim = await AgraveVictim.deploy(agraveToken.address);
        await agraveVictim.deployed();

        // await transfer all AgraveToken from owner to agraveVictim
        await agraveToken.connect(owner).transfer(agraveVictim.address, initialSupply);

        const AgraveAttacker = await ethers.getContractFactory("AgraveAttacker");
        agraveAttacker = await AgraveAttacker.deploy(agraveVictim.address, agraveToken.address);
        await agraveAttacker.deployed();

    });

    beforeEach(async function () {
        // await user1, attacker buy some AgraveToken
        await agraveToken.connect(addr1).buy({value: depositAmount});
        await agraveToken.connect(attacker).buy({value: depositAmount});
    });

    it("Test1: AgraveVictim should be initialize with proper initial fund (in AgraveToken). ", async function () {
        const currentBalance = await agraveToken.balanceOf(agraveVictim.address);
        expect(currentBalance).to.equal(initialSupply);
    });

    it("Test2: Ligit user can deposit AgraveToken to AgraveVictim. ", async function () {
        const beforeBalanceAgraveVictim = await agraveToken.balanceOf(agraveVictim.address);
        const beforeBalanceUser1 = await agraveToken.balanceOf(addr1.address);

        await agraveToken.connect(addr1).increaseAllowance(agraveVictim.address, depositAmount);
        await agraveVictim.connect(addr1).deposit(depositAmount);

        const afterBalanceAgraveVictim = await agraveToken.balanceOf(agraveVictim.address);
        const afterBalanceUser1 = await agraveToken.balanceOf(addr1.address);

        expect(afterBalanceAgraveVictim.sub(beforeBalanceAgraveVictim)).to.equal(depositAmount);
        expect(beforeBalanceUser1.sub(afterBalanceUser1)).to.equal(depositAmount);

        expect(await agraveVictim.amounts(addr1.address)).to.equal(depositAmount);
    });

    it("Test3: Ligit user can withdraw AgraveToken from AgraveVictim. ", async function () {
        const beforeBalanceAgraveVictim = await agraveToken.balanceOf(agraveVictim.address);
        const beforeBalanceUser1 = await agraveToken.balanceOf(addr1.address);

        //await agraveToken.connect(addr1).increaseAllowance(agraveVictim.address, depositAmount);
        //await agraveVictim.connect(addr1).deposit(depositAmount);

        await agraveVictim.connect(addr1).withdraw(addr1.address);

        const afterBalanceAgraveVictim = await agraveToken.balanceOf(agraveVictim.address);
        const afterBalanceUser1 = await agraveToken.balanceOf(addr1.address);

        expect(beforeBalanceAgraveVictim.sub(afterBalanceAgraveVictim)).to.equal(depositAmount);
        expect(afterBalanceUser1.sub(beforeBalanceUser1)).to.equal(depositAmount);

        expect(await agraveVictim.amounts(addr1.address)).to.equal(0);
    });


    it("Attack: Attacker can withdraw more AgraveToken from AgraveVictim than he deposits.", async function () {
        const beforeBalanceAgraveVictim = await agraveToken.balanceOf(agraveVictim.address);
        const beforeBalanceAttacker = await agraveToken.balanceOf(agraveAttacker.address);

        console.log("beforeBalanceAttacker: " + beforeBalanceAttacker.toString());
        console.log("beforeBalanceAgraveVictim: " + beforeBalanceAgraveVictim.toString());

        // increase allowance[attacker => agraveAttacker contract]
        await agraveToken.connect(attacker).increaseAllowance(agraveAttacker.address, depositAmount);

        // agraveAttacker contract will spend attacker's AGT in attack()
        await agraveAttacker.connect(attacker).attack(depositAmount);

        const afterBalanceAgraveVictim = await agraveToken.balanceOf(agraveVictim.address);
        const afterBalanceAttacker = await agraveToken.balanceOf(agraveAttacker.address);

        console.log("afterBalanceAttacker: " + afterBalanceAttacker.toString());
        console.log("afterBalanceAgraveVictim: " + afterBalanceAgraveVictim.toString());

        // About `above` and `below`:
        // https://ethereum-waffle.readthedocs.io/en/latest/matchers.html#bignumbers
        expect(afterBalanceAttacker.sub(beforeBalanceAttacker)).to.above(depositAmount);
        // ^ attacker gets more than he deposit
        expect(afterBalanceAgraveVictim).to.below(beforeBalanceAgraveVictim.sub(depositAmount));
        // ^ victim losses more than attacker should take
    });


});
