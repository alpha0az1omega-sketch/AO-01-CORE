// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {AlphaCoin} from "../contracts/AlphaCoin.sol";

contract AlphaCoinTest is Test {
    AlphaCoin public coin;
    address public creator;
    address public user = address(0x123);

    function setUp() public {
        creator = address(this);
        coin = new AlphaCoin("S13-HASH-123456");
    }

    function testInitialSupply() public view {
        uint256 expectedSupply = 1000000 * 10 ** coin.decimals();
        assertEq(coin.balanceOf(creator), expectedSupply);
        console.log("Initial supply verified: 1,000,000 iCOIN");
    }

    function testMintOnlyOwner() public {
        // 1. Le proprietaire peut frapper des jetons
        coin.mint(user, 500 * 10 ** coin.decimals());
        assertEq(coin.balanceOf(user), 500 * 10 ** coin.decimals());
        
        // 2. Un utilisateur normal ne peut PAS frapper de jetons
        vm.startPrank(user); // On verrouille l'identite avant l'appel
        
        bool reverted = false;
        try coin.mint(user, 100 * 10 ** coin.decimals()) {
            // Si on arrive ici, c'est que l'appel a reussi (donc faille)
        } catch {
            reverted = true; // L'appel a echoue (comportement attendu)
        }
        
        vm.stopPrank(); // On libere l'identite
        
        assertTrue(reverted, "Mint should have been reverted for non-owner");
        console.log("Mint access control verified: Unauthorized mint blocked.");
    }
}