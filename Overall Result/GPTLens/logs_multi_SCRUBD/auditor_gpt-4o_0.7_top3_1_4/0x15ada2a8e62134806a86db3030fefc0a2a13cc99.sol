[
    {
        "function_name": "setCEO",
        "code": "function setCEO( address _newCEO, bytes _sig ) external onlyCLevel { require( _newCEO != address(0) && _newCEO != cfoAddress && _newCEO != cooAddress ); bytes32 hashedTx = getCEOHashing(_newCEO, nonces[msg.sender]); require(signedByCLevel(hashedTx, _sig)); nonces[msg.sender]++; ceoAddress = _newCEO; CLevelTxCount_++; }",
        "vulnerability": "Signature replay attack",
        "reason": "The function increments the nonce only after checking the signature, allowing an attacker to reuse the same signature if the nonce is reset or if the signer hasn't changed. This could allow unauthorized changes to the CEO address.",
        "file_name": "0x15ada2a8e62134806a86db3030fefc0a2a13cc99.sol"
    },
    {
        "function_name": "withdrawEthBalance",
        "code": "function withdrawEthBalance(address _withdrawWallet, bytes _sig) external onlyCLevel { bytes32 hashedTx = withdrawBalanceHashing(_withdrawWallet, nonces[msg.sender]); require(signedByCLevel(hashedTx, _sig)); uint256 balance = address(this).balance; uint256 subtractFees = (pregnantPonies + 1) * autoBirthFee; require(balance > 0); require(balance > subtractFees); nonces[msg.sender]++; _withdrawWallet.transfer(balance - subtractFees); emit WithdrawEthBalanceSuccessful(_withdrawWallet, balance - subtractFees); }",
        "vulnerability": "Potential integer overflow",
        "reason": "The subtraction of `subtractFees` from `balance` is done without previous validation of the bounds. If `balance` is less than `subtractFees`, this could lead to an overflow and transfer a large amount of Ether unexpectedly.",
        "file_name": "0x15ada2a8e62134806a86db3030fefc0a2a13cc99.sol"
    },
    {
        "function_name": "auctionDeklaEnd",
        "code": "function auctionDeklaEnd(address _winner, uint _amount, uint256 _tokenId, bytes _sig) public onlySystem { bytes32 hashedTx = auctionEndHashing(_amount, _tokenId); require(recover(hashedTx, _sig) == _winner); Auction storage auction = tokenIdToAuction[_tokenId]; uint64 endblock = auction.auctionEndBlock; require(endblock < block.number); require(auction.allowPayDekla); uint256 prize = _amount * prizeCut / 10000; uint256 discountAmount = _amount * tokenDiscount / 10000; uint256 auctioneerCut = _computeCut(_amount) - discountAmount - prizeCut; uint256 sellerProceeds = _amount - auctioneerCut; winBidDekla(_winner, auction.seller, sellerProceeds, auctioneerCut); tokens.transfer(prizeAddress, prize); tokens.transfer(_winner, discountAmount); _removeAuction(_tokenId); _transfer(_winner, _tokenId); emit AuctionSuccessful(_tokenId, _amount, _winner); }",
        "vulnerability": "Incorrect calculation of auctioneerCut",
        "reason": "The calculation of `auctioneerCut` subtracts both `discountAmount` and `prizeCut` directly, which may not accurately reflect the intended cut, potentially allowing manipulation of proceeds by the auctioneer.",
        "file_name": "0x15ada2a8e62134806a86db3030fefc0a2a13cc99.sol"
    }
]