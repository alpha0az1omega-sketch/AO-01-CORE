// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title AlphaCoin (i.coin)
 * @dev La monnaie souveraine du projet AO-01-CORE.
 * Créée par Zacharie SYLLA (alpha0az1omega).
 */
contract AlphaCoin is ERC20, Ownable {
    
    // Le Hash du Sceau de création (pour la traçabilité)
    string public genesisSealHash;

    constructor(string memory _genesisHash) ERC20("AlphaCoin", "iCOIN") Ownable(msg.sender) {
        genesisSealHash = _genesisHash;
        // Création initiale de 1 000 000 de jetons pour le Créateur
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    // Fonction pour le Créateur de créer de nouveaux jetons (si besoin plus tard)
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
