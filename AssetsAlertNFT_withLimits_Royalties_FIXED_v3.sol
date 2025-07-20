
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract AssetsAlertNFT is ERC1155Supply, Ownable, ERC2981 {
    mapping(uint256 => uint256) public maxSupply;
    mapping(uint256 => uint256) public totalMinted;
    mapping(uint256 => uint256) public price;
    mapping(uint256 => bool) public onePerWallet;
    mapping(uint256 => mapping(address => bool)) public hasMinted;

    mapping(uint256 => bool) public publicMintEnabled;

    constructor(address initialOwner)
        ERC1155("https://blin-arttina.github.io/Assets/{id}.json")
        Ownable(initialOwner)
    {
        _setDefaultRoyalty(initialOwner, 500); // 5% royalties

        // Set max supply
        maxSupply[1] = 6;       // A1 Skater Mouse
        maxSupply[2] = 100;     // A2 Beta Tester Mouse
        maxSupply[3] = 50000;   // A3 Paid NFT
        maxSupply[4] = 10000;   // A4 Premium NFT
        maxSupply[5] = 100;     // M1 Mystery Mouse (3D Glasses)
        maxSupply[6] = 50;      // M2 Mystery Mouse 2
        maxSupply[7] = 50;      // S1 Wrapper Mouse

        // Prices in wei (MATIC)
        price[3] = 15 ether;
        price[4] = 50 ether;

        // One-per-wallet limits
        onePerWallet[3] = true;
        onePerWallet[4] = true;

        // Enable public mint for testing purposes
        publicMintEnabled[3] = true;
        publicMintEnabled[4] = true;
    }

    function mint(uint256 id, uint256 amount) public payable {
        require(publicMintEnabled[id], "Minting not enabled for this token");
        require(totalMinted[id] + amount <= maxSupply[id], "Exceeds max supply");

        if (price[id] > 0) {
            require(msg.value >= price[id] * amount, "Insufficient payment");
        }

        if (onePerWallet[id]) {
            require(!hasMinted[id][msg.sender], "Already minted");
            hasMinted[id][msg.sender] = true;
        }

        totalMinted[id] += amount;
        _mint(msg.sender, id, amount, "");
    }

    function airdrop(address to, uint256 id, uint256 amount) public onlyOwner {
        require(totalMinted[id] + amount <= maxSupply[id], "Exceeds max supply");
        totalMinted[id] += amount;
        _mint(to, id, amount, "");
    }

    function setPublicMintEnabled(uint256 id, bool enabled) public onlyOwner {
        publicMintEnabled[id] = enabled;
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function withdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
