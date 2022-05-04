// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Multisig.sol";

contract Crowdfund {
    Multisig public multisig;
    address public multisigAddress;

    mapping(address => uint256) public balances;

    uint256 public constant threshold = 0.3 ether;
    uint256 public deadline = block.timestamp + 30 seconds;

    event SendFunds(address _from, uint256 _amount);

    modifier deadlinePassed(bool requireDeadlinePassed) {
        uint256 timeRemaining = timeLeft();
        if (requireDeadlinePassed) {
            require(timeRemaining == 0, "Deadline has not elapsed");
            _;
        }
        require(timeRemaining > 0, "Deadline has passed");
        _;
    }

    modifier crowdfundNotCompleted() {
        require(multisig.isComplete() == false, "staking period not over");
        _;
    }

    constructor(address payable _multisigAddress) public {
        multisig = Multisig(_multisigAddress);
        multisigAddress = _multisigAddress;
    }

    function pledgeFunds() public payable deadlinePassed(false) {
        balances[msg.sender] = msg.value;
        emit SendFunds(msg.sender, msg.value);
    }

    function unpledgeFunds() public deadlinePassed(true) crowdfundNotCompleted {
        uint256 contractBalance = balances[msg.sender];
        require(contractBalance > 0, "contract balance must be more than zero");

        balances[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: contractBalance}("");
        require(success, "Call failed");
    }

    function execute() public payable crowdfundNotCompleted {
        require(block.timestamp >= deadline, "Wait for the deadline");
        uint256 contractBalance = address(this).balance;
        if (contractBalance >= threshold) {
            (bool success, ) = multisigAddress.call{value: msg.value}("");
            require(success, "Call failed");
        }
    }

    function timeLeft() public view returns (uint256) {
        return block.timestamp >= deadline ? 0 : deadline - block.timestamp;
    }

    receive() external payable {
        pledgeFunds();
    }
}
