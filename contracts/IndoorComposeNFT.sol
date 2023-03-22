// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract IndoorComposeNFT is ERC1155, Ownable, Pausable, ERC1155Burnable, ERC1155Supply {
    uint public mintPrice = 0.06 ether;
    uint public ID;

    constructor() ERC1155("ipfs://bafybeia62gqwemhwoebnl235qy6o56pyoohn64nvdflp5557jgc26sxp3q/") {
        ID = 0;
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
    function uri(uint256 _Id) override public view returns (string memory) {
        require(exists(_Id), "uri does not exist");
        return string(
        abi.encodePacked(
            super.uri(_Id),
        //     Strings.toString(_Id), fix URI Metadata
            "0.json")
        );
    }

    // Will chang to dynami ID next version
    function mint(uint256 amount)
        public
        payable
    {
        require(msg.value == amount * mintPrice, "not enought fund");
        _mint(msg.sender, ID, amount, "");
        ID++;
    }

    function withdraw(address _addr) external onlyOwner {
        uint balance = address(this).balance;
        payable(_addr).transfer(balance);
    }

     function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}