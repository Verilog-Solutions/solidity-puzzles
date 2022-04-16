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
import "./interface/IAbraveVictim.sol";
import "./interface/IAbraveToken.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";

contract AbraveVictim is IAbraveVictim, IERC777Recipient {
    IAbraveToken public token;
    mapping(address => uint256) public amounts;

    constructor(IAbraveToken token_address) {
        token = token_address;
        // need some intial fund (in terms of AbraveToken) to be exploited
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
        to;
        userData;
        operatorData;
        amounts[from] += amount;
    }

    function deposit(uint256 amount) external override {
        token.transferFrom(msg.sender, address(this), amount);
        //amounts[msg.sender] += amount; // this is done when tokensReceived()
    }

    function withdraw(address recipient) external override {
        uint256 amount = amounts[msg.sender];
        token.transfer(recipient, amount);
        amounts[msg.sender] = 0;
    }
}
