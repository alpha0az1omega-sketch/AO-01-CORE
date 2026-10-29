// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {AlphaNFT} from "../contracts/AlphaNFT.sol";

contract AlphaNFTTest is Test {
    AlphaNFT public nft;
    address public creator;
    address public user = address(0x123);
    address public collector = address(0x456); // Un portefeuille normal pour recevoir l'art

    function setUp() public {
        creator = address(this);
        nft = new AlphaNFT();
    }

    function testNFTMetadata() public view {
        assertEq(nft.name(), "Alpha Sovereign Art");
        assertEq(nft.symbol(), "iNFT");
        console.log("NFT Metadata verified.");
    }

    function testMintNFTOnlyOwner() public {
        // 1. Le proprietaire cree un NFT et l'envoie a un collectionneur
        uint256 tokenId = nft.mintNFT(collector, "S13-HASH-ART-001");
        
        // On verifie que le collectionneur possede bien l'art
        assertEq(nft.ownerOf(tokenId), collector);
        assertEq(nft.tokenSealHash(tokenId), "S13-HASH-ART-001");
        
        // 2. Un utilisateur normal ne peut PAS creer de NFT
        vm.startPrank(user);
        
        bool reverted = false;
        try nft.mintNFT(user, "FAKE-HASH") {
        } catch {
            reverted = true;
        }
        
        vm.stopPrank();
        
        assertTrue(reverted, "NFT Mint should have been reverted for non-owner");
        console.log("NFT Access control verified: Unauthorized mint blocked.");
    }
}