// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

library MyLibrary{

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
}