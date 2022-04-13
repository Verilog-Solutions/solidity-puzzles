// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./IPensionVictim.sol";
import "./IPensionDistributor.sol";
import "./IPensionToken.sol";

contract PensionVictim is IPensionVictim {
    IPensionToken token;
    mapping(address => uint256) public amounts;

    constructor(IPensionToken token_address) {
        token = token_address;
    }

    function deposit(uint256 amount) external override {
        token.transferFrom(msg.sender, address(this), amount);
        amounts[msg.sender] += amount;
    }

    function claim(IPensionDistributor distributor, address recipient)
        external
        override
    {
        uint256 amount = amounts[msg.sender];
        distributor.distribute(recipient, amount);
        //amounts[msg.sender] = 0;
    }
}
