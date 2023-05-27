// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Storage {
    struct DataEntry {
        address owner;
        string dataHash;
    }

    mapping(uint256 => DataEntry) private dataEntries;
    uint256 private latestDataId;

    event DataStored(uint256 indexed dataId, address indexed owner, string dataHash);
    event DataTransferred(uint256 indexed dataId, address indexed from, address indexed to);

    function storeData(string memory _dataHash) external {
        latestDataId++;
        dataEntries[latestDataId] = DataEntry(msg.sender, _dataHash);
        emit DataStored(latestDataId, msg.sender, _dataHash);
    }

    function transferData(uint256 _dataId, address _toAddress) external {
        DataEntry storage dataEntry = dataEntries[_dataId];
        require(dataEntry.owner == msg.sender, "You are not the owner of the data entry");
        
        dataEntry.owner = _toAddress;
        emit DataTransferred(_dataId, msg.sender, _toAddress);
    }

    function getDataEntry(uint256 _dataId) public view returns (address, string memory) {
        DataEntry storage dataEntry = dataEntries[_dataId];
        return (dataEntry.owner, dataEntry.dataHash);
    }
}
