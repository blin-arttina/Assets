// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract AssetsAlertNFT is ERC1155Supply, Ownable, ERC2981 {
    mapping(uint256 => uint256) public price;
    mapping(uint256 => uint256) public maxSupply;
    mapping(uint256 => bool) public publicMintEnabled;
    mapping(uint256 => bool) public onePerWallet;
    mapping(uint256 => mapping(address => bool)) public hasMinted;

    constructor() ERC1155("https://blin-arttina.github.io/Assets/{id}.json") {
        // Set supplies
        maxSupply[1] = 6;
        maxSupply[2] = 100;
        maxSupply[3] = 50000;
        maxSupply[4] = 10000;
        maxSupply[5] = 100;
        maxSupply[6] = 50;
        maxSupply[7] = 50;

        // Set prices (in wei)
        price[3] = 15 ether;
        price[4] = 50 ether;
        price[5] = 10 ether;
        price[6] = 10 ether;
        price[7] = 10 ether;

        // Set one-per-wallet flags
        onePerWallet[1] = true;
        onePerWallet[2] = true;
        onePerWallet[3] = true;
        onePerWallet[4] = true;
        onePerWallet[5] = true;
        onePerWallet[6] = true;
        onePerWallet[7] = true;

        // Enable public mint
        publicMintEnabled[3] = true;
        publicMintEnabled[4] = true;
        publicMintEnabled[5] = true;
        publicMintEnabled[6] = true;
        publicMintEnabled[7] = true;

        // Set royalties (5%) to Trust Wallet
        _setDefaultRoyalty(0x6502663d6d6ce0496abC0e6D8B5d8E79F7160E2E, 500);
    }

    function mint(uint256 id, uint256 quantity) external payable {
        require(publicMintEnabled[id], "Public minting not enabled");
        require(totalSupply(id) + quantity <= maxSupply[id], "Exceeds max supply");
        if (price[id] > 0) {
            require(msg.value >= price[id] * quantity, "Insufficient payment");
        }
        if (onePerWallet[id]) {
            require(!hasMinted[id][msg.sender], "Only one per wallet allowed");
            hasMinted[id][msg.sender] = true;
        }
        _mint(msg.sender, id, quantity, "");
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function setPublicMint(uint256 id, bool enabled) public onlyOwner {
        publicMintEnabled[id] = enabled;
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function setRoyalty(address receiver, uint96 feeNumerator) public onlyOwner {
        _setDefaultRoyalty(receiver, feeNumerator);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC1155, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
