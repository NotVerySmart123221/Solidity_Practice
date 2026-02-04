// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

import "hardhat/console.sol";

import "lib/my_library.sol";

/*library MyLibrary{

    struct Person{
        string name;
        string surname;
        uint age;
    }

    function sum(uint a, uint b) pure public returns(uint){
        return a + b;
    }

    function get_max(uint a, uint b) pure public returns(uint){
        return a>b?a:b;
    }

    function random_person(uint age) pure public returns(Person memory){
        return Person(
            "Tom",
            "Due",
            age
        );
    }
}*/

contract SampleContract{

    using MyLibrary for uint;

    address owner;

    event NewPayment(address indexed sender, uint value);

    event WithdrawEvent(address indexed owner, uint value);

    error NotOwner(address from);

    error MinValueError(uint expected, uint current);

    modifier isOwner(){
        console.log("modifier: isOwner");
        // require(owner == msg.sender, "You're not owner");
        require(owner == msg.sender, NotOwner(msg.sender));
        _;
    }

    modifier minValue(uint min_value){
        // require(msg.value >= min_value,"Value less than minimum");
        require(msg.value >= min_value, MinValueError(min_value, msg.value));
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    function get_person() pure public returns(MyLibrary.Person memory){
        uint value=22;
        return value.random_person();
    }

    function add_ten(uint value) pure public returns(uint){

        console.log("Get max: your value: %d, other: 10, result: %d", value, value.get_max(10));

        return value.sum(10);
    }


    function sum(uint v_1, uint v_2) public pure returns(uint){
        return MyLibrary.sum(v_1, v_2);
    }

    function get_max(uint v_1, uint v_2) public pure returns(uint){
        return MyLibrary.get_max(v_1, v_2);
    }

    function donate() public payable minValue(2000){
        console.log("!!!!!!New donate!!!!!!");
        emit NewPayment(msg.sender, msg.value);
    }

    function withdraw() external isOwner(){
        // if(msg.sender != owner){
        //     console.log("You're not owner");
        //     // return;
        //     // revert("You're not owner");
        //     // revert NotOwner(msg.sender);
        // }

        // assert(owner == msg.sender);

        uint contract_balance = address(this).balance;
        payable(msg.sender).transfer(address(this).balance);
        console.log("Owner gets ETH from contract!");
        emit WithdrawEvent(msg.sender, contract_balance);
    }

    function only_owner() public view isOwner() returns(string memory){
        return "Success";
    }
}