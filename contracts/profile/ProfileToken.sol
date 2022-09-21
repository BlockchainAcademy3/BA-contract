// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "./SoulBoundToken.sol";

/**
 * @title Profile NFT
 *
 * @notice This is the user profile NFT on blockchain academy platform
 *
 *         It is a soul bound token, which means it
 *         - can not be transferred
 *         - can not mint more than one for each user
 *         - can be burned (will have side effects)
 *
 *         Profile NFT can link other NFTs to it, for example, after a user finished a course / task,
 *         or attended some events.
 *
 *
 */

contract ProfileToken is Ownable, SoulBoundToken {
    using Strings for uint256;

    string public baseURI;

    constructor(string memory _name, string memory _symbol)
        SoulBoundToken(_name, _symbol)
    {}

    function setBaseURI(string memory _baseURI) public onlyOwner {
        baseURI = _baseURI;
    }

    function tokenURI(uint256 _tokenId) public view returns (string memory) {
        return _tokenURI(_tokenId);
    }

    /**
     * @notice Generate the token URI
     *
     *         Token URI will be stored on backend
     *         URI = "https://api.blockchainacademy.org/api/v1/nft/profile/{tokenId}"
     */
    function _tokenURI(uint256 _tokenId) internal view returns (string memory) {
        return string.concat(baseURI, _tokenId.toString());
    }

    /**
     * @notice Mint a profile NFT for a user
     *         It is minted by the owner so user no need for gas fee
     *
     */
    function mint(address _to) public onlyOwner {
        _mintSBT(_to);
    }

    function burn() public {
        _burn(soulBoundTokenId[msg.sender]);
    }
}