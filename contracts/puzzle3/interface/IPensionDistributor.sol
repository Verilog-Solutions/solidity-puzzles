// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;


interface IPensionDistributor {
    function distribute(address recipient, uint256 amount) external;
}
