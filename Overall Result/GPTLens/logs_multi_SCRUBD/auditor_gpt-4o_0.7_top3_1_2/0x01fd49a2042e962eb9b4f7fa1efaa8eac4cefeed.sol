[
    {
        "function_name": "calcDividends",
        "code": "function calcDividends(address investorAddr) internal view returns(uint dividends) { InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr); if (investor.investment.isZero() || now.sub(investor.paymentTime) < 10 minutes) { return 0; } Percent.percent memory p = dailyPercent(); dividends = (now.sub(investor.paymentTime) / 10 minutes) * p.mmul(investor.investment) / 144; }",
        "vulnerability": "Time Manipulation",
        "reason": "The function calcDividends relies on the 'now' value to calculate the dividends. Miners can manipulate the timestamp slightly, which could potentially be exploited to affect the dividends calculation. This is particularly concerning as it is used as a condition to determine if dividends should be paid out or not.",
        "file_name": "0x01fd49a2042e962eb9b4f7fa1efaa8eac4cefeed.sol"
    },
    {
        "function_name": "doInvest",
        "code": "function doInvest(address referrerAddr) public payable notFromContract balanceChanged { uint investment = msg.value; uint receivedEther = msg.value; require(investment >= minInvesment, \"investment must be >= minInvesment\"); require(address(this).balance <= maxBalance, \"the contract eth balance limit\"); if (m_rgp.isActive()) { uint rpgMaxInvest = m_rgp.maxInvestmentAtNow(); rpgMaxInvest.requireNotZero(); investment = Math.min(investment, rpgMaxInvest); assert(m_rgp.saveInvestment(investment)); emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay()); } else if (m_privEnter.isActive()) { uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender); peMaxInvest.requireNotZero(); investment = Math.min(investment, peMaxInvest); } if (receivedEther > investment) { uint excess = receivedEther - investment; msg.sender.transfer(excess); receivedEther = investment; emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess); } advertisingAddress.send(m_advertisingPercent.mul(receivedEther)); adminsAddress.send(m_adminsPercent.mul(receivedEther)); bool senderIsInvestor = m_investors.isInvestor(msg.sender); if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] && referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) { m_referrals[msg.sender] = true; uint referrerBonus = m_referrer_percent.mmul(investment); if (investment > 10 ether) { referrerBonus = m_referrer_percentMax.mmul(investment); } uint referalBonus = m_referal_percent.mmul(investment); assert(m_investors.addInvestment(referrerAddr, referrerBonus)); investment += referalBonus; emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus); } uint dividends = calcDividends(msg.sender); if (senderIsInvestor && dividends.notZero()) { investment += dividends; emit LogAutomaticReinvest(msg.sender, now, dividends); } if (senderIsInvestor) { assert(m_investors.addInvestment(msg.sender, investment)); assert(m_investors.setPaymentTime(msg.sender, now)); } else { assert(m_investors.newInvestor(msg.sender, investment, now)); emit LogNewInvestor(msg.sender, now); } investmentsNumber++; emit LogNewInvesment(msg.sender, now, investment, receivedEther); }",
        "vulnerability": "Reentrancy",
        "reason": "The function doInvest transfers Ether before updating the state concerning the investment. Specifically, it transfers excess Ether back to the sender and payments to advertisingAddress and adminsAddress without using a reentrancy guard. An attacker could exploit this by recursively calling doInvest, potentially disrupting the expected state changes or draining funds.",
        "file_name": "0x01fd49a2042e962eb9b4f7fa1efaa8eac4cefeed.sol"
    },
    {
        "function_name": "disqalify",
        "code": "function disqalify(address addr) public onlyOwner returns (bool) { if (isInvestor(addr)) { investors[addr].investment = 0; } }",
        "vulnerability": "Lack of Return Value Handling",
        "reason": "The function disqalify does not return a value consistently, as it lacks a return statement if the investor is not found. This could lead to unexpected behavior in the contract logic that relies on the return value of this function to make decisions.",
        "file_name": "0x01fd49a2042e962eb9b4f7fa1efaa8eac4cefeed.sol"
    }
]