// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GrandmaGift {
    address public grandma;
    uint public amountPerGrandchild;
    uint public totalGrandchildren;
    
    struct Grandchild {
        uint birthday;
        bool hasWithdrawn;
        bool isRegistered;
    }

    mapping(address => Grandchild) public grandchildren;
    address[] public grandchildrenList;

    event DepositReceived(uint totalAmount, uint perPerson);
    event GiftWithdrawn(address grandchild, uint amount);

    modifier onlyGrandma() {
        require(msg.sender == grandma, "only grandma can do this");
        _;
    }

    constructor() {
        grandma = msg.sender;
    }

    function addGrandchild(address _grandchild, uint _birthday) external onlyGrandma {
        require(!grandchildren[_grandchild].isRegistered, "already done");
        
        grandchildren[_grandchild] = Grandchild({
            birthday: _birthday,
            hasWithdrawn: false,
            isRegistered: true
        });
        
        grandchildrenList.push(_grandchild);
        totalGrandchildren++;
    }

    function depositGifts() external payable onlyGrandma {
        require(msg.value > 0);
        require(totalGrandchildren > 0);
        
        amountPerGrandchild = msg.value / totalGrandchildren;
        emit DepositReceived(msg.value, amountPerGrandchild);
    }

    function claimGift() external {
        Grandchild storage child = grandchildren[msg.sender];
        
        require(child.isRegistered, "not authorized child");
        require(!child.hasWithdrawn, "already claimed");
        require(block.timestamp >= child.birthday, "wait for birthday");
        require(amountPerGrandchild > 0, "no funds available yet");

        child.hasWithdrawn = true;
        
        emit GiftWithdrawn(msg.sender, amountPerGrandchild);
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}