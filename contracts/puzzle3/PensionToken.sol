// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./IPensionToken.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PensionToken is ERC20 {
    // PensionToken does not inherit IPensionToken because ERC20 already has a transfer()
    // but we use IPensionToken (containing only transfer()) for simplicity
    // in PensionDistributor.sol
    constructor(uint256 initialSupply) ERC20("PensionToken", "PST") {
        _mint(msg.sender, initialSupply);
    }

    // all other functions (like transfer(), balanceOf() are inherited from ERC20.)
}
