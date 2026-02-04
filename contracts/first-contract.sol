// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

import "hardhat/console.sol";

contract SecondContract{
    
}

contract FirstContract{
    // state
    bool public bool_value = true;
    /*
    || - or
    && - and

    > < >= <= == !=
    */

    int public int_value;
    /*
    int8
    int16
    int32
    int64
    int128
    int256
    */

    uint public unsingned_int;
    /*
    uint8
    uint16
    ...
    uint256
    */

    // address public owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address public owner;

    constructor()
    {
        // msg - transactions data
        owner = msg.sender;

        // msg.sender - tx-> from
        // msg.value - WEI

        // owner: address:
        //     transfer(value:wei)
        //     balance

        console.log("Congratulations: You deployed your contract");
        console.log("Your balance: ", owner.balance);
    }

    string public str1 = "String";

    function strings_demo() public returns(string memory){
        string memory temp = "temp";
        str1 = temp;
        return temp;
    }

    // ARRAYS
    uint[5] public static_array = [1,2,3,4,5];

    // uint [cols][raws] array2d;

    uint[3][2] public static_2d_array = [
        [1,2,3],
        [4,5,6]
    ];

    uint[] public dynamic_array;

    function init2darray(uint[] memory init) public{
        for(uint idx=0;idx<init.length;idx++){
            console.log("%d - %d", idx, init[idx]);
            dynamic_array.push(init[idx]);
        }
    }

    function pop() public{
        console.log("The last item: %d", dynamic_array[dynamic_array.length-1]);
        dynamic_array.pop();
    }
    
    function remove_item_by_idx(uint idx) public{
        if(idx> dynamic_array.length){
            revert("Index out of bounds of array");
        }
        delete dynamic_array[idx];
    }

    // function print_array() public {
    //     console.log("dynamic_array: ");
    //     for (uint idx=0; idx<dynamic_array.length; idx++) 
    //     {
    //         console.log("%d - %d", idx, dynamic_array[idx]);
    //     }
    // }

    function print_array() public view{
        console.log("dynamic_array: ");
        for (uint idx=0; idx<dynamic_array.length; idx++) 
        {
            console.log("%d - %d", idx, dynamic_array[idx]);
        }
    }

    // function create_array() public returns(uint[] memory){
    //     uint[] memory temp = new uint[](5);
    //     temp[0]=45;
    //     temp[1]=10;
    //     temp[2]=32;
    //     temp[3]=56;
    //     temp[4]=190;
    //     return temp;
    // }

    function create_array() public pure returns(uint[] memory){
        uint[] memory temp = new uint[](5);
        temp[0]=45;
        temp[1]=10;
        temp[2]=32;
        temp[3]=56;
        temp[4]=190;
        return temp;
    }

    // mapping ~ dictionaries

    // mapping(type => type) access_level <name>;

    mapping (address => uint) public balances;

    function write_balance() public{
        balances[msg.sender] = msg.sender.balance;
    }

    // byte-arrays

    bytes1 public one_byte = "1";

    bytes32 public bytes_fixed = "Hello, world";

    bytes public bytes_dynamic = "Hello, world";

    // function decode() public returns(string memory){
    //     return string(bytes_dynamic);
    // }

    function decode() public view returns(string memory){
        return string(bytes_dynamic);
    }

    // enums
    enum Status {Paid, Delievered, Recieved}

    Status public product_status= Status.Delievered;

    // structs

    struct Payments{
        uint value;
        uint timestamp;
        address from;
        string message;
    }

    struct Balance{
        uint total_payments;
        mapping (uint => Payments) payments;
    }

    Balance public contract_balance;

    function create_payment(string memory message) public payable{
        contract_balance.payments[contract_balance.total_payments] = Payments(
            msg.value,
            block.timestamp,
            msg.sender,
            message
        );
        contract_balance.total_payments++;
    }

    


    // function get_payment(uint number) public returns(Payments memory){
    //     if(number > contract_balance.total_payments) revert("Number gt total_payments");
    //     return contract_balance.payments[number];
    // }


    // Якщо функція тільки читає стан, і ви не обізначили її як view, вона автоматично стане транзакцією.
    // Тому за цим треба слідкувати, там де тільки читаємо помічаємо функцію як view
    function get_payment(uint number) public view returns(Payments memory){
        if(number > contract_balance.total_payments) revert("Number gt total_payments");
        return contract_balance.payments[number];
    }

    /*
        public - доступ до стану та функцій в контракті та за межами контракту
        private - доступ до стану та функцій тільки в контракті
        internal(~protected) - доступ до даних тільки в контракті та в нащадках контракту
        external - доступ тільки за межами контракту
    */

    /*
        transact - це ті функції які обгортаються у транзакцію. За їх виклик стягується комісія. За звичаєм це ті функції
        які якось змінюють стан котракту

        view - це функції які виконуються використовуючи механізм call. За їх виклик комісія не стягується. Це функції які використовуються для читання
        стану контракта

        pure - працюють за таким же принципом як і view-функції, але вони не мають доступ до стану контракту.
    
    */

    string public view_str = "contract state";

    // PURE vs VIEW

    function view_get_string() public view returns(string memory){
        return view_str;
    }

    function pure_get_string() public pure returns(string memory){
        // ! Помилка: pure функції не мають доступу до стану котракта. 
        // return view_str;
        return "Pure";
    }

    function send_to(address payable _to) public payable {
        console.log("Sender: %s, Value: %d", msg.sender, msg.value);
        // payable(_to).transfer(msg.value);
        _to.transfer(msg.value);
    }

}