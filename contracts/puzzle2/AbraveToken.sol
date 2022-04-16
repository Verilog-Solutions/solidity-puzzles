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
import "./ERC777.sol";
import "./interface/IAbraveToken.sol";

contract AbraveToken is ERC777 {
    // Please refer to the URL for a detailed ERC-777 intro
    // https://docs.openzeppelin.com/contracts/3.x/api/token/erc777
    constructor(uint256 initialSupply)
        ERC777("AbraveToken", "AGT")
    {
        _mint(msg.sender, initialSupply);
    }

    function buy() external payable {
        // let's do a 1:1 exchange from eth to abraveToken
        _mint(msg.sender, msg.value);
    }
}
