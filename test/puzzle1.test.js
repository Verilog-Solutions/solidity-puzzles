const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Puzzle 1", function () {

    const ONE_ETHER = parseUnits("1.0", "ether");
    const initialBalance = ONE_ETHER;

    it("DAOVictim should be initialize with proper initial fund. ", async function () {
        const DAOVictim = await ethers.getContractFactory("DAOVictim");
        const daoVictim = await DAOVictim.deploy();
        await daoVictim.deployed({ value: initialBalance });

        const currentBalance = await daoVictim.balance();
        expect(currentBalance).to.equal(initialBalance);
    });
});
