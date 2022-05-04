//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Multisig {
    event Deposit(address, uint256);
    bool public isComplete;

    function complete() public payable {
        isComplete = true;
    }
    
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
}