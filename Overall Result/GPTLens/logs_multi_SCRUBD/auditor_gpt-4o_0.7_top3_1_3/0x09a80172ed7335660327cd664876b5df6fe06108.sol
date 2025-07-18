[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address _from, address _to, uint256 _value) public returns (bool) { require(_to != address(0)); require(_value <= balances[_from]); require(_value <= allowed[_from][msg.sender] || msg.sender == owner); balances[_from] = balances[_from].sub(_value); balances[_to] = balances[_to].add(_value); if (msg.sender != owner) { allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); } emit Transfer(_from, _to, _value); return true; }",
        "vulnerability": "Owner privilege in transferFrom",
        "reason": "The function allows the contract owner to transfer any user's tokens without requiring approval, which can be exploited for unauthorized transfers.",
        "file_name": "0x09a80172ed7335660327cd664876b5df6fe06108.sol"
    },
    {
        "function_name": "getFee",
        "code": "function getFee() public { if(feeBalance > 1e15){ feeReceiverContract.receiveFunds.value(feeBalance).gas(150000)(); trackFee(feeBalance); feeBalance = 0; } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function involves sending ether to an external contract without using the Checks-Effects-Interactions pattern, which might be exploited for reentrancy attacks if the external contract is malicious.",
        "file_name": "0x09a80172ed7335660327cd664876b5df6fe06108.sol"
    },
    {
        "function_name": "purchaseSafe",
        "code": "function purchaseSafe(uint256 tokensToPurchase, uint256 maxPrice) internal returns(uint256 tokensBought_){ require(maxPrice >= 0); uint256 currentPrice = getPurchasePrice(msg.value, tokensToPurchase); require(currentPrice <= maxPrice); uint256 tokensWuiAvailableByCurrentPrice = msg.value.mul(1e18).div(currentPrice); if(tokensWuiAvailableByCurrentPrice > tokensToPurchase) { tokensWuiAvailableByCurrentPrice = tokensToPurchase; } uint256 totalDealPrice = currentPrice.mul(tokensWuiAvailableByCurrentPrice).div(1e18); require(msg.value >= tokensToPurchase.mul(maxPrice).div(1e18)); require(msg.value >= totalDealPrice); feeBalance = feeBalance + totalDealPrice.div(9); uint256 availableTokens = token.balanceOf(this); if (availableTokens < tokensWuiAvailableByCurrentPrice) { uint256 tokensToMint = tokensWuiAvailableByCurrentPrice.sub(availableTokens); token.mint(this, tokensToMint); } token.safeTransfer(msg.sender, tokensWuiAvailableByCurrentPrice); if (totalDealPrice < msg.value) { uint256 oddEthers = msg.value.sub(totalDealPrice); if (oddEthers > 0) { require(oddEthers < msg.value); emit TransferMoneyBack(msg.sender, oddEthers); msg.sender.transfer(oddEthers); trackOdd(oddEthers); } } emit Purchase(msg.sender, tokensToPurchase, totalDealPrice); trackPurchase(tokensWuiAvailableByCurrentPrice, totalDealPrice); return tokensWuiAvailableByCurrentPrice; }",
        "vulnerability": "Multiple vulnerabilities: Minting without limits and potential for incorrect pricing logic",
        "reason": "The function allows minting of tokens if available tokens are less than those available by current price, without any upper limit, leading to potential inflation. The pricing logic can also be manipulated if the contract balance or discount structure is incorrectly set.",
        "file_name": "0x09a80172ed7335660327cd664876b5df6fe06108.sol"
    }
]