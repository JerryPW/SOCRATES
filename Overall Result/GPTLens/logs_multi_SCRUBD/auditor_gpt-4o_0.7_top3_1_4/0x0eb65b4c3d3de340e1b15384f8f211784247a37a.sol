[
    {
        "function_name": "recoverStuckETH",
        "code": "function recoverStuckETH(address payable _recipient, uint256 _amount) public onlyAdmin { (bool success,) = _recipient.call{value : _amount}(\"\"); require(success, \"Unable to send recipient ETH\"); emit AdminRecoverETH(_recipient, _amount); }",
        "vulnerability": "Lack of checks for ETH balance",
        "reason": "The function allows an admin to recover ETH from the contract without checking if the contract has sufficient balance. This could cause the transaction to fail if the balance is less than the requested amount, making it impossible to recover lower amounts afterward. An attacker who gains admin access could abuse this function to attempt to withdraw large amounts, potentially disrupting the contract's operations.",
        "file_name": "0x0eb65b4c3d3de340e1b15384f8f211784247a37a.sol"
    },
    {
        "function_name": "updatePlatformSecondarySaleCommission",
        "code": "function updatePlatformSecondarySaleCommission(uint256 _platformSecondarySaleCommission) public onlyAdmin { platformSecondarySaleCommission = _platformSecondarySaleCommission; emit AdminUpdateSecondarySaleCommission(_platformSecondarySaleCommission); }",
        "vulnerability": "Unrestricted commission update",
        "reason": "This function allows an admin to set the platform's secondary sale commission to any value, including values higher than the sale amount itself, potentially allowing the platform to seize all proceeds from a sale. This opens up an opportunity for malicious behavior by a compromised admin account.",
        "file_name": "0x0eb65b4c3d3de340e1b15384f8f211784247a37a.sol"
    },
    {
        "function_name": "listForReserveAuction",
        "code": "function listForReserveAuction( address _creator, uint256 _id, uint128 _reservePrice, uint128 _startDate ) public override whenNotPaused { require(_isListingPermitted(_id), \"Listing not permitted\"); require(_isReserveListingPermitted(_id), \"Reserve listing not permitted\"); require(_reservePrice >= minBidAmount, \"Reserve price must be at least min bid\"); editionOrTokenWithReserveAuctions[_id] = ReserveAuction({ seller : _creator, bidder : address(0), reservePrice : _reservePrice, startDate : _startDate, biddingEnd : 0, bid : 0 }); emit ListedForReserveAuction(_id, _reservePrice, _startDate); }",
        "vulnerability": "Lack of seller ownership verification",
        "reason": "This function does not adequately verify that the seller is indeed the owner of the token being listed for auction. An attacker could exploit this by listing tokens they do not own, potentially interfering with legitimate auctions or causing confusion in the marketplace.",
        "file_name": "0x0eb65b4c3d3de340e1b15384f8f211784247a37a.sol"
    }
]