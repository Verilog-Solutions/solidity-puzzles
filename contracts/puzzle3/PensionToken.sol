// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./IPensionToken.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PensionToken is IPensionToken, ERC20 {
    constructor() {
        //pass
    }
}
