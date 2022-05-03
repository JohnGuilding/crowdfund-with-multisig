// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import './Multisig.sol';

contract Crowdfund {

    Multisig public multisig;
    
    mapping(address => uint) public balances;

    uint256 public constant threshold = 1 ether;
    uint256 public deadline = block.timestamp + 1 seconds;

    event SendFunds(address _from, uint256 _amount);

    constructor(address multisigAddress) public {
        multisig = Multisig(multisigAddress);
    }

    function sendFunds() public payable {

    }

    function execute() public {

    }

    function timeLeft() public {

    }
    
    function withdraw() public {

    }
}