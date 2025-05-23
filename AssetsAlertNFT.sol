// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AssetsAlertNFT is ERC1155, Ownable {
    string public name = "Assets Alert NFT Collection";
    string public symbol = "ALERTNFT";

    mapping(uint256 => string) private uris;

    constructor() ERC1155("") Ownable(msg.sender) {
        // Mint 5 NFTs to the contract owner (adjust as needed)
        mint(msg.sender, 1, 100, "");
        mint(msg.sender, 2, 100, "");
        mint(msg.sender, 3, 100, "");
        mint(msg.sender, 4, 100, "");
        mint(msg.sender, 5, 100, "");
    }

    function setURI(uint256 tokenId, string memory newuri) public onlyOwner {
        uris[tokenId] = newuri;
    }

    function uri(uint256 tokenId) public view override returns (string memory) {
        return uris[tokenId];
    }

    function mint(address to, uint256 id, uint256 amount, bytes memory data) public onlyOwner {
        _mint(to, id, amount, data);
    }

    function airdrop(address[] calldata recipients, uint256 id, uint256 amount, bytes calldata data) public onlyOwner {
        for (uint256 i = 0; i < recipients.length; i++) {
            _mint(recipients[i], id, amount, data);
        }
    }
}
