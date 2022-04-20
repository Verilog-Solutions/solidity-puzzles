require("@nomiclabs/hardhat-waffle");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
	solidity: "0.8.6",

	paths: {
		sources: "./contracts",
		tests: "./tests",
	},
};
