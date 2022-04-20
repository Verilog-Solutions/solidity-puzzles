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

describe("Puzzle 3", function () {
	const FIFTEEN_TOKEN = ethers.utils.parseUnits("15.0", 18);
	const initialSupply = FIFTEEN_TOKEN;
	const FIVE_TOKEN = ethers.utils.parseUnits("5.0", 18);
	const depositAmount = FIVE_TOKEN;
	let token;
	let victim;
	let attacker;
	let distributor;
	let owner;
	let addr1;
	let addr2;

	beforeEach(async function () {
		[owner, addr1, addr2] = await ethers.getSigners();

		token = await (await ethers.getContractFactory("Token")).deploy(initialSupply);

		victim = await (await ethers.getContractFactory("Victim3")).deploy(token.address);

		distributor = await (await ethers.getContractFactory("Distributor")).deploy(token.address);

		// let victim be the only one in the whitelist
		await distributor.addToWhitelist(victim.address);

		// transfer all Token from owner to distributor
		await token.transfer(distributor.address, initialSupply);

		attacker = await (await ethers.getContractFactory("Attacker3")).deploy(victim.address, token.address, distributor.address);

        // buy some Token
		await token.connect(addr1).buy({ value: depositAmount });
		await token.connect(addr2).buy({ value: depositAmount });
	});


	it("Test1: Victim should be initialize with proper initial fund (in Token). ", async function () {
		const currentBalance = await token.balanceOf(distributor.address);
		expect(currentBalance).to.equal(initialSupply);
	});

	it("Test2: Legit user can deposit Token to Victim. ", async function () {
		const beforeBalanceVictim = await token.balanceOf(victim.address);
		const beforeBalanceUser1 = await token.balanceOf(addr1.address);

		await token.connect(addr1).increaseAllowance(victim.address, depositAmount);
		await victim.connect(addr1).deposit(depositAmount);

		const afterBalanceVictim = await token.balanceOf(victim.address);
		const afterBalanceUser1 = await token.balanceOf(addr1.address);

		expect(afterBalanceVictim.sub(beforeBalanceVictim)).to.equal(depositAmount);
		expect(beforeBalanceUser1.sub(afterBalanceUser1)).to.equal(depositAmount);

		expect(await victim.amounts(addr1.address)).to.equal(depositAmount);
	});

	it("Test3: Legit user can claim Token from Victim (actually is from distributor). ", async function () {
        // deposit first 
        await token.connect(addr1).increaseAllowance(victim.address, depositAmount);
		await victim.connect(addr1).deposit(depositAmount);
        
		const beforeBalanceDistributor = await token.balanceOf(distributor.address);
		const beforeBalanceUser1 = await token.balanceOf(addr1.address);

		await victim.connect(addr1).claim(distributor.address, addr1.address);

		const afterBalancedistributor = await token.balanceOf(distributor.address);
		const afterBalanceUser1 = await token.balanceOf(addr1.address);

		expect(beforeBalanceDistributor.sub(afterBalancedistributor)).to.equal(depositAmount);
		expect(afterBalanceUser1.sub(beforeBalanceUser1)).to.equal(depositAmount);
	});

	it("Attack: Attacker can claim more Token from Victim (acutally distributor) than he deposits.", async function () {
		const beforeBalanceDistributor = await token.balanceOf(distributor.address);
		const beforeBalanceAttacker = await token.balanceOf(attacker.address);

		// increase allowance[attacker => attacker contract] and deposit token
		await token.connect(addr2).increaseAllowance(attacker.address, depositAmount);
		await attacker.connect(addr2).attack(depositAmount);

		const afterBalancedistributor = await token.balanceOf(distributor.address);
		const afterBalanceAttacker = await token.balanceOf(attacker.address);

		// About `above` and `below`:
		// https://ethereum-waffle.readthedocs.io/en/latest/matchers.html#bignumbers
		expect(afterBalanceAttacker.sub(beforeBalanceAttacker)).to.above(depositAmount);
		// ^ attacker gets more than he deposit
		expect(afterBalancedistributor).to.below(beforeBalanceDistributor.sub(depositAmount));
		// ^ victim losses more than attacker should take
	});
});
