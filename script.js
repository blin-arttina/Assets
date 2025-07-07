
let walletAddressField = document.getElementById("walletAddress");

document.getElementById("connectButton").onclick = async () => {
  if (window.ethereum) {
    const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
    walletAddressField.innerText = accounts[0];
  } else {
    alert("No Ethereum provider found. Use a mobile wallet like Trust Wallet in browser mode.");
  }
};

document.getElementById("mintButton").onclick = () => alert("Mint logic here");
document.getElementById("airdropButton").onclick = () => alert("Airdrop logic here");
document.getElementById("setReferral").onclick = () => alert("Referral logic here");
