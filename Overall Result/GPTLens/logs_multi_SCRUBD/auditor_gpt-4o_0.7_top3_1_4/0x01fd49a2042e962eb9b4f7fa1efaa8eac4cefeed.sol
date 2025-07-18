[
    {
        "function_name": "disqalify",
        "code": "function disqalify(address addr) public onlyOwner returns (bool) { if (isInvestor(addr)) { investors[addr].investment = 0; } }",
        "vulnerability": "Missing return statement",
        "reason": "The `disqalify` function is expected to return a boolean value indicating success but lacks a return statement. This oversight can cause unexpected behavior in the contract's execution and may lead to logical errors in other parts of the system that depend on this return value.",
        "file_name": "0x01fd49a2042e962eb9b4f7fa1efaa8eac4cefeed.sol"
    },
    {
        "function_name": "doInvest",
        "code": "function doInvest(address referrerAddr) public payable notFromContract balanceChanged { uint investment = msg.value; uint receivedEther = msg.value; require(investment >= minInvesment, \"investment must be >= minInvesment\"); require(address(this).balance <= maxBalance, \"the contract eth balance limit\"); if (m_rgp.isActive()) { uint rpgMaxInvest = m_rgp.maxInvestmentAtNow(); rpgMaxInvest.requireNotZero(); investment = Math.min(investment, rpgMaxInvest); assert(m_rgp.saveInvestment(investment)); emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay()); } else if (m_privEnter.isActive()) { uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender); peMaxInvest.requireNotZero(); investment = Math.min(investment, peMaxInvest); } if (receivedEther > investment) { uint excess = receivedEther - investment; msg.sender.transfer(excess); receivedEther = investment; emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess); } advertisingAddress.send(m_advertisingPercent.mul(receivedEther)); adminsAddress.send(m_adminsPercent.mul(receivedEther)); bool senderIsInvestor = m_investors.isInvestor(msg.sender); if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] && referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) { m_referrals[msg.sender] = true; uint referrerBonus = m_referrer_percent.mmul(investment); if (investment > 10 ether) { referrerBonus = m_referrer_percentMax.mmul(investment); } uint referalBonus = m_referal_percent.mmul(investment); assert(m_investors.addInvestment(referrerAddr, referrerBonus)); investment += referalBonus; emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus); } uint dividends = calcDividends(msg.sender); if (senderIsInvestor && dividends.notZero()) { investment += dividends; emit LogAutomaticReinvest(msg.sender, now, dividends); } if (senderIsInvestor) { assert(m_investors.addInvestment(msg.sender, investment)); assert(m_investors.setPaymentTime(msg.sender, now)); } else { assert(m_investors.newInvestor(msg.sender, investment, now)); emit LogNewInvestor(msg.sender, now); } investmentsNumber++; emit LogNewInvesment(msg.sender, now, investment, receivedEther); }",
        "vulnerability": "Unsafe use of `send`",
        "reason": "The function uses `send` for transferring Ether to `advertisingAddress` and `adminsAddress`, which can fail silently and return false without throwing an exception. This can lead to situations where funds are not transferred as expected, potentially causing financial loss or inconsistent state within the contract.",
        "file_name": "0x01fd49a2042e962eb9b4f7fa1efaa8eac4cefeed.sol"
    },
    {
        "function_name": "getMyDividends",
        "code": "function getMyDividends() public notFromContract balanceChanged { require(now.sub(getMemInvestor(msg.sender).paymentTime) > 24 hours); uint dividends = calcDividends(msg.sender); require (dividends.notZero(), \"cannot to pay zero dividends\"); assert(m_investors.setPaymentTime(msg.sender, now)); if (address(this).balance <= dividends) { nextWave(); dividends = address(this).balance; } msg.sender.transfer(dividends); emit LogPayDividends(msg.sender, now, dividends); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `getMyDividends` function has a reentrancy vulnerability. It transfers Ether to the user before updating the state to reflect the new payment time. If an attacker creates a contract that calls back into `getMyDividends` during the transfer, they could call `getMyDividends` again before the state is updated, allowing them to drain funds from the contract.",
        "file_name": "0x01fd49a2042e962eb9b4f7fa1efaa8eac4cefeed.sol"
    }
]