[
    {
        "function_name": "doInvest",
        "code": "function doInvest(address referrerAddr) public payable notFromContract balanceChanged { uint investment = msg.value; uint receivedEther = msg.value; require(investment >= minInvesment, \"investment must be >= minInvesment\"); require(address(this).balance <= maxBalance, \"the contract eth balance limit\"); if (m_rgp.isActive()) { uint rpgMaxInvest = m_rgp.maxInvestmentAtNow(); rpgMaxInvest.requireNotZero(); investment = Math.min(investment, rpgMaxInvest); assert(m_rgp.saveInvestment(investment)); emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay()); } else if (m_privEnter.isActive()) { uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender); peMaxInvest.requireNotZero(); investment = Math.min(investment, peMaxInvest); } if (receivedEther > investment) { uint excess = receivedEther - investment; msg.sender.transfer(excess); receivedEther = investment; emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess); } advertisingAddress.send(m_advertisingPercent.mul(receivedEther)); adminsAddress.send(m_adminsPercent.mul(receivedEther)); bool senderIsInvestor = m_investors.isInvestor(msg.sender); if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] && referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) { m_referrals[msg.sender] = true; uint referrerBonus = m_referrer_percent.mmul(investment); if (investment > 10 ether) { referrerBonus = m_referrer_percentMax.mmul(investment); } uint referalBonus = m_referal_percent.mmul(investment); assert(m_investors.addInvestment(referrerAddr, referrerBonus)); investment += referalBonus; emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus); } uint dividends = calcDividends(msg.sender); if (senderIsInvestor && dividends.notZero()) { investment += dividends; emit LogAutomaticReinvest(msg.sender, now, dividends); } if (senderIsInvestor) { assert(m_investors.addInvestment(msg.sender, investment)); assert(m_investors.setPaymentTime(msg.sender, now)); } else { assert(m_investors.newInvestor(msg.sender, investment, now)); emit LogNewInvestor(msg.sender, now); } investmentsNumber++; emit LogNewInvesment(msg.sender, now, investment, receivedEther); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function transfers Ether to the sender before updating the state variables, making it vulnerable to reentrancy attacks. An attacker could exploit this by recursively calling the function to drain the contract's funds before the state is updated.",
        "file_name": "0x01fd49a2042e962eb9b4f7fa1efaa8eac4cefeed.sol"
    },
    {
        "function_name": "getMyDividends",
        "code": "function getMyDividends() public notFromContract balanceChanged { require(now.sub(getMemInvestor(msg.sender).paymentTime) > 24 hours); uint dividends = calcDividends(msg.sender); require (dividends.notZero(), \"cannot to pay zero dividends\"); assert(m_investors.setPaymentTime(msg.sender, now)); if (address(this).balance <= dividends) { nextWave(); dividends = address(this).balance; } msg.sender.transfer(dividends); emit LogPayDividends(msg.sender, now, dividends); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function sends Ether to the caller before updating the state. This allows an attacker to repeatedly call getMyDividends and potentially drain the contract's funds through reentrancy.",
        "file_name": "0x01fd49a2042e962eb9b4f7fa1efaa8eac4cefeed.sol"
    },
    {
        "function_name": "disqalify",
        "code": "function disqalify(address addr) public onlyOwner returns (bool) { if (isInvestor(addr)) { investors[addr].investment = 0; } }",
        "vulnerability": "Lack of event logging",
        "reason": "The function modifies the state without emitting an event, which can lead to lack of transparency and difficulty in tracking changes to the contract state. In a real-world scenario, this might enable an owner to disqualify investors without leaving a trace in the event logs.",
        "file_name": "0x01fd49a2042e962eb9b4f7fa1efaa8eac4cefeed.sol"
    }
]