/**  Do NOT use this code in production **
 __      __       _ _                _____       _       _   _                 
 \ \    / /      (_| |              / ____|     | |     | | (_)                
  \ \  / ___ _ __ _| | ___   __ _  | (___   ___ | |_   _| |_ _  ___  _ __  ___ 
   \ \/ / _ | '__| | |/ _ \ / _` |  \___ \ / _ \| | | | | __| |/ _ \| '_ \/ __|
    \  |  __| |  | | | (_) | (_| |  ____) | (_) | | |_| | |_| | (_) | | | \__ \
     \/ \___|_|  |_|_|\___/ \__, | |_____/ \___/|_|\__,_|\__|_|\___/|_| |_|___/
                             __/ |                                             
                            |___/                                              
                                                                                                                                                                                                                                        
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
	let token;
	let victim;
	let attacker;
	let owner;
	let addr1;
	let addr2;

	beforeEach(async function () {
		[owner, addr1, addr2] = await ethers.getSigners();

		token = await (await ethers.getContractFactory("ERC777TestToken")).deploy(initialSupply);

		victim = await (await ethers.getContractFactory("Victim2")).deploy(token.address);

		// transfer all token from owner to victim contract
		await token.transfer(victim.address, token.balanceOf(owner.address));

		attacker = await (await ethers.getContractFactory("Attacker2")).deploy(victim.address, token.address);

		///  buy some Token
		await token.connect(addr1).buy(addr1.address, { value: depositAmount });
		await token.connect(addr2).buy(addr2.address, { value: depositAmount });
	});

	it("Test1: Victim should be initialize with proper initial fund (in token). ", async function () {
		const currentBalance = await token.balanceOf(victim.address);
		expect(currentBalance).to.equal(initialSupply);
	});

	it("Test2: Legit user can deposit token to Victim. ", async function () {
		const beforeBalanceVictim = await token.balanceOf(victim.address);
		const beforeBalanceUser1 = await token.balanceOf(addr1.address);

		await token.connect(addr1).approve(victim.address, depositAmount);
		await victim.connect(addr1).deposit(depositAmount);

		const afterBalanceVictim = await token.balanceOf(victim.address);
		const afterBalanceUser1 = await token.balanceOf(addr1.address);

		expect(afterBalanceVictim.sub(beforeBalanceVictim)).to.equal(depositAmount);
		expect(beforeBalanceUser1.sub(afterBalanceUser1)).to.equal(depositAmount);
		expect(await victim.amounts(addr1.address)).to.equal(depositAmount);
	});

	it("Test3: Legit user can withdraw token from Victim. ", async function () {
		// deposit first
		await token.connect(addr1).approve(victim.address, depositAmount);
		await victim.connect(addr1).deposit(depositAmount);

		const beforeBalanceVictim = await token.balanceOf(victim.address);
		const beforeBalanceUser1 = await token.balanceOf(addr1.address);

		await victim.connect(addr1).withdraw(addr1.address);

		const afterBalanceVictim = await token.balanceOf(victim.address);
		const afterBalanceUser1 = await token.balanceOf(addr1.address);

		expect(beforeBalanceVictim.sub(afterBalanceVictim)).to.equal(depositAmount);
		expect(afterBalanceUser1.sub(beforeBalanceUser1)).to.equal(depositAmount);
		expect(await victim.amounts(addr1.address)).to.equal(0);
	});

	it("Attack: Attacker can withdraw more token from Victim than he deposits.", async function () {
		const beforeBalanceVictim = await token.balanceOf(victim.address);
		const beforeBalanceAttacker = await token.balanceOf(attacker.address);

		// increase allowance[attacker => attacker contract]
		await token.connect(addr2).approve(attacker.address, depositAmount);
		// attacker contract will spend attacker's AGT in attack()
		await attacker.connect(addr2).attack(depositAmount);

		const afterBalanceVictim = await token.balanceOf(victim.address);
		const afterBalanceAttacker = await token.balanceOf(attacker.address);

		// About `above` and `below`:
		// https://ethereum-waffle.readthedocs.io/en/latest/matchers.html#bignumbers
		expect(afterBalanceAttacker.sub(beforeBalanceAttacker)).to.above(depositAmount);
		// ^ attacker gets more than he deposit
		expect(afterBalanceVictim).to.below(beforeBalanceVictim.sub(depositAmount));
		// ^ victim losses more than attacker should take
	});
});
