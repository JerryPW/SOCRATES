[
    {
        "function_name": "purchaseSafe",
        "code": "function purchaseSafe(uint256 tokensToPurchase, uint256 maxPrice) internal returns(uint256 tokensBought_){ require(maxPrice >= 0); uint256 currentPrice = getPurchasePrice(msg.value, tokensToPurchase); require(currentPrice <= maxPrice); uint256 tokensWuiAvailableByCurrentPrice = msg.value.mul(1e18).div(currentPrice); if(tokensWuiAvailableByCurrentPrice > tokensToPurchase) { tokensWuiAvailableByCurrentPrice = tokensToPurchase; } uint256 totalDealPrice = currentPrice.mul(tokensWuiAvailableByCurrentPrice).div(1e18); require(msg.value >= tokensToPurchase.mul(maxPrice).div(1e18)); require(msg.value >= totalDealPrice); feeBalance = feeBalance + totalDealPrice.div(9); uint256 availableTokens = token.balanceOf(this); if (availableTokens < tokensWuiAvailableByCurrentPrice) { uint256 tokensToMint = tokensWuiAvailableByCurrentPrice.sub(availableTokens); token.mint(this, tokensToMint); } token.safeTransfer(msg.sender, tokensWuiAvailableByCurrentPrice); if (totalDealPrice < msg.value) { uint256 oddEthers = msg.value.sub(totalDealPrice); if (oddEthers > 0) { require(oddEthers < msg.value); emit TransferMoneyBack(msg.sender, oddEthers); msg.sender.transfer(oddEthers); trackOdd(oddEthers); } } emit Purchase(msg.sender, tokensToPurchase, totalDealPrice); trackPurchase(tokensWuiAvailableByCurrentPrice, totalDealPrice); return tokensWuiAvailableByCurrentPrice; }",
        "vulnerability": "Potential overflow in ether refund",
        "reason": "The calculation of `oddEthers` could lead to a situation where a large ether value is subtracted from a smaller one, resulting in a negative value that underflows, causing the smart contract to send an incorrect refund amount. This could be exploited by an attacker to drain funds.",
        "file_name": "0x09a80172ed7335660327cd664876b5df6fe06108.sol"
    },
    {
        "function_name": "buyBack",
        "code": "function buyBack(uint256 tokensToBuyBack, uint256 minPrice) public { uint currentPrice = getBuyBackPrice(0); require(currentPrice >= minPrice); uint256 totalPrice = tokensToBuyBack.mul(currentPrice).div(1e18); require(tokensToBuyBack > 0); require(tokensToBuyBack <= token.balanceOf(msg.sender)); token.safeTransferFrom(msg.sender, this, tokensToBuyBack); emit BuyBack(msg.sender, tokensToBuyBack, totalPrice); trackBuyBack(tokensToBuyBack, totalPrice); msg.sender.transfer(totalPrice); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function transfers ether back to `msg.sender` after interacting with external contracts, specifically `token.safeTransferFrom`. This order of operations could allow a reentrancy attack where `msg.sender` can call back into the contract before the state changes are completed, potentially allowing manipulation of the buyback process.",
        "file_name": "0x09a80172ed7335660327cd664876b5df6fe06108.sol"
    },
    {
        "function_name": "mint",
        "code": "function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) { totalSupply_ = totalSupply_.add(_amount); balances[_to] = balances[_to].add(_amount); emit Mint(_to, _amount); emit Transfer(address(0), _to, _amount); return true; }",
        "vulnerability": "Unlimited minting by owner",
        "reason": "The owner of the contract can call the `mint` function to create an unlimited amount of tokens, which can lead to inflation and devaluation of the token. This centralization of power poses a significant risk to the token's value and trust in the system.",
        "file_name": "0x09a80172ed7335660327cd664876b5df6fe06108.sol"
    }
]