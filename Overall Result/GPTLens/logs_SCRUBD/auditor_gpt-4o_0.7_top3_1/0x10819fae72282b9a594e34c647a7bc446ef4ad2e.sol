[
    {
        "function_name": "doInvest",
        "code": "function doInvest(address referrerAddr) public payable notFromContract balanceChanged { uint investment = msg.value; uint receivedEther = msg.value; require(investment >= minInvesment, \"investment must be >= minInvesment\"); require(address(this).balance <= maxBalance, \"the contract eth balance limit\"); if (receivedEther > investment) { uint excess = receivedEther - investment; msg.sender.transfer(excess); receivedEther = investment; emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess); } advertisingAddress.transfer(m_advertisingPercent.mul(receivedEther)); adminsAddress.transfer(m_adminsPercent.mul(receivedEther)); if (msg.value > 0) { if (msg.data.length == 20) { referrerAddr.transfer(m_referrer_percent.mmul(investment)); } else if (msg.data.length == 0) { adminsAddress.transfer(m_referrer_percent.mmul(investment)); } else { assert(false); }} bool senderIsInvestor = m_investors.isInvestor(msg.sender); if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] && referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) { m_referrals[msg.sender] = true; uint referrerBonus = m_referrer_percent.mmul(investment); if (investment > 10 ether) { referrerBonus = m_referrer_percentMax.mmul(investment); }} uint dividends = calcDividends(msg.sender); if (senderIsInvestor && dividends.notZero()) { investment = (investment += dividends) * 70/100; emit LogAutomaticReinvest(msg.sender, now, dividends); } if (senderIsInvestor) { assert(m_investors.addInvestment(msg.sender, investment)); assert(m_investors.setPaymentTime(msg.sender, now)); } else { assert(m_investors.newInvestor(msg.sender, investment, now)); emit LogNewInvestor(msg.sender, now); } investmentsNumber++; emit LogNewInvesment(msg.sender, now, investment, receivedEther); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function allows for external calls before updating the investor's state. Specifically, transferring ethers to `referrerAddr`, `advertisingAddress`, and `adminsAddress` occurs before updating the investor\u2019s data, making it vulnerable to a reentrancy attack. An attacker can exploit this by calling the function recursively before the state is updated, potentially draining funds.",
        "file_name": "0x10819fae72282b9a594e34c647a7bc446ef4ad2e.sol"
    },
    {
        "function_name": "disqalify",
        "code": "function disqalify(address addr) public onlyOwner returns (bool) { if (isInvestor(addr)) { investors[addr].paymentTime = now + 1 days; } }",
        "vulnerability": "Misleading function logic",
        "reason": "The function name 'disqalify' suggests that it disqualifies an investor, but instead, it sets the paymentTime to 'now + 1 days'. This does not remove the investor or prevent future actions, leading to potential confusion and misuse by assuming it performs a disqualification.",
        "file_name": "0x10819fae72282b9a594e34c647a7bc446ef4ad2e.sol"
    },
    {
        "function_name": "addInvestment2",
        "code": "function addInvestment2( uint investment, address investorAddr) public onlyOwner { investorAddr.transfer(investment); }",
        "vulnerability": "Arbitrary transfer by owner",
        "reason": "The function allows the owner to transfer arbitrary amounts of ether from the contract to any investor address without any checks, which could be exploited for malicious withdrawals or unauthorized transfers, compromising the integrity and security of the contract\u2019s funds.",
        "file_name": "0x10819fae72282b9a594e34c647a7bc446ef4ad2e.sol"
    }
]