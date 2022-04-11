// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
// Please refer to https://docs.openzeppelin.com/contracts/3.x/api/token/erc777#ERC777
import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
import "./IAgraveToken.sol";

contract AgraveToken is ERC777 {
    // AgraveToken does not inherit IAgraveToken because ERC777 already has a transfer()
    // but we use IAgraveToken (containing only transfer()) for simplicity in AgraveVictim.sol
    constructor(uint256 initialSupply, address[] memory defaultOperators)
        ERC777("AgraveToken", "AGT", defaultOperators)
    {
        _mint(msg.sender, initialSupply, "", "");
    }
}
