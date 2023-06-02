// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

contract LotteryContract{
    address public owner;
    address payable[] public players;
    uint public lotteryId =1;
    mapping (uint256 => address payable) public  lotteryHistory;

    constructor(){
        owner = msg.sender;
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function getPlayers() public view returns(address payable[] memory){
        return players;
    }

    function getLotteryHistory(uint lottery) public view returns(address payable){
        return lotteryHistory[lottery];
    }

    function enterLottery() public payable {
        require(msg.value > .01 ether);//accoutn must have more than .01 for it etther fot it to be allowed to enter lottery and transact 
        //address of player eneyering lottery and making their address payable
        players.push(payable(msg.sender));
    }

    function getRandomNumber() public view returns(uint){
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function pickWinner() public {
        require(msg.sender == owner);
        uint index = getRandomNumber() % players.length;
        players[index].transfer(address(this).balance);

        lotteryHistory[lotteryId] = players[index];
        lotteryId++;
        

        //reset the lottery for the next round
        players = new address payable [](0);
    }
}