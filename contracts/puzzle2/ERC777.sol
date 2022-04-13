// SPDX-License-Identifier: MIT
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
        require(_recipient != address(0) && _recipient != address(this));
        /* solcov ignore next */
        _;
    }

    function transferAndCall(address _to, uint256 _value, bytes memory _data) external validRecipient(_to) returns (bool) {
        require(superTransfer(_to, _value));
        if (Address.isContract(_to)) {
            require(contractFallback(msg.sender, _to, _value, _data));
        }
        return true;
    }

    function superTransfer(address _to, uint256 _value) internal returns (bool) {
        return super.transfer(_to, _value);
    }

    function transfer(address _to, uint256 _value) public override returns (bool) {
        require(superTransfer(_to, _value));
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
            contractFallback(_from, _to, _value, new bytes(0));
        }
    }


    /**
     * @dev call onTokenTransfer fallback on the token recipient contract
     * @param _from tokens sender
     * @param _to tokens recipient
     * @param _value amount of tokens that was sent
     * @param _data set of extra bytes that can be passed to the recipient
     */
    function contractFallback(address _from, address _to, uint256 _value, bytes memory _data) private returns (bool) {
        IERC777Recipient(_to).tokensReceived(address(0), _from, _to, _value, _data, new bytes(0));
        return true;
    }
}