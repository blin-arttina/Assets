// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

contract TwoAdmin is Context {
    address public admin1;
    address public admin2;

    event AdminsUpdated(address indexed admin1, address indexed admin2);

    modifier onlyAdmin() {
        require(_msgSender() == admin1 || _msgSender() == admin2, "Not admin");
        _;
    }

    constructor(address a1, address a2) {
        require(a1 != address(0) && a2 != address(0), "zero admin");
        admin1 = a1;
        admin2 = a2;
        emit AdminsUpdated(a1, a2);
    }

    function updateAdmins(address a1, address a2) external onlyAdmin {
        require(a1 != address(0) && a2 != address(0), "zero admin");
        admin1 = a1;
        admin2 = a2;
        emit AdminsUpdated(a1, a2);
    }
}

interface IERC165 { function supportsInterface(bytes4 interfaceId) external view returns (bool); }

interface IERC2981 is IERC165 {
    function royaltyInfo(uint256 tokenId, uint256 salePrice) external view returns (address, uint256);
}

interface IERC1155 is IERC165 {
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
    event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
    event URI(string value, uint256 indexed id);

    function balanceOf(address account, uint256 id) external view returns (uint256);
    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
    function setApprovalForAll(address operator, bool approved) external;
    function isApprovedForAll(address account, address operator) external view returns (bool);
    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
    function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
}

contract ERC1155Base is IERC1155 {
    mapping(uint256 => mapping(address => uint256)) internal _balances;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    string internal _uri;

    constructor(string memory baseURI_) { _setURI(baseURI_); }

    function supportsInterface(bytes4 iid) public pure virtual override returns (bool) {
        return iid == type(IERC1155).interfaceId || iid == type(IERC165).interfaceId;
    }

    function uri(uint256) public view virtual returns (string memory)