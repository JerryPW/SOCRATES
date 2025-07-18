[
    {
        "function_name": "purchaseSafe",
        "vulnerability": "Reentrancy vulnerability",
        "criticism": "The reasoning is correct. The function does send ether back to the user before updating the state variables, which can be exploited by a reentrancy attack. However, the severity and profitability of this vulnerability are high only if the contract has a significant amount of ether. If not, the potential damage and profit are limited.",
        "correctness": 9,
        "severity": 7,
        "profitability": 7,
        "reason": "The function sends ether back to the user via msg.sender.transfer before updating the state variables. This can be exploited by a reentrancy attack where the attacker can call the function recursively, potentially draining funds from the contract.",
        "code": "function purchaseSafe(uint256 tokensToPurchase, uint256 maxPrice) internal returns(uint256 tokensBought_){ require(maxPrice >= 0); uint256 currentPrice = getPurchasePrice(msg.value, tokensToPurchase); require(currentPrice <= maxPrice); uint256 tokensWuiAvailableByCurrentPrice = msg.value.mul(1e18).div(currentPrice); if(tokensWuiAvailableByCurrentPrice > tokensToPurchase) { tokensWuiAvailableByCurrentPrice = tokensToPurchase; } uint256 totalDealPrice = currentPrice.mul(tokensWuiAvailableByCurrentPrice).div(1e18); require(msg.value >= tokensToPurchase.mul(maxPrice).div(1e18)); require(msg.value >= totalDealPrice); feeBalance = feeBalance + totalDealPrice.div(9); uint256 availableTokens = token.balanceOf(this); if (availableTokens < tokensWuiAvailableByCurrentPrice) { uint256 tokensToMint = tokensWuiAvailableByCurrentPrice.sub(availableTokens); token.mint(this, tokensToMint); } token.safeTransfer(msg.sender, tokensWuiAvailableByCurrentPrice); if (totalDealPrice < msg.value) { uint256 oddEthers = msg.value.sub(totalDealPrice); if (oddEthers > 0) { require(oddEthers < msg.value); emit TransferMoneyBack(msg.sender, oddEthers); msg.sender.transfer(oddEthers); trackOdd(oddEthers); } } emit Purchase(msg.sender, tokensToPurchase, totalDealPrice); trackPurchase(tokensWuiAvailableByCurrentPrice, totalDealPrice); return tokensWuiAvailableByCurrentPrice; }",
        "file_name": "0x09a80172ed7335660327cd664876b5df6fe06108.sol"
    },
    {
        "function_name": "buyBack",
        "vulnerability": "Reentrancy vulnerability",
        "criticism": "The reasoning is correct. The function does transfer tokens and then sends ether back to the user without updating state variables first, making it vulnerable to reentrancy attacks. However, the severity and profitability of this vulnerability are high only if the contract has a significant amount of ether and tokens. If not, the potential damage and profit are limited.",
        "correctness": 9,
        "severity": 7,
        "profitability": 7,
        "reason": "The function transfers tokens from the user and then sends ether back to the user through msg.sender.transfer without updating state variables first, making it vulnerable to reentrancy attacks that can be used to withdraw more ether than intended.",
        "code": "function buyBack(uint256 tokensToBuyBack, uint256 minPrice) public { uint currentPrice = getBuyBackPrice(0); require(currentPrice >= minPrice); uint256 totalPrice = tokensToBuyBack.mul(currentPrice).div(1e18); require(tokensToBuyBack > 0); require(tokensToBuyBack <= token.balanceOf(msg.sender)); token.safeTransferFrom(msg.sender, this, tokensToBuyBack); emit BuyBack(msg.sender, tokensToBuyBack, totalPrice); trackBuyBack(tokensToBuyBack, totalPrice); msg.sender.transfer(totalPrice); }",
        "file_name": "0x09a80172ed7335660327cd664876b5df6fe06108.sol"
    },
    {
        "function_name": "doPayments",
        "vulnerability": "Reentrancy vulnerability",
        "criticism": "The reasoning is correct. The function does send ether to the recipient before resetting their balance, which allows an attacker to re-enter the function and withdraw more funds before the balance is updated. However, the severity and profitability of this vulnerability are high only if the contract has a significant amount of ether. If not, the potential damage and profit are limited.",
        "correctness": 9,
        "severity": 7,
        "profitability": 7,
        "reason": "The function sends ether to the recipient before resetting their balance, which allows an attacker to re-enter the function and withdraw more funds before the balance is updated.",
        "code": "function doPayments() public { Recipient storage rec = recs[msg.sender]; require(rec.balance >= 1e12); rec.addr.transfer(rec.balance); emit Payment(rec.addr, rec.balance); rec.received = (rec.received).add(rec.balance); rec.balance = 0; }",
        "file_name": "0x09a80172ed7335660327cd664876b5df6fe06108.sol"
    }
]