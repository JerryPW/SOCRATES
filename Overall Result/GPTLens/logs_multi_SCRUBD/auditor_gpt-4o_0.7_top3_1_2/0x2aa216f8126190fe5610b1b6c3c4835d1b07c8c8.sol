[
    {
        "function_name": "updateETHPriceInCents",
        "code": "function updateETHPriceInCents() public payable { if ( !updateRequestExpired() ) { NewOraclizeQuery(\"Oraclize request fail. Previous one still pending\"); } else if (oraclize_getPrice(\"URL\") > this.balance) { NewOraclizeQuery(\"Oraclize request fail. Not enough ether\"); } else { oraclize_query( m_ETHPriceUpdateInterval, \"URL\", \"(https: m_callbackGas ); m_ETHPriceLastUpdateRequest = getTime(); NewOraclizeQuery(\"Oraclize query was sent\"); } }",
        "vulnerability": "Reentrancy",
        "reason": "The function `updateETHPriceInCents` calls `oraclize_query`, which is an external call, without properly checking or ensuring no state changes after the call. This can potentially lead to reentrancy vulnerabilities if the external call is to a malicious contract.",
        "file_name": "0x2aa216f8126190fe5610b1b6c3c4835d1b07c8c8.sol"
    },
    {
        "function_name": "__callback",
        "code": "function __callback(bytes32 myid, string result, bytes proof) public { require(msg.sender == oraclize_cbAddress()); uint newPrice = parseInt(result).mul(100); if (newPrice >= m_ETHPriceLowerBound && newPrice <= m_ETHPriceUpperBound) { m_ETHPriceInCents = newPrice; m_ETHPriceLastUpdate = getTime(); NewETHPrice(m_ETHPriceInCents); } else { ETHPriceOutOfBounds(newPrice); } updateETHPriceInCents(); }",
        "vulnerability": "Improper Access Control",
        "reason": "The function `__callback` can be called by any address as long as it matches the `oraclize_cbAddress`. If this address is ever compromised or incorrectly set, unauthorized entities can manipulate ETH prices by calling this function with arbitrary values.",
        "file_name": "0x2aa216f8126190fe5610b1b6c3c4835d1b07c8c8.sol"
    },
    {
        "function_name": "buy",
        "code": "function buy() public payable nonReentrant onlyIfSaleIsActive checkLimitsAndDates { require( !priceExpired() ); address investor = msg.sender; uint256 payment = msg.value; require((payment.mul(m_ETHPriceInCents)).div(1 ether) >= c_MinInvestmentInCents); uint tokenAmount; uint cap; uint centsPerToken; if (m_currentTokensSold < c_priceRiseTokenAmount) { centsPerToken = c_centsPerTokenFirst; cap = c_priceRiseTokenAmount; } else { centsPerToken = c_centsPerTokenSecond; cap = c_maximumTokensSold; } tokenAmount = payment.mul(m_ETHPriceInCents).div(centsPerToken); uint maxTokensAllowed = cap.sub(m_currentTokensSold); if (tokenAmount > maxTokensAllowed) { uint ethPerToken = centsPerToken.mul(1 ether).div(m_ETHPriceInCents); tokenAmount = maxTokensAllowed; payment = ethPerToken.mul(tokenAmount).div(1 ether); } m_currentTokensSold = m_currentTokensSold.add(tokenAmount); m_beneficiary.transfer(payment); m_token.transfer(investor, tokenAmount); uint change = msg.value.sub(payment); if (change > 0) investor.transfer(change); FundTransfer(investor, payment, true); }",
        "vulnerability": "Lack of Input Validation",
        "reason": "The `buy` function does not sufficiently validate the input values, such as `msg.value`. Malicious users could send incorrect or unexpected values to the function, potentially causing unexpected behavior or overflow errors.",
        "file_name": "0x2aa216f8126190fe5610b1b6c3c4835d1b07c8c8.sol"
    }
]