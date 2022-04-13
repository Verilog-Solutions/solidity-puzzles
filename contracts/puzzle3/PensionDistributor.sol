// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IPensionDistributor.sol";
import "./IPensionToken.sol";
import "./Whitelistable.sol";

contract PensionDistributor is IPensionDistributor, Ownable, Whitelistable {
    IPensionToken token;

    constructor(IPensionToken token_address) {
        token = token_address;
    }

    function distribute(address recipient, uint256 amount)
        external
        onlyWhitelist //only the PensionVictim contract address in whitelist
    {
        token.transfer(recipient, amount);
    }
}
