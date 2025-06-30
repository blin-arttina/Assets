// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract AssetsAlertNFT is ERC1155, Ownable, ERC2981 {
    mapping(uint256 => uint256) public totalSupply;
    mapping(uint256 => uint256) public maxSupply;

    constructor()
        ERC1155("https://raw.githubusercontent.com/youruser/assets/main/{id}.json")
    {
        _setDefaultRoyalty(0x00000000000000000000000000000000000000e, 1000); // 10% royalty

        maxSupply[1] = 6;
        maxSupply[2] = 100;
        maxSupply[3] = 100000;
        maxSupply[4] = 50000;
        maxSupply[5] = 100;
        maxSupply[6] = 100;
        maxSupply[7] = 100;
    }

    function mint(address to, uint256 id, uint256 amount) external onlyOwner {
        require(totalSupply[id] + amount <= maxSupply[id], "Exceeds max supply");
        totalSupply[id] += amount;
        _mint(to, id, amount, "");
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
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