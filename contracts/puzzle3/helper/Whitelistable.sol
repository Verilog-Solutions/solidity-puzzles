// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract Whitelistable is Ownable {
    mapping(address => bool) public whitelist;

    event WhitelistChanged(address user, bool whitelisted);

    modifier onlyWhitelist() {
        // solhint-disable-next-line reason-string
        require(whitelist[msg.sender], "Whitelistable: caller not whitelisted");
        _;
    }

    function addToWhitelist(address _user) external onlyOwner {
        whitelist[_user] = true;
        emit WhitelistChanged(_user, true);
    }

    function removeFromWhitelist(address _user) external onlyOwner {
        whitelist[_user] = false;
        emit WhitelistChanged(_user, false);
    }
}
