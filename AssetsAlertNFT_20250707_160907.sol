// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract AssetsAlertNFT is ERC1155, Ownable, ERC2981 {
    string public name = "Assets Alert NFT Collection";
    string public symbol = "AANFT";
    string public baseURI = "https://blin-arttina.github.io/Assets/metadata/";

    constructor() ERC1155(baseURI) Ownable(msg.sender) {
        _setDefaultRoyalty(msg.sender, 500); // 5% royalty
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(address account, uint256 id, uint256 amount) public onlyOwner {
        _mint(account, id, amount, "");
    }

    function setRoyalty(address receiver, uint96 feeNumerator) public onlyOwner {
        _setDefaultRoyalty(receiver, feeNumerator);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
