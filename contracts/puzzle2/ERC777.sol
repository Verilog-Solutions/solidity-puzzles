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

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";

contract ERC777 is ERC20 {
    constructor(
        string memory name_,
        string memory symbol_
    ) ERC20(name_, symbol_) {
        // pass
    }

    modifier validRecipient(address _recipient) {
        require(_recipient != address(0) && _recipient != address(this), "ERC777: Invalid recipient address.");
        _;
    }

    function transfer(address _to, uint256 _value) public override returns (bool) {
        require(super.transfer(_to, _value));
        callAfterTransfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool) {
        require(super.transferFrom(_from, _to, _value));
        callAfterTransfer(_from, _to, _value);
        return true;
    }

    function callAfterTransfer(address _from, address _to, uint256 _value) internal {
        if (Address.isContract(_to)) {
            IERC777Recipient(_to).tokensReceived(
                address(0), _from, _to, _value, 
                new bytes(0), new bytes(0));
        }
    }
}