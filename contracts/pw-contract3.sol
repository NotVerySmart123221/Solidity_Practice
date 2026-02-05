// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract EducationalGrant {
    address public admin;

    struct Grant {
        uint totalBalance;
        bool isCompleted;
        bool isFrozen;
        uint successRate;
    }

    mapping(address => Grant) public grants;

    event FundsDeposited(address indexed student, uint amount);
    event GoalAchieved(address indexed student, uint successRate);
    event GrantWithdrawn(address indexed student, uint amount);
    event GrantFrozen(address indexed student, bool status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "not an admin");
        _;
    }

    modifier notFrozen(address _student) {
        require(!grants[_student].isFrozen, "grant is frozen");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function deposit() external payable {
        grants[msg.sender].totalBalance += msg.value;
        emit FundsDeposited(msg.sender, msg.value);
    }

    function confirmAchievement(address _student, uint _successRate) external onlyAdmin {
        require(_successRate <= 100, "invalid success rate");
        grants[_student].isCompleted = true;
        grants[_student].successRate = _successRate;
        emit GoalAchieved(_student, _successRate);
    }

    function setFreezeStatus(address _student, bool _status) external onlyAdmin {
        grants[_student].isFrozen = _status;
        emit GrantFrozen(_student, _status);
    }

    function withdrawGrant() external notFrozen(msg.sender) {
        Grant storage myGrant = grants[msg.sender];
        
        require(myGrant.isCompleted, "goal not achieved yet");
        require(myGrant.totalBalance > 0, "no funds to withdraw");

        uint payout = (myGrant.totalBalance * myGrant.successRate) / 100;
        uint remaining = myGrant.totalBalance - payout;

        myGrant.totalBalance = 0;
        myGrant.isCompleted = false;

        payable(msg.sender).transfer(payout);
        
        if (remaining > 0) {
            payable(admin).transfer(remaining);
        }

        emit GrantWithdrawn(msg.sender, payout);
    }

    function checkGrantBalance(address _student) external view returns (uint) {
        return grants[_student].totalBalance;
    }
}