// SPDX-License-Identifier: GPL-3.0


pragma solidity ^0.8.0;

contract Ballot {
    struct Data {
        bytes32 dataHash;
        address owner;
        uint256 voteCount;
    }

    mapping(bytes32 => Data) private dataStore;
    mapping(address => bool) private authorizedUsers;

    event DataStored(bytes32 dataHash, address indexed owner);
    event DataTransferred(bytes32 dataHash, address indexed from, address indexed to);
    event VoteCasted(bytes32 dataHash, address indexed voter);

    modifier onlyAuthorized() {
        require(authorizedUsers[msg.sender], "Only authorized users can call this function");
        _;
    }

    constructor() {
        authorizedUsers[msg.sender] = true;
    }

    function addAuthorizedUser(address user) public onlyAuthorized {
        authorizedUsers[user] = true;
    }

    function removeAuthorizedUser(address user) public onlyAuthorized {
        authorizedUsers[user] = false;
    }

    function storeData(bytes32 dataHash) public onlyAuthorized {
        require(dataStore[dataHash].owner == address(0), "Data with this hash already exists");
        dataStore[dataHash].dataHash = dataHash;
        dataStore[dataHash].owner = msg.sender;
        emit DataStored(dataHash, msg.sender);
    }

    function transferData(bytes32 dataHash, address recipient) public onlyAuthorized {
        require(dataStore[dataHash].owner == msg.sender, "You are not the owner of this data");
        require(recipient != address(0), "Invalid recipient address");
        dataStore[dataHash].owner = recipient;
        emit DataTransferred(dataHash, msg.sender, recipient);
    }

    function vote(bytes32 dataHash) public onlyAuthorized {
        require(dataStore[dataHash].owner != address(0), "Data with this hash does not exist");
        dataStore[dataHash].voteCount++;
        emit VoteCasted(dataHash, msg.sender);
    }

    function getData(bytes32 dataHash) public view returns (bytes32, address, uint256) {
        Data storage data = dataStore[dataHash];
        return (data.dataHash, data.owner, data.voteCount);
    }
}
