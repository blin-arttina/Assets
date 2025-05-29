
let web3;
let contract;
const contractAddress = "0xCdb25eb86266cAA0C175144eF4FB241A2F79390E"; // Replace if needed
const contractABI = [
  {
    "inputs":[
      {"internalType":"address","name":"to","type":"address"},
      {"internalType":"uint256","name":"id","type":"uint256"},
      {"internalType":"uint256","name":"amount","type":"uint256"},
      {"internalType":"bytes","name":"data","type":"bytes"}
    ],
    "name":"mint",
    "outputs":[],
    "stateMutability":"nonpayable",
    "type":"function"
  }
];

window.addEventListener("load", async () => {
  if (window.ethereum) {
    web3 = new Web3(window.ethereum);
    await window.ethereum.request({ method: 'eth_requestAccounts' });
    contract = new web3.eth.Contract(contractABI, contractAddress);
  } else {
    alert("Please install MetaMask or Trust Wallet.");
  }
});

async function mintNFT() {
  const accounts = await web3.eth.getAccounts();
  const id = document.getElementById("nftId").value;
  const qty = document.getElementById("nftQty").value;
  try {
    await contract.methods.mint(accounts[0], id, qty, "0x").send({ from: accounts[0] });
    alert("Mint successful!");
  } catch (err) {
    alert("Mint failed: " + err.message);
  }
}

async function airdropNFT() {
  const accounts = await web3.eth.getAccounts();
  const recipient = document.getElementById("airdropTo").value;
  const id = document.getElementById("airdropId").value;
  const qty = document.getElementById("airdropQty").value;
  try {
    await contract.methods.mint(recipient, id, qty, "0x").send({ from: accounts[0] });
    alert("Airdrop successful!");
  } catch (err) {
    alert("Airdrop failed: " + err.message);
  }
}
