
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract AssetsAlertNFT is ERC1155Supply, Ownable, ERC2981 {
    string public name = "Assets Alert NFT Collection";
    string public symbol = "AANFT";

    address public paymentReceiver = 0x6502663d6d6ce0496abC0e6D8B5d8E79F7160E2E;
    uint256 public mintPrice = 0.01 ether;

    mapping(uint256 => uint256) public maxSupply;
    mapping(uint256 => bool) public isPublic;
    mapping(uint256 => bool) public onePerWallet;
    mapping(address => mapping(uint256 => bool)) public hasMinted;
    mapping(uint256 => uint256) public totalMinted;

    constructor()
        ERC1155("https://blin-arttina.github.io/Assets/metadata/{id}.json")
        Ownable(0x6502663d6d6ce0496abC0e6D8B5d8E79F7160E2E)
    {
        _transferOwnership(0x6502663d6d6ce0496abC0e6D8B5d8E79F7160E2E);
        _setDefaultRoyalty(0x6502663d6d6ce0496abC0e6D8B5d8E79F7160E2E, 500);

        setMaxSupply(1, 100); isPublic[1] = false; onePerWallet[1] = true;
        setMaxSupply(2, 100); isPublic[2] = false; onePerWallet[2] = true;
        setMaxSupply(3, 50);  isPublic[3] = true;  onePerWallet[3] = true;
        setMaxSupply(4, 50);  isPublic[4] = true;  onePerWallet[4] = true;
        setMaxSupply(5, 10);  isPublic[5] = false; onePerWallet[5] = true;
        setMaxSupply(6, 1);   isPublic[6] = false; onePerWallet[6] = true;
    }

    function setMaxSupply(uint256 id, uint256 supply) public onlyOwner {
        maxSupply[id] = supply;
    }

    function mint(uint256 id, uint256 amount) public payable {
        require(isPublic[id], "Minting not open for this NFT");
        require(amount > 0, "Must mint at least 1");
        require(totalMinted[id] + amount <= maxSupply[id], "Exceeds max supply");
        require(msg.value >= mintPrice * amount, "Insufficient ETH");

        if (onePerWallet[id]) {
            require(!hasMinted[msg.sender][id], "One per wallet limit");
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

    function withdraw() public onlyOwner {
        payable(paymentReceiver).transfer(address(this).balance);
    }

    function supportsInterface(bytes4 interfaceId)
        public view virtual override(ERC1155, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
