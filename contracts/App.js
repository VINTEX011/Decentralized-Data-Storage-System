const Web3 = require('web3');
const contractAbi = require('./DigitalDataStorage.abi.json');

// Modify the following values with your own settings
const infuraUrl = 'https://eth-sepolia.g.alchemy.com/v2/whnXu71YwPGQTdxqQRPRDk7e9bAB8xJ6';
const privateKey = 'b1afe3cc96fa18497842bf3aeafa0f3a3091955c2c56b34a9b85e8bac4519bff';
const contractAddress = '0x5B38Da6a701c568545dCfcB03FcB875f56beddC4';

const web3 = new Web3(new Web3.providers.HttpProvider(infuraUrl));
const contract = new web3.eth.Contract(contractAbi, contractAddress);
const account = web3.eth.accounts.privateKeyToAccount(privateKey);
web3.eth.accounts.wallet.add(account);

async function storeData() {
    const dataInput = document.getElementById('dataInput');
    const data = dataInput.value;
    if (data) {
        try {
            await contract.methods.storeData(data).send({ from: account.address });
            dataInput.value = '';
            getDataList();
        } catch (error) {
            console.error('Error storing data:', error);
        }
    }
}

async function transferData() {
    const indexInput = document.getElementById('indexInput');
    const recipientInput = document.getElementById('recipientInput');
    const index = parseInt(indexInput.value);
    const recipient = recipientInput.value;
    if (index && recipient) {
        try {
            await contract.methods.transferData(index, recipient).send({ from: account.address });
            indexInput.value = '';
            recipientInput.value = '';
            getDataList();
        } catch (error) {
            console.error('Error transferring data:', error);
        }
    }
}

async function getDataList() {
    const dataList = document.getElementById('dataList');
    dataList.innerHTML = '';

    try {
        const dataCounter = await contract.methods.balanceOf(account.address).call();
        for (let i = 1; i <= dataCounter; i++) {
            const data = await contract.methods.getData(i).call();
            if (data) {
                const listItem = document.createElement('li');
                listItem.textContent = `Index ${i}: ${data}`;
                dataList.appendChild(listItem);
            }
        }
    } catch (error) {
        console.error('Error getting data:', error);
    }
}

// Example usage:
getDataList();
