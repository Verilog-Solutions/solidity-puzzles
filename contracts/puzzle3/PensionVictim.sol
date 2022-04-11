// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./IPensionVictim.sol";
import "./IPensionDistributor.sol";

contract PensionVictim is IPensionVictim {
    mapping(address => bool) notClaimed;

    constructor() {
        //pass
    }

    function deposit() external {
        // take some erc20 token from caller
        // set notClaimed[caller] <= true
    }

    function claim(address recipient, IPensionDistributor distributor)
        external
    {
        bool isNotClaimed = notClaimed[msg.sender];
        if (isNotClaimed) {
            distributor.distribute(recipient);
        }
        notClaimed[msg.sender] = false;
    }
}
