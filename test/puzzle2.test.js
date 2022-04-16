// SPDX-License-Identifier: GPL-3.0
/**  Do NOT use this code in production **
    _    _           _ _             
   | |  | |         (_) |            
   | |  | |___  ____ _| | ___   ____ 
    \ \/ / _  )/ ___) | |/ _ \ / _  |
     \  ( (/ /| |   | | | |_| ( ( | |
    _ \/ \____)_|   |_|_|\___/ \_|| |
   | |        | |      _      (_____|
    \ \   ___ | |_   _| |_ (_) ___  ____   ___ 
     \ \ / _ \| | | | |  _)| |/ _ \|  _ \ /___)
 _____) ) |_| | | |_| | |__| | |_| | | | |___ |
(______/ \___/|_|\____|\___)_|\___/|_| |_(___/ 
                                               
Verilog Solutions Inc. https://www.verilog.solutions
Verilog is a full-stack web3 security firm, covering smart contract auditing, 
validator operations, venture investment, and incubation.
Glad to prepare and present the materials for Game Day Remix in DevConnect Amsterdam!
*/

const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Puzzle 2", function () {

    const ONE_TEN_TOKEN = ethers.utils.parseUnits("10.0", 18);
    const initialSupply = ONE_TEN_TOKEN;
    const FIVE_TOKEN = ethers.utils.parseUnits("5.0", 18);
    const depositAmount = FIVE_TOKEN;
    let abraveToken;
    let abraveVictim;
    let abraveAttacker;
    let owner;
    let addr1;
    let attacker;

    before(async function () {
        [owner, addr1, attacker] = await ethers.getSigners();

        const AbraveToken = await ethers.getContractFactory("AbraveToken");
        abraveToken = await AbraveToken.deploy(initialSupply);
        await abraveToken.deployed();

        const AbraveVictim = await ethers.getContractFactory("AbraveVictim");
        abraveVictim = await AbraveVictim.deploy(abraveToken.address);
        await abraveVictim.deployed();

        // transfer all AbraveToken from owner to abraveVictim contract
        await abraveToken.connect(owner).transfer(abraveVictim.address, initialSupply);

        const AbraveAttacker = await ethers.getContractFactory("AbraveAttacker");
        abraveAttacker = await AbraveAttacker.deploy(abraveVictim.address, abraveToken.address);
        await abraveAttacker.deployed();

    });

    beforeEach(async function () {
        // let user1 and attacker buy some AbraveToken
        await abraveToken.connect(addr1).buy({ value: depositAmount });
        await abraveToken.connect(attacker).buy({ value: depositAmount });
    });

    it("Test1: AbraveVictim should be initialize with proper initial fund (in AbraveToken). ", async function () {
        const currentBalance = await abraveToken.balanceOf(abraveVictim.address);
        expect(currentBalance).to.equal(initialSupply);
    });

    it("Test2: Legit user can deposit AbraveToken to AbraveVictim. ", async function () {
        const beforeBalanceAbraveVictim = await abraveToken.balanceOf(abraveVictim.address);
        const beforeBalanceUser1 = await abraveToken.balanceOf(addr1.address);

        await abraveToken.connect(addr1).increaseAllowance(abraveVictim.address, depositAmount);
        await abraveVictim.connect(addr1).deposit(depositAmount);

        const afterBalanceAbraveVictim = await abraveToken.balanceOf(abraveVictim.address);
        const afterBalanceUser1 = await abraveToken.balanceOf(addr1.address);

        expect(afterBalanceAbraveVictim.sub(beforeBalanceAbraveVictim)).to.equal(depositAmount);
        expect(beforeBalanceUser1.sub(afterBalanceUser1)).to.equal(depositAmount);
        expect(await abraveVictim.amounts(addr1.address)).to.equal(depositAmount);
    });

    it("Test3: Legit user can withdraw AbraveToken from AbraveVictim. ", async function () {
        const beforeBalanceAbraveVictim = await abraveToken.balanceOf(abraveVictim.address);
        const beforeBalanceUser1 = await abraveToken.balanceOf(addr1.address);

        await abraveVictim.connect(addr1).withdraw(addr1.address);

        const afterBalanceAbraveVictim = await abraveToken.balanceOf(abraveVictim.address);
        const afterBalanceUser1 = await abraveToken.balanceOf(addr1.address);

        expect(beforeBalanceAbraveVictim.sub(afterBalanceAbraveVictim)).to.equal(depositAmount);
        expect(afterBalanceUser1.sub(beforeBalanceUser1)).to.equal(depositAmount);
        expect(await abraveVictim.amounts(addr1.address)).to.equal(0);
    });


    it("Attack: Attacker can withdraw more AbraveToken from AbraveVictim than he deposits.", async function () {
        const beforeBalanceAbraveVictim = await abraveToken.balanceOf(abraveVictim.address);
        const beforeBalanceAttacker = await abraveToken.balanceOf(abraveAttacker.address);

        console.log("beforeBalanceAttacker: " + beforeBalanceAttacker.toString());
        console.log("beforeBalanceAbraveVictim: " + beforeBalanceAbraveVictim.toString());

        // increase allowance[attacker => abraveAttacker contract]
        await abraveToken.connect(attacker).increaseAllowance(abraveAttacker.address, depositAmount);
        // abraveAttacker contract will spend attacker's AGT in attack()
        await abraveAttacker.connect(attacker).attack(depositAmount);

        const afterBalanceAbraveVictim = await abraveToken.balanceOf(abraveVictim.address);
        const afterBalanceAttacker = await abraveToken.balanceOf(abraveAttacker.address);

        console.log("afterBalanceAttacker: " + afterBalanceAttacker.toString());
        console.log("afterBalanceAbraveVictim: " + afterBalanceAbraveVictim.toString());

        // About `above` and `below`:
        // https://ethereum-waffle.readthedocs.io/en/latest/matchers.html#bignumbers
        expect(afterBalanceAttacker.sub(beforeBalanceAttacker)).to.above(depositAmount);
        // ^ attacker gets more than he deposit
        expect(afterBalanceAbraveVictim).to.below(beforeBalanceAbraveVictim.sub(depositAmount));
        // ^ victim losses more than attacker should take
    });


});
