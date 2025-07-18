[
    {
        "function_name": "buyBack",
        "code": "function buyBack(uint256 tokensToBuyBack, uint256 minPrice) public { uint currentPrice = getBuyBackPrice(0); require(currentPrice >= minPrice); uint256 totalPrice = tokensToBuyBack.mul(currentPrice).div(1e18); require(tokensToBuyBack > 0); require(tokensToBuyBack <= token.balanceOf(msg.sender)); token.safeTransferFrom(msg.sender, this, tokensToBuyBack); emit BuyBack(msg.sender, tokensToBuyBack, totalPrice); trackBuyBack(tokensToBuyBack, totalPrice); msg.sender.transfer(totalPrice); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function transfers tokens from the sender to the contract before transferring ETH back to the sender. This sequence allows for a reentrancy attack where the attacker could call buyBack again before the state variables are updated, potentially draining ETH from the contract.",
        "file_name": "0x09a80172ed7335660327cd664876b5df6fe06108.sol"
    },
    {
        "function_name": "purchaseSafe",
        "code": "function purchaseSafe(uint256 tokensToPurchase, uint256 maxPrice) internal returns(uint256 tokensBought_){ require(maxPrice >= 0); uint256 currentPrice = getPurchasePrice(msg.value, tokensToPurchase); require(currentPrice <= maxPrice); uint256 tokensWuiAvailableByCurrentPrice = msg.value.mul(1e18).div(currentPrice); if(tokensWuiAvailableByCurrentPrice > tokensToPurchase) { tokensWuiAvailableByCurrentPrice = tokensToPurchase; } uint256 totalDealPrice = currentPrice.mul(tokensWuiAvailableByCurrentPrice).div(1e18); require(msg.value >= tokensToPurchase.mul(maxPrice).div(1e18)); require(msg.value >= totalDealPrice); feeBalance = feeBalance + totalDealPrice.div(9); uint256 availableTokens = token.balanceOf(this); if (availableTokens < tokensWuiAvailableByCurrentPrice) { uint256 tokensToMint = tokensWuiAvailableByCurrentPrice.sub(availableTokens); token.mint(this, tokensToMint); } token.safeTransfer(msg.sender, tokensWuiAvailableByCurrentPrice); if (totalDealPrice < msg.value) { uint256 oddEthers = msg.value.sub(totalDealPrice); if (oddEthers > 0) { require(oddEthers < msg.value); emit TransferMoneyBack(msg.sender, oddEthers); msg.sender.transfer(oddEthers); trackOdd(oddEthers); } } emit Purchase(msg.sender, tokensToPurchase, totalDealPrice); trackPurchase(tokensWuiAvailableByCurrentPrice, totalDealPrice); return tokensWuiAvailableByCurrentPrice; }",
        "vulnerability": "Potential for incorrect Ether refund",
        "reason": "The function calculates and refunds excess Ether to the user after transferring tokens. If an attacker can manipulate the token price between the purchase and refund, they might receive more Ether back than intended, especially if they can influence the getPurchasePrice calculation.",
        "file_name": "0x09a80172ed7335660327cd664876b5df6fe06108.sol"
    },
    {
        "function_name": "changeRecipientAddress",
        "code": "function changeRecipientAddress(address _newRec) public { require(msg.sender != address(0)); require(_newRec != address(0)); require(recs[msg.sender].addr != address(0)); require(recs[_newRec].addr == address(0)); require(recs[msg.sender].addr != _newRec); Recipient storage rec = recs[msg.sender]; uint256 prevBalance = rec.balance; addShare(_newRec, rec.share); emit ChangeAddessShare(_newRec); deleteShare(msg.sender); recs[_newRec].balance = prevBalance; emit DeleteShare(msg.sender); }",
        "vulnerability": "Incorrect handling of recipient change",
        "reason": "When changing the recipient address, the function first adds the new recipient and then deletes the old one. If an error occurs during `addShare`, the old recipient's data might be corrupted or lost, leading to inconsistencies and potential loss of funds.",
        "file_name": "0x09a80172ed7335660327cd664876b5df6fe06108.sol"
    }
]