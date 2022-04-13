// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./IPensionDistributor.sol";

interface IPensionVictim {
    function deposit(uint256 amount) external;

    function claim(IPensionDistributor distributor, address recipient) external;
}
