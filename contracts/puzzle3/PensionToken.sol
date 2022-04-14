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
validator opertions, venture investment, and incubation.
Glad to prepare and present the materials for Game Day Remix in DevConnect Amsterdam!
*/

pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./interface/IPensionToken.sol";

contract PensionToken is ERC20 {
    // PensionToken does not inherit IPensionToken because ERC20 already has a transfer()
    // but we use IPensionToken (containing only transfer()) for simplicity
    // in PensionDistributor.sol
    constructor(uint256 initialSupply) ERC20("PensionToken", "PST") {
        _mint(msg.sender, initialSupply);
    }


    function buy() external payable {
        // let's do a 1:1 exchange from eth to pensionToken
        _mint(msg.sender, msg.value);
    }


    // all other functions (like transfer(), balanceOf() are inherited from ERC20.)
}
