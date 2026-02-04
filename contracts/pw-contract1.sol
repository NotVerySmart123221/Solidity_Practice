// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";

library Library {
    function find(uint[] storage self, uint value) public view returns (uint, bool) {
        for (uint i = 0; i < self.length; i++) {
            if (self[i] == value) {
                return (i, true);
            }
        }
        return (0, false);
    }

    function sort(uint[] storage self) public {
        uint n = self.length;
        for (uint i = 0; i < n; i++) {
            for (uint j = 0; j < n - i - 1; j++) {
                if (self[j] > self[j + 1]) {
                    (self[j], self[j + 1]) = (self[j + 1], self[j]);
                }
            }
        }
    }

    function remove(uint[] storage self, uint index) public {
        require(index < self.length, "out of bounds");
        for (uint i = index; i < self.length - 1; i++) {
            self[i] = self[i + 1];
        }
        self.pop();
    }
}

contract Contract {
    using Library for uint[];

    uint[] public numbers;

    function addNumb(uint _number) public {
        numbers.push(_number);
    }

    function findValue(uint _value) public view returns (uint index, bool found) {
        return numbers.find(_value);
    }

    function sortNumbs() public {
        numbers.sort();
        console.log("arr sorted");
    }

    function removeAtIndex(uint _index) public {
        numbers.remove(_index);
    }

    function getNumbers() public view returns (uint[] memory) {
        return numbers;
    }
}