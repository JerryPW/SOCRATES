[
    {
        "function_name": "removeERC20Token",
        "code": "function removeERC20Token(erc20Addresses storage self, address _ercTokenAddress) internal {\n    if (self.array.length > 1){\n        for (uint256 i = 0; i < self.array.length; i++) {\n            if ( self.array[i] == _ercTokenAddress ) {\n                delete self.array[i];\n            }\n        }\n    } else{\n        self.array.length = 0;\n    }\n}",
        "vulnerability": "Inefficient Token Removal",
        "reason": "The function uses 'delete' on an array element, which will set the element to its default value but does not shrink the array, leading to potential storage waste. Moreover, it does not handle the case where the element to remove is the last element efficiently, resulting in a gap in the array.",
        "file_name": "0x03fb31bb6def4dd3a7ea3b0fa6bdecc940e75795.sol"
    },
    {
        "function_name": "bid",
        "code": "function bid( uint256 tokenID, address _mintableToken, uint256 amount ) public payable onSaleOnly(tokenID, _mintableToken) activeAuction(tokenID, _mintableToken) {\n    IMintableToken Token = IMintableToken(_mintableToken);\n    auction memory _auction = auctions[_mintableToken][tokenID];\n    if (_auction.erc20Token == address(0)) {\n        require( msg.value > _auction.currentBid, \"Insufficient bidding amount.\" );\n        if (_auction.buyer == true) {\n            _auction.highestBidder.transfer(_auction.currentBid);\n        }\n    } else {\n        IERC20 erc20Token = IERC20(_auction.erc20Token);\n        require( erc20Token.allowance(msg.sender, address(this)) >= amount, \"Allowance is less than amount sent for bidding.\" );\n        require( amount > _auction.currentBid, \"Insufficient bidding amount.\" );\n        erc20Token.transferFrom(msg.sender, address(this), amount);\n        if (_auction.buyer == true) {\n            erc20Token.transfer( _auction.highestBidder, _auction.currentBid );\n        }\n    }\n    _auction.currentBid = _auction.erc20Token == address(0) ? msg.value : amount;\n    Token.safeTransferFrom(Token.ownerOf(tokenID), address(this), tokenID);\n    _auction.buyer = true;\n    _auction.highestBidder = msg.sender;\n    auctions[_mintableToken][tokenID] = _auction;\n    emit Bid( _mintableToken, tokenID, _auction.lastOwner, _auction.highestBidder, _auction.currentBid, block.timestamp, _auction.erc20Token );\n}",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function transfers the current bid back to the highest bidder before updating the auction state. This sequence allows for a reentrancy attack, where a malicious contract could repeatedly call the bid function to drain funds.",
        "file_name": "0x03fb31bb6def4dd3a7ea3b0fa6bdecc940e75795.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() public onlyOwner {\n    msg.sender.transfer(brokerageBalance[address(0)]);\n    brokerageBalance[address(0)] = 0;\n}",
        "vulnerability": "Lack of Checks-Effects-Interactions Pattern",
        "reason": "The function transfers Ether to the owner before setting the balance to zero. This order of operations can be exploited if the owner is a contract that performs a reentrant call, potentially leading to a double withdrawal attack.",
        "file_name": "0x03fb31bb6def4dd3a7ea3b0fa6bdecc940e75795.sol"
    }
]