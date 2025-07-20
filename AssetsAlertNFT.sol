// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract AssetsAlertNFT is ERC1155, Ownable, ERC2981 {
    mapping(uint256 => uint256) public maxSupply;
    mapping(uint256 => uint256) public totalMinted;
    mapping(uint256 => uint256) public price;
    mapping(uint256 => bool) public publicMintEnabled;
    mapping(uint256 => bool) public onePerWallet;
    mapping(address => mapping(uint256 => bool)) public hasMinted;

    constructor(address initialOwner)
        ERC1155("ipfs://example-base-uri/{id}.json")
        Ownable(initialOwner)
    {
        // Set supplies
        maxSupply[1] = 6;       // Skater Mouse
        maxSupply[2] = 100;     // Beta Tester
        maxSupply[3] = 50000;   // Paid NFT
        maxSupply[4] = 10000;   // Premium NFT
        maxSupply[5] = 100;     // Mystery NFT 1
        maxSupply[6] = 50;      // Mystery NFT 2
        maxSupply[7] = 50;      // S1 NFT

        // Set prices (in wei)
        price[3] = 10 ether;  // Paid NFT = 10 MATIC
        price[4] = 20 ether;  // Premium NFT = 20 MATIC
        price[5] = 15 ether;  // Mystery NFT 1
        price[6] = 10 ether;  // Mystery NFT 2
        price[7] = 10 ether;  // S1 NFT

        // Set one-per-wallet rules
        onePerWallet[1] = true;
        onePerWallet[2] = true;
        onePerWallet[5] = true;
        onePerWallet[6] = true;
        onePerWallet[7] = true;

        // Enable public mint
        publicMintEnabled[3] = true;
        publicMintEnabled[4] = true;

        // Set royalties (5%)
        _setDefaultRoyalty(initialOwner, 500);
    }

    function mint(uint256 id, uint256 amount) external payable {
        require(publicMintEnabled[id], "Minting not enabled for this token");
        require(totalMinted[id] + amount <= maxSupply[id], "Exceeds max supply");

        if (price[id] > 0) {
            require(msg.value >= price[id] * amount, "Insufficient payment");
        }

        if (onePerWallet[id]) {
            require(!hasMinted[msg.sender][id], "Already minted");
            hasMinted[msg.sender][id] = true;
        }

        totalMinted[id] += amount;
        _mint(msg.sender, id, amount, "");
    }

    function airdrop(address to, uint256 id, uint256 amount) public onlyOwner {
        require(totalMinted[id] + amount <= maxSupply[id], "Exceeds max supply");
        totalMinted[id] += amount;
        _mint(to, id, amount, "");
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function setPublicMintEnabled(uint256 id, bool enabled) public onlyOwner {
        publicMintEnabled[id] = enabled;
    }

    function setPrice(uint256 id, uint256 newPrice) public onlyOwner {
        price[id] = newPrice;
    }

    function setRoyalty(address receiver, uint96 feeNumerator) public onlyOwner {
        _setDefaultRoyalty(receiver, feeNumerator);
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
