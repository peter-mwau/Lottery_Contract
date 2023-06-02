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
    
    //get the balance of the account
    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    //returns the list of players participating in the lottery
    function getPlayers() public view returns(address payable[] memory){
        return players;
    }
    
    //gets the address of the winner account
    function getLotteryHistory(uint lottery) public view returns(address payable){
        return lotteryHistory[lottery];
    }

    //enables players to enter lottery
    function enterLottery() public payable {
        require(msg.value > .01 ether);//accoutn must have more than .01 for it etther fot it to be allowed to enter lottery and transact 
        //address of player eneyering lottery and making their address payable
        players.push(payable(msg.sender));
    }

    //generates the random number which determines the winner randomnly
    function getRandomNumber() public view returns(uint){
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    //function to pick the winner using the random number generated
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
