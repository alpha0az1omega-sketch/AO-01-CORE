// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AlphaNFT is ERC721, Ownable {
    uint256 private _nextTokenId;
    
    // Mapping pour lier un NFT à son Hash Souverain
    mapping(uint256 => string) public tokenSealHash;

    constructor() ERC721("Alpha Sovereign Art", "iNFT") Ownable(msg.sender) {}

    function mintNFT(address to, string memory sealHash) public onlyOwner returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        tokenSealHash[tokenId] = sealHash;
        return tokenId;
    }
}
