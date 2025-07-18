[
    {
        "function_name": "transferAnyToken",
        "code": "function transferAnyToken( TokenType _tokenType, address _tokenContract, address _from, address _to, uint256 _tokenId, uint256 _amount ) internal { if (_tokenType == TokenType.ERC721) { IERC721(_tokenContract).transferFrom(_from, _to, _tokenId); return; } if (_tokenType == TokenType.ERC1155) { IERC1155(_tokenContract).safeTransferFrom( _from, _to, _tokenId, 1, \"\" ); return; } if (_tokenType == TokenType.ERC20) { if (_from==address(this)){ IERC20(_tokenContract).approve(address(this), _amount); } IERC20(_tokenContract).transferFrom(_from, _to, _amount); return; } }",
        "vulnerability": "ERC1155 incorrect amount handling",
        "reason": "The function assumes that only one ERC1155 token is being transferred by passing a static value of 1 to the safeTransferFrom function, regardless of the _amount parameter. This could lead to incorrect token transfers, as the intended amount to transfer is not respected.",
        "file_name": "0x11ce3c5ecfa4cc788eaa94157a63a1ca4863a90c.sol"
    },
    {
        "function_name": "supportsInterface",
        "code": "function supportsInterface(bytes4 interfaceId) override external pure returns (bool){ return interfaceId == type(IERC1155Receiver).interfaceId || true; }",
        "vulnerability": "Incorrect interface support declaration",
        "reason": "The function unconditionally returns true due to the '|| true' statement, indicating support for all interfaces, which is incorrect and can mislead users or integrators about the actual supported interfaces of the contract.",
        "file_name": "0x11ce3c5ecfa4cc788eaa94157a63a1ca4863a90c.sol"
    },
    {
        "function_name": "createMarketSale",
        "code": "function createMarketSale(uint256 itemId) public payable nonReentrant { uint256 price = idToMarketItem[itemId].price; uint256 tokenId = idToMarketItem[itemId].tokenId; require( msg.value == price, \"Not the correct message value\" ); require( idToMarketItem[itemId].isSold == false, \"This item is already sold.\" ); require( idToMarketItem[itemId].cancelled == false, \"This item is not for sale.\" ); require( idToMarketItem[itemId].seller != msg.sender, \"Cannot buy your own item.\" ); uint256 fees = SafeMath.div(price, 100).mul(saleFeePercentage); if (discountManager != address(0x0)) { uint256 feeDiscountPercent = IDiscountManager(discountManager) .getDiscount(msg.sender); fees = fees.div(100).mul(feeDiscountPercent); } uint256 saleAmount = price.sub(fees); idToMarketItem[itemId].seller.transfer(saleAmount); accumulatedFee+=fees; transferAnyToken( idToMarketItem[itemId].tokenType, idToMarketItem[itemId].tokenContract, address(this), msg.sender, tokenId, idToMarketItem[itemId].amount ); idToMarketItem[itemId].isSold = true; idToMarketItem[itemId].buyer = payable(msg.sender); _itemsSold.increment(); volumeTraded = volumeTraded.add(price); emit MarketSaleCreated( itemId, idToMarketItem[itemId].tokenContract, tokenId, idToMarketItem[itemId].seller, msg.sender, idToMarketItem[itemId].category, price ); }",
        "vulnerability": "Incorrect fee discount application",
        "reason": "The discount logic applies a percentage discount to the fees rather than reducing the fee by the discount percentage. This results in a higher fee being deducted than intended when a discount is applied, as it reduces the already calculated fee by a percentage instead of recalculating the fee based on the discounted price.",
        "file_name": "0x11ce3c5ecfa4cc788eaa94157a63a1ca4863a90c.sol"
    }
]