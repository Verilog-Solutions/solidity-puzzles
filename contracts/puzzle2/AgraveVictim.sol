// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./IAgraveVictim.sol";
import "./IAgraveToken.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";

contract AgraveVictim is IAgraveVictim, IERC777Recipient {
    IAgraveToken token;
    mapping(address => uint256) amounts;

    constructor(IAgraveToken token_address) {
        token = token_address;
        // need some intial fund (in terms of AgraveToken) to be exploit
    }

    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external override {
        // omit all the parameter unused warnings
        operator;
        from;
        to;
        userData;
        operatorData;
        amounts[msg.sender] += amount;
    }

    function deposit(uint256 amount) external override {
        token.transferFrom(msg.sender, address(this), amount);
        //amounts[msg.sender] += amount; // this is done by tokensReceived()
    }

    function withdraw(address recipient) external override {
        uint256 amount = amounts[msg.sender];
        token.transfer(recipient, amount);
        amounts[msg.sender] = 0;
    }
}
