// SPDX-License-Identifier: GPL-3.0


pragma solidity ^0.8.0;

contract Web3ClubToken {
    string public name;
    string public symbol;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(bytes32 => bytes) private dataStore;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event DataStored(bytes32 dataHash, address indexed owner);

    constructor(string memory _name, string memory _symbol, uint256 _totalSupply) {
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply;
        balanceOf[msg.sender] = _totalSupply;
    }

    function storeData(bytes32 dataHash, bytes memory data) public {
        require(balanceOf[msg.sender] > 0, "Insufficient balance to store data");
        dataStore[dataHash] = data;
        emit DataStored(dataHash, msg.sender);
    }

    function transfer(address to, uint256 value) public {
        require(balanceOf[msg.sender] >= value, "Insufficient balance to transfer");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
    }

    function getData(bytes32 dataHash) public view returns (bytes memory) {
        return dataStore[dataHash];
    }
}
