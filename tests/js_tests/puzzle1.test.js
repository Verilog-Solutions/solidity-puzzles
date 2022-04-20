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

// import {""} from "../contracts/puzzle1/artifacts/Attacker1.json";
// import {} from "../contracts/puzzle1/artifacts/Victim1.json";

describe("Puzzle 1", function () {
	const ONE_ETHER = ethers.utils.parseUnits("1.0", "ether");
	const initialBalance = ONE_ETHER;
	const POINT_FIVE_ETHER = ethers.utils.parseUnits("0.5", "ether");
	const depositAmount = POINT_FIVE_ETHER;
	let victim;
	let attacker;
	let owner;
	let addr1;
	let addr2;

	beforeEach(async function () {
		[owner, addr1, addr2] = await ethers.getSigners();

		victim = await (await ethers.getContractFactory("Victim1")).deploy({ value: initialBalance });

		attacker = await (await ethers.getContractFactory("Attacker1")).deploy(victim.address);
	});

	it("Test1: Victim should be initialize with proper initial fund. ", async function () {
		const currentBalance = await ethers.provider.getBalance(victim.address);
		expect(currentBalance).to.equal(initialBalance);
	});

	it("Test2: Legit user can store ether into Victim.", async function () {
		const beforeBalanceUser1 = await addr1.getBalance();
		const beforeBalanceVictim = await ethers.provider.getBalance(victim.address);

		await victim.connect(addr1).deposit({ value: depositAmount });

		const afterBalanceUser1 = await addr1.getBalance();

		const afterBalanceVictim = await ethers.provider.getBalance(victim.address);

		// it's gte(greater or equal bc of tx gas cost)
		expect(beforeBalanceUser1.sub(afterBalanceUser1)).to.gte(depositAmount);

		expect(afterBalanceVictim.sub(beforeBalanceVictim)).to.equal(depositAmount);
	});

	it("Test3: Legit user can withdraw ether from Victim.", async function () {
		// deposit first
		await victim.connect(addr1).deposit({ value: depositAmount });

		const beforeBalanceVictim = await ethers.provider.getBalance(victim.address);

		// withdraw
		await victim.connect(addr1).withdraw(addr1.address);

		const afterBalanceVictim = await ethers.provider.getBalance(victim.address);

		expect(beforeBalanceVictim.sub(afterBalanceVictim)).to.equal(depositAmount);
	});

	it("Attack: Attacker can withdraw ether from Victim.", async function () {
		const beforeBalanceVictim = await ethers.provider.getBalance(victim.address);
		const beforeBalanceAttacker = await ethers.provider.getBalance(attacker.address);

		// balance(Victim) = 1 ether; balance(AttackerDeposit) = .5 ether;
		// so it reenter twice (aka withdraw three times) to drain the Victim.
		// You'll see in the console logs.
		await attacker.connect(addr2).attack({ value: depositAmount });

		const afterBalanceVictim = await ethers.provider.getBalance(victim.address);
		const afterBalanceAttacker = await ethers.provider.getBalance(attacker.address);

		// About `above` and `below`:
		// https://ethereum-waffle.readthedocs.io/en/latest/matchers.html#bignumbers
		expect(afterBalanceAttacker.sub(beforeBalanceAttacker)).to.above(depositAmount);
		// ^ attacker gets more than he deposit
		expect(afterBalanceVictim).to.below(beforeBalanceVictim.sub(depositAmount));

	});
});
