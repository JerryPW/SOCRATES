[
    {
        "function_name": "oraclize_query",
        "code": "function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){ uint price = oraclize.getPrice(datasource); if (price > 1 ether + tx.gasprice*200000) return 0; return oraclize.query.value(price)(0, datasource, arg); }",
        "vulnerability": "Potential Oracle Manipulation",
        "reason": "The function relies on Oraclize to provide data without any validation or verification of the returned data. An attacker could potentially manipulate the oracle to provide incorrect data, which could affect the contract's functionality.",
        "file_name": "0x2aa216f8126190fe5610b1b6c3c4835d1b07c8c8.sol"
    },
    {
        "function_name": "__callback",
        "code": "function __callback(bytes32 myid, string result, bytes proof) public { require(msg.sender == oraclize_cbAddress()); uint newPrice = parseInt(result).mul(100); if (newPrice >= m_ETHPriceLowerBound && newPrice <= m_ETHPriceUpperBound) { m_ETHPriceInCents = newPrice; m_ETHPriceLastUpdate = getTime(); NewETHPrice(m_ETHPriceInCents); } else { ETHPriceOutOfBounds(newPrice); } updateETHPriceInCents(); }",
        "vulnerability": "Oracle Response Validation",
        "reason": "The function updates the ETH price without verifying the authenticity or integrity of the result data beyond a basic bounds check. This could lead to incorrect price updates if the oracle response is tampered with.",
        "file_name": "0x2aa216f8126190fe5610b1b6c3c4835d1b07c8c8.sol"
    },
    {
        "function_name": "buy",
        "code": "function buy() public payable nonReentrant onlyIfSaleIsActive checkLimitsAndDates { require( !priceExpired() ); address investor = msg.sender; uint256 payment = msg.value; require((payment.mul(m_ETHPriceInCents)).div(1 ether) >= c_MinInvestmentInCents); uint tokenAmount; uint cap; uint centsPerToken; if (m_currentTokensSold < c_priceRiseTokenAmount) { centsPerToken = c_centsPerTokenFirst; cap = c_priceRiseTokenAmount; } else { centsPerToken = c_centsPerTokenSecond; cap = c_maximumTokensSold; } tokenAmount = payment.mul(m_ETHPriceInCents).div(centsPerToken); uint maxTokensAllowed = cap.sub(m_currentTokensSold); if (tokenAmount > maxTokensAllowed) { uint ethPerToken = centsPerToken.mul(1 ether).div(m_ETHPriceInCents); tokenAmount = maxTokensAllowed; payment = ethPerToken.mul(tokenAmount).div(1 ether); } m_currentTokensSold = m_currentTokensSold.add(tokenAmount); m_beneficiary.transfer(payment); m_token.transfer(investor, tokenAmount); uint change = msg.value.sub(payment); if (change > 0) investor.transfer(change); FundTransfer(investor, payment, true); }",
        "vulnerability": "Incorrect Ether Transfer Handling",
        "reason": "The function transfers Ether to the beneficiary and returns change to the investor without checking the success of these transfers. An attacker could exploit this by causing the transfers to fail, leading to funds being stuck in the contract.",
        "file_name": "0x2aa216f8126190fe5610b1b6c3c4835d1b07c8c8.sol"
    }
]