// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract EventTicketNFT is ERC721, Ownable {

    uint256 public ticketPriceETH = 0.01 ether;
    uint256 public ticketPriceToken = 10 ether;

    uint256 public maxPerWallet = 2;

    uint256 public tokenIdCounter;

    IERC20 public paymentToken;

    mapping(address => uint256) public walletMints;

    constructor(address _token)
        ERC721("EventTicket", "ETKT")
        Ownable(msg.sender)
    {
        paymentToken = IERC20(_token);
    }

    // ✅ Mint with ETH
    function mintWithETH() external payable {
        require(msg.value >= ticketPriceETH, "Not enough ETH");
        require(walletMints[msg.sender] < maxPerWallet, "Wallet limit reached");

        walletMints[msg.sender]++;

        _safeMint(msg.sender, tokenIdCounter);

        tokenIdCounter++;
    }

    // ✅ Mint with ERC20
    function mintWithToken() external {

        require(walletMints[msg.sender] < maxPerWallet, "Wallet limit reached");

        paymentToken.transferFrom(
            msg.sender,
            address(this),
            ticketPriceToken
        );

        walletMints[msg.sender]++;

        _safeMint(msg.sender, tokenIdCounter);

        tokenIdCounter++;
    }

    // ✅ Withdraw ETH
    function withdrawETH() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}