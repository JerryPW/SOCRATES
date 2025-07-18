[
    {
        "function_name": "removeERC20Token",
        "code": "function removeERC20Token( erc20Addresses storage self, address _ercTokenAddress ) internal { if (self.array.length > 1){ for (uint256 i = 0; i < self.array.length; i++) { if ( self.array[i] == _ercTokenAddress ) { delete self.array[i]; } } } else{ self.array.length = 0; } }",
        "vulnerability": "ERC20 Address Deletion Error",
        "reason": "The function attempts to delete an ERC20 token address from the array by setting it to zero, but it does not remove the element from the array. This leaves a gap in the array which could lead to unexpected behavior in other parts of the contract that rely on the array being contiguous. This makes it difficult to track the actual length and valid elements of the array, possibly causing errors.",
        "file_name": "0x03fb31bb6def4dd3a7ea3b0fa6bdecc940e75795.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() public onlyOwner { msg.sender.transfer(brokerageBalance[address(0)]); brokerageBalance[address(0)] = 0; }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function transfers Ether to the owner before setting the balance to zero, which opens up the possibility for a reentrancy attack. An attacker could potentially use a fallback function to re-enter the withdraw function before the balance is set to zero, allowing them to withdraw the balance multiple times.",
        "file_name": "0x03fb31bb6def4dd3a7ea3b0fa6bdecc940e75795.sol"
    },
    {
        "function_name": "collect",
        "code": "function collect(uint256 tokenID, address _mintableToken) public { IMintableToken Token = IMintableToken(_mintableToken); auction memory _auction = auctions[_mintableToken][tokenID]; TokenDetArrayLib.TokenDet memory _tokenDet = TokenDetArrayLib.TokenDet(_mintableToken,tokenID); require( block.timestamp > _auction.closingTime, \"Auction Not Over!\" ); address payable lastOwner2 = _auction.lastOwner; uint256 royalities = Token.royalities(tokenID); address payable creator = Token.creators(tokenID); uint256 royality = (royalities * _auction.currentBid) / 10000; uint256 brokerageAmount = (brokerage * _auction.currentBid) / 10000; uint256 lastOwner_funds = _auction.currentBid - royality - brokerageAmount; if (_auction.buyer == true) { if (_auction.erc20Token == address(0)) { creator.transfer(royality); lastOwner2.transfer(lastOwner_funds); } else { IERC20 erc20Token = IERC20(_auction.erc20Token); erc20Token.transfer(creator, royality); erc20Token.transfer(lastOwner2, lastOwner_funds); } brokerageBalance[_auction.erc20Token] += brokerageAmount; tokenOpenForSale[_mintableToken][tokenID] = false; Token.safeTransferFrom( Token.ownerOf(tokenID), _auction.highestBidder, tokenID ); emit Buy( _tokenDet.NFTAddress, _tokenDet.tokenID, lastOwner2, _auction.highestBidder, _auction.currentBid, block.timestamp, _auction.erc20Token ); } emit Collect( _tokenDet.NFTAddress, _tokenDet.tokenID, lastOwner2, _auction.highestBidder, msg.sender, block.timestamp, _auction.erc20Token ); tokensForSale.removeTokenDet(_tokenDet); tokensForSalePerUser[lastOwner2].removeTokenDet(_tokenDet); auctionTokens.removeTokenDet(_tokenDet); delete auctions[_mintableToken][tokenID]; }",
        "vulnerability": "Reentrancy in Token Transfer",
        "reason": "The function transfers funds to the creator and last owner before updating the state variables. An attacker could exploit this by re-entering the function via a fallback function, potentially manipulating the auction state and extracting more funds than intended.",
        "file_name": "0x03fb31bb6def4dd3a7ea3b0fa6bdecc940e75795.sol"
    }
]