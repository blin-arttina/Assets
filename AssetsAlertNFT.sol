// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AssetsAlertNFT is ERC1155, Ownable {
    uint256 public constant SKATER_MOUSE = 0;
    uint256 public constant BETA_TESTER = 1;
    uint256 public constant PAID = 2;
    uint256 public constant PREMIUM = 3;

    constructor() ERC1155("https://example.com/api/item/{id}.json") {}

    function mint(address account, uint256 id, uint256 amount) public onlyOwner {
        _mint(account, id, amount, "");
    }
}
