// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract AssetsAlertNFT is ERC1155Supply, Ownable, ERC2981 {
    constructor(address initialOwner, string memory uri) 
        ERC1155(uri) 
        Ownable(initialOwner) 
    {
        _setDefaultRoyalty(initialOwner, 500); // 5% royalty
    }

    function supportsInterface(bytes4 interfaceId)
        public view virtual override(ERC1155, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
