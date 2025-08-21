// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MyNFT.sol";

contract MyNFTTest is Test {
    MyNFT nft;
    address user = address(0xBEEF);

    function setUp() public {
        nft = new MyNFT();
        // owner is address(this) because we deployed in this test contract context
    }

    function testNameAndSymbol() public view {
        assertEq(nft.name(), "DeepakNFT");
        assertEq(nft.symbol(), "DNFT");
    }

    function testMintWithURI() public {
        string memory uri = "ipfs://dummyCID/0.json";
        nft.mintWithURI(user, uri);

        assertEq(nft.ownerOf(0), user);
        assertEq(nft.nextTokenId(), 1);
        assertEq(nft.tokenURI(0), uri);
    }
}
