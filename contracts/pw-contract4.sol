// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmergencyFamilyFund {
    struct Request {
        string description;
        uint amount;
        address payable recipient;
        uint approvalsCount;
        bool executed;
        mapping(address => bool) hasVoted;
    }

    address[] public members;
    mapping(address => bool) public isMember;
    uint public requiredApprovals;
    
    Request[] public requests;

    event Deposit(address indexed sender, uint amount);
    event RequestCreated(uint indexed requestId, string description, uint amount);
    event RequestApproved(uint indexed requestId, address indexed approver);
    event PayoutExecuted(uint indexed requestId, uint amount);

    modifier onlyMember() {
        require(isMember[msg.sender], "not a family member");
        _;
    }

    constructor(address[] memory _members, uint _requiredApprovals) {
        for (uint i = 0; i < _members.length; i++) {
            address member = _members[i];
            require(member != address(0), "invalid address");
            isMember[member] = true;
            members.push(member);
        }
        requiredApprovals = _requiredApprovals;
    }

    function createRequest(string memory _description, uint _amount, address payable _recipient) external onlyMember {
        require(_amount <= address(this).balance, "not enough funds in fund");

        uint requestId = requests.length;
        Request storage newRequest = requests.push();
        newRequest.description = _description;
        newRequest.amount = _amount;
        newRequest.recipient = _recipient;
        newRequest.approvalsCount = 0;
        newRequest.executed = false;

        emit RequestCreated(requestId, _description, _amount);
    }

    function approveRequest(uint _requestId) external onlyMember {
        Request storage request = requests[_requestId];
        require(!request.executed, "already executed");
        require(!request.hasVoted[msg.sender], "already voted");

        request.hasVoted[msg.sender] = true;
        request.approvalsCount++;

        emit RequestApproved(_requestId, msg.sender);

        if (request.approvalsCount >= requiredApprovals) {
            executePayout(_requestId);
        }
    }

    function executePayout(uint _requestId) internal {
        Request storage request = requests[_requestId];
        require(!request.executed, "already executed");
        require(address(this).balance >= request.amount, "insufficient balance");
        request.executed = true;
        emit PayoutExecuted(_requestId, request.amount);
    }

    function getContractBalance() external view returns (uint) {
        return address(this).balance;
    }
}