[
    {
        "function_name": "burn",
        "code": "function burn(uint256 _value) public onlyOwner{\n    require(_value <= balances[msg.sender]);\n    address burner = msg.sender;\n    balances[burner] = balances[burner].sub(_value);\n    totalSupply_ = totalSupply_.sub(_value);\n    emit Burn(burner, _value);\n}",
        "vulnerability": "Owner-only burn",
        "reason": "The burn function allows only the owner to burn tokens from their own balance, which means that any tokens held by other users cannot be burned. This centralization can lead to lack of trust from users, as they rely solely on the owner's intention and actions. It is also not in line with standard practices where any token holder should be able to burn their own tokens.",
        "file_name": "0x09a80172ed7335660327cd664876b5df6fe06108.sol"
    },
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n    require(_to != address(0));\n    require(_value <= balances[_from]);\n    require(_value <= allowed[_from][msg.sender] || msg.sender == owner);\n    balances[_from] = balances[_from].sub(_value);\n    balances[_to] = balances[_to].add(_value);\n    if (msg.sender != owner) {\n        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n    }\n    emit Transfer(_from, _to, _value);\n    return true;\n}",
        "vulnerability": "Owner bypass of allowance",
        "reason": "The owner can bypass the allowance mechanism in the transferFrom function, allowing them to transfer tokens from any account without explicit approval if they are the caller. This could potentially be exploited by a malicious owner to move tokens without the consent of the token holder, raising serious security and trust issues.",
        "file_name": "0x09a80172ed7335660327cd664876b5df6fe06108.sol"
    },
    {
        "function_name": "purchaseSafe",
        "code": "function purchaseSafe(uint256 tokensToPurchase, uint256 maxPrice) internal returns(uint256 tokensBought_){\n    require(maxPrice >= 0);\n    uint256 currentPrice = getPurchasePrice(msg.value, tokensToPurchase);\n    require(currentPrice <= maxPrice);\n    uint256 tokensWuiAvailableByCurrentPrice = msg.value.mul(1e18).div(currentPrice);\n    if(tokensWuiAvailableByCurrentPrice > tokensToPurchase) {\n        tokensWuiAvailableByCurrentPrice = tokensToPurchase;\n    }\n    uint256 totalDealPrice = currentPrice.mul(tokensWuiAvailableByCurrentPrice).div(1e18);\n    require(msg.value >= tokensToPurchase.mul(maxPrice).div(1e18));\n    require(msg.value >= totalDealPrice);\n    feeBalance = feeBalance + totalDealPrice.div(9);\n    uint256 availableTokens = token.balanceOf(this);\n    if (availableTokens < tokensWuiAvailableByCurrentPrice) {\n        uint256 tokensToMint = tokensWuiAvailableByCurrentPrice.sub(availableTokens);\n        token.mint(this, tokensToMint);\n    }\n    token.safeTransfer(msg.sender, tokensWuiAvailableByCurrentPrice);\n    if (totalDealPrice < msg.value) {\n        uint256 oddEthers = msg.value.sub(totalDealPrice);\n        if (oddEthers > 0) {\n            require(oddEthers < msg.value);\n            emit TransferMoneyBack(msg.sender, oddEthers);\n            msg.sender.transfer(oddEthers);\n            trackOdd(oddEthers);\n        }\n    }\n    emit Purchase(msg.sender, tokensToPurchase, totalDealPrice);\n    trackPurchase(tokensWuiAvailableByCurrentPrice, totalDealPrice);\n    return tokensWuiAvailableByCurrentPrice;\n}",
        "vulnerability": "Arbitrary token minting by contract",
        "reason": "The purchaseSafe function allows the contract to mint new tokens if available tokens are insufficient for the purchase, which can lead to inflation and devaluation of the token. There is no cap on minting, and it is not limited to any specific conditions, allowing the contract to potentially mint unlimited tokens, undermining the token's scarcity and value.",
        "file_name": "0x09a80172ed7335660327cd664876b5df6fe06108.sol"
    }
]