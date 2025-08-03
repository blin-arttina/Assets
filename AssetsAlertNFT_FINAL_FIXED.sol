// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract MyMultiToken is ERC1155, Ownable, ERC2981 {
    mapping(uint256 => uint256) public totalMinted;
    mapping(uint256 => uint256) public maxSupply;

    address private constant TRUST_WALLET = 0x6502663d6d6ce0496abC0e6D8B5d8E79F7160E2E;

    constructor() 
        ERC1155("https://raw.githubusercontent.com/blin-arttina/AssetsAlert/main/{id}.json")
        Ownable(0xB7Acf7F61e360baB855A86742be5273baB69B153)
    {
        maxSupply[1] = 6;
        maxSupply[2] = 100;
        maxSupply[3] = 50000;
        maxSupply[4] = 100;
        maxSupply[5] = 100;
        maxSupply[6] = 50;
        maxSupply[7] = 50;

        _mint(owner(), 1, 1, "");
        totalMinted[1] = 1;

        _setDefaultRoyalty(TRUST_WALLET, 500);
    }

    function mint(address to, uint256 id, uint256 amount) external onlyOwner {
        require(totalMinted[id] + amount <= maxSupply[id], "Max supply exceeded");
        totalMinted[id] += amount;
        _mint(to, id, amount, "");
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts) external onlyOwner {
        require(ids.length == amounts.length, "Mismatched array lengths");
        for (uint256 i = 0; i < ids.length; i++) {
            require(totalMinted[ids[i]] + amounts[i] <= maxSupply[ids[i]], "Max supply exceeded");
            totalMinted[ids[i]] += amounts[i];
        }
        _mintBatch(to, ids, amounts, "");
    }

    function airdrop(uint256 id, address[] calldata recipients) external onlyOwner {
        require(totalMinted[id] + recipients.length <= maxSupply[id], "Airdrop exceeds max supply");
        for (uint256 i = 0; i < recipients.length; i++) {
            _mint(recipients[i], id, 1, "");
            totalMinted[id] += 1;
        }
    }

    function setRoyalty(address receiver, uint96 feeNumerator) external onlyOwner {
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
