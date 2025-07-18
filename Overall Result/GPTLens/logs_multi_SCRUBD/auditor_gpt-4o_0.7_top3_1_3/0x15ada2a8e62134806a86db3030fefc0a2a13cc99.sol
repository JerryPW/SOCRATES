[
    {
        "function_name": "setCEO",
        "code": "function setCEO( address _newCEO, bytes _sig ) external onlyCLevel { require( _newCEO != address(0) && _newCEO != cfoAddress && _newCEO != cooAddress ); bytes32 hashedTx = getCEOHashing(_newCEO, nonces[msg.sender]); require(signedByCLevel(hashedTx, _sig)); nonces[msg.sender]++; ceoAddress = _newCEO; CLevelTxCount_++; }",
        "vulnerability": "Signature replay attack",
        "reason": "The function uses signatures for authorization without properly handling nonce incrementation prior to signature verification. This allows an old, valid signature to be reused (replayed) if the nonce hasn't been incremented, enabling unauthorized setCEO operations if the signature was previously valid.",
        "file_name": "0x15ada2a8e62134806a86db3030fefc0a2a13cc99.sol"
    },
    {
        "function_name": "withdrawEthBalance",
        "code": "function withdrawEthBalance(address _withdrawWallet, bytes _sig) external onlyCLevel { bytes32 hashedTx = withdrawBalanceHashing(_withdrawWallet, nonces[msg.sender]); require(signedByCLevel(hashedTx, _sig)); uint256 balance = address(this).balance; uint256 subtractFees = (pregnantPonies + 1) * autoBirthFee; require(balance > 0); require(balance > subtractFees); nonces[msg.sender]++; _withdrawWallet.transfer(balance - subtractFees); emit WithdrawEthBalanceSuccessful(_withdrawWallet, balance - subtractFees); }",
        "vulnerability": "Potential reentrancy vulnerability",
        "reason": "The function transfers Ether to an external address before incrementing the nonce, which could potentially allow a reentrancy attack if the receiving contract is malicious and can call back into this function or another function that allows Ether withdrawal using the same signature before the nonce is incremented.",
        "file_name": "0x15ada2a8e62134806a86db3030fefc0a2a13cc99.sol"
    },
    {
        "function_name": "auctionEthEnd",
        "code": "function auctionEthEnd(address _winner, uint _amount, uint256 _tokenId, bytes _sig) public onlySystem { bytes32 hashedTx = auctionEndHashing(_amount, _tokenId); require(recover(hashedTx, _sig) == _winner); Auction storage auction = tokenIdToAuction[_tokenId]; uint64 endblock = auction.auctionEndBlock; require(endblock < block.number); require(!auction.allowPayDekla); uint256 prize = _amount * prizeCut / 10000; uint256 auctioneerCut = _computeCut(_amount) - prize; uint256 sellerProceeds = _amount - auctioneerCut; winBidEth(_winner, auction.seller, sellerProceeds, auctioneerCut); prizeAddress.transfer(prize); _removeAuction(_tokenId); _transfer(_winner, _tokenId); emit AuctionSuccessful(_tokenId, _amount, _winner); }",
        "vulnerability": "Unverified auction contract address",
        "reason": "The function relies on the msg.sender being a trusted 'systemAddress', but it doesn't verify that the function is being called from a legitimate auction contract address. This could potentially allow unauthorized entities to end auctions and manipulate the auction process if the 'systemAddress' is compromised or incorrectly set.",
        "file_name": "0x15ada2a8e62134806a86db3030fefc0a2a13cc99.sol"
    }
]