// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {AlphaCoin} from "../contracts/AlphaCoin.sol";
import {AlphaNFT} from "../contracts/AlphaNFT.sol";

contract DeployAlpha is Script {
    function run() external {
        // On recupere la cle privee du deploiement (on utilisera une cle de test locale)
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploiement de la monnaie (AlphaCoin)
        // On passe un hash de sceau (S13) pour prouver l'origine
        AlphaCoin coin = new AlphaCoin("S13-HASH-123456789");
        console.log("AlphaCoin deployed at:", address(coin));

        // 2. Deploiement du contrat d'art (AlphaNFT)
        AlphaNFT nft = new AlphaNFT();
        console.log("AlphaNFT deployed at:", address(nft));

        vm.stopBroadcast();
    }
}