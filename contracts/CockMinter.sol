//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CockMinter is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter _tokenIds;

    bool private revealed = false;
    string private revealUrl = "https://ipfs.io/ipfs/{cid}/notRevealed.json";

    constructor() ERC721("Cockfighters", "FIGHT"){}

    function mintCock(address _player, string memory _tokenURI) public pausable returns(uint256) {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(_player, newItemId);
        _setTokenURI(newItemId, _tokenURI);

        return newItemId;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        
        if (revealed == true) {
            return super.tokenURI(tokenId);
        } else {
            return revealUrl;
        }
    }

    function revealCollection() public onlyOwner {
        revealed = true;
    }
}
