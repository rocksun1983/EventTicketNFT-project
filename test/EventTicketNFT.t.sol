// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import "../src/EventTicketNFT.sol";
import "../src/MockERC20.sol";

contract EventTicketNFTTest is Test {

    EventTicketNFT nft;
    MockERC20 token;

    address user = address(1);

    function setUp() public {

        token = new MockERC20();

        nft = new EventTicketNFT(address(token));

        token.transfer(user, 100 ether);

        vm.deal(user, 10 ether);
    }

    // ✅ Test ETH mint
    function testMintWithETH() public {

        vm.prank(user);

        nft.mintWithETH{value: 0.01 ether}();

        assertEq(nft.balanceOf(user), 1);
    }

    // ✅ Test ERC20 mint
    function testMintWithToken() public {

        vm.startPrank(user);

        token.approve(address(nft), 10 ether);

        nft.mintWithToken();

        vm.stopPrank();

        assertEq(nft.balanceOf(user), 1);
    }

    // ✅ Wallet limit test
    function testWalletLimit() public {

        vm.startPrank(user);

        nft.mintWithETH{value: 0.01 ether}();
        nft.mintWithETH{value: 0.01 ether}();

        vm.expectRevert();

        nft.mintWithETH{value: 0.01 ether}();

        vm.stopPrank();
    }

    // ✅ Check owner
    function testOwner() public {
        assertEq(nft.owner(), address(this));
    }

    // ✅ Token counter increases
    function testTokenCounter() public {

        vm.prank(user);

        nft.mintWithETH{value: 0.01 ether}();

        assertEq(nft.tokenIdCounter(), 1);
    }
}