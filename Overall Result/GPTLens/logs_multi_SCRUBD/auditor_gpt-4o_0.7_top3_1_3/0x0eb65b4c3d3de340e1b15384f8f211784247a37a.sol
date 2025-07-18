[
    {
        "function_name": "resultReserveAuction",
        "code": "function resultReserveAuction(uint256 _id) public override whenNotPaused nonReentrant { ReserveAuction storage reserveAuction = editionOrTokenWithReserveAuctions[_id]; require(reserveAuction.reservePrice > 0, \"No active auction\"); require(reserveAuction.bid >= reserveAuction.reservePrice, \"Reserve not met\"); require(block.timestamp > reserveAuction.biddingEnd, \"Bidding has not yet ended\"); address winner = reserveAuction.bidder; address seller = reserveAuction.seller; uint256 winningBid = reserveAuction.bid; delete editionOrTokenWithReserveAuctions[_id]; _processSale(_id, winningBid, winner, seller); emit ReserveAuctionResulted(_id, winningBid, seller, winner, _msgSender()); }",
        "vulnerability": "Lack of Access Control",
        "reason": "The function `resultReserveAuction` can be called by anyone once the conditions are met, allowing any user to finalize an auction and potentially deny the seller the ability to control the auction process. This could lead to auctions being ended prematurely or by unauthorized parties.",
        "file_name": "0x0eb65b4c3d3de340e1b15384f8f211784247a37a.sol"
    },
    {
        "function_name": "emergencyExitBidFromReserveAuction",
        "code": "function emergencyExitBidFromReserveAuction(uint256 _id) public override whenNotPaused nonReentrant { ReserveAuction storage reserveAuction = editionOrTokenWithReserveAuctions[_id]; require(reserveAuction.bid > 0, \"No bid in flight\"); require(_hasReserveListingBeenInvalidated(_id), \"Bid cannot be withdrawn as reserve auction listing is valid\"); bool isSeller = reserveAuction.seller == _msgSender(); bool isBidder = reserveAuction.bidder == _msgSender(); require( isSeller || isBidder || accessControls.isVerifiedArtistProxy(reserveAuction.seller, _msgSender()) || accessControls.hasContractOrAdminRole(_msgSender()), \"Only seller, bidder, contract or platform admin\" ); _refundBidder(_id, reserveAuction.bidder, reserveAuction.bid, address(0), 0); emit EmergencyBidWithdrawFromReserveAuction(_id, reserveAuction.bidder, reserveAuction.bid); delete editionOrTokenWithReserveAuctions[_id]; }",
        "vulnerability": "Emergency Exit Misuse",
        "reason": "The function allows for the emergency exit of a bid if the listing has been invalidated, which can be triggered by various roles. This function could be misused by a privileged user (contract or platform admin) to cancel bids and auctions inappropriately, without the seller or bidder's consent, potentially disrupting legitimate auctions.",
        "file_name": "0x0eb65b4c3d3de340e1b15384f8f211784247a37a.sol"
    },
    {
        "function_name": "setBuyNowPriceListing",
        "code": "function setBuyNowPriceListing(uint256 _id, uint128 _listingPrice) public override whenNotPaused { require( editionOrTokenListings[_id].seller == _msgSender() || accessControls.isVerifiedArtistProxy(editionOrTokenListings[_id].seller, _msgSender()), \"Only seller can change price\" ); editionOrTokenListings[_id].price = _listingPrice; emit BuyNowPriceChanged(_id, _listingPrice); }",
        "vulnerability": "Price Manipulation",
        "reason": "The function allows the seller or an authorized proxy to change the listing price at any time without restrictions on frequency or amount changed. This could be exploited to manipulate prices post-listing, creating uncertainty for buyers and potentially leading to misleading listing practices.",
        "file_name": "0x0eb65b4c3d3de340e1b15384f8f211784247a37a.sol"
    }
]