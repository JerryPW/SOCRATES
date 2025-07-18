[
    {
        "function_name": "withdrawBalance",
        "code": "function withdrawBalance() external { address nftAddress = address(nonFungibleContract); require( msg.sender == nftAddress ); nftAddress.transfer(address(this).balance); }",
        "vulnerability": "Potential Denial of Service",
        "reason": "The withdrawBalance function transfers the contract's entire Ether balance to the nonFungibleContract's address, but it does not account for any gas fees or ensure that the balance is sufficient to complete the transfer, potentially causing the transaction to fail if the nonFungibleContract is not set correctly or if there are insufficient funds after other transactions.",
        "file_name": "0x15ada2a8e62134806a86db3030fefc0a2a13cc99.sol"
    },
    {
        "function_name": "auctionEthEnd",
        "code": "function auctionEthEnd(address _winner, uint _amount, uint256 _tokenId, bytes _sig) public onlySystem { bytes32 hashedTx = auctionEndHashing(_amount, _tokenId); require(recover(hashedTx, _sig) == _winner); Auction storage auction = tokenIdToAuction[_tokenId]; uint64 endblock = auction.auctionEndBlock; require(endblock < block.number); require(!auction.allowPayDekla); uint256 prize = _amount * prizeCut / 10000; uint256 auctioneerCut = _computeCut(_amount) - prize; uint256 sellerProceeds = _amount - auctioneerCut; winBidEth(_winner, auction.seller, sellerProceeds, auctioneerCut); prizeAddress.transfer(prize); _removeAuction(_tokenId); _transfer(_winner, _tokenId); emit AuctionSuccessful(_tokenId, _amount, _winner); }",
        "vulnerability": "Signature Replay Vulnerability",
        "reason": "The auctionEthEnd function uses signatures without nonce verification, which can allow replay attacks where the same signature is used multiple times to execute the function with the same parameters, leading to unauthorized transfers or repeated transactions.",
        "file_name": "0x15ada2a8e62134806a86db3030fefc0a2a13cc99.sol"
    },
    {
        "function_name": "setBiddingRate",
        "code": "function setBiddingRate(uint256 _prizeCut, uint256 _tokenDiscount) external onlyCLevel { biddingAuction.setCut(_prizeCut, _tokenDiscount); }",
        "vulnerability": "Improper Authorization",
        "reason": "The setBiddingRate function allows any CLevel address to set the prizeCut and tokenDiscount rates without checks or limits, potentially leading to manipulation or setting of unreasonable values that could disrupt auction functionality or result in unfair financial outcomes.",
        "file_name": "0x15ada2a8e62134806a86db3030fefc0a2a13cc99.sol"
    }
]