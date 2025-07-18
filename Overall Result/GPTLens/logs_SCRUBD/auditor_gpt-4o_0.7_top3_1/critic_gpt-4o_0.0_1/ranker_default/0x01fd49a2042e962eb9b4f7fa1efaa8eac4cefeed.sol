[
    {
        "function_name": "getMyDividends",
        "vulnerability": "Reentrancy vulnerability",
        "criticism": "The reasoning is correct. The function sends Ether to the caller before updating the state, which is a classic reentrancy vulnerability. This could allow an attacker to repeatedly call the function and drain the contract's funds. The severity is high because it directly affects the contract's balance, and the profitability is also high for an attacker who can exploit this vulnerability.",
        "correctness": 9,
        "severity": 8,
        "profitability": 8,
        "reason": "The function sends Ether to the caller before updating the state. This allows an attacker to repeatedly call getMyDividends and potentially drain the contract's funds through reentrancy.",
        "code": "function getMyDividends() public notFromContract balanceChanged { require(now.sub(getMemInvestor(msg.sender).paymentTime) > 24 hours); uint dividends = calcDividends(msg.sender); require (dividends.notZero(), \"cannot to pay zero dividends\"); assert(m_investors.setPaymentTime(msg.sender, now)); if (address(this).balance <= dividends) { nextWave(); dividends = address(this).balance; } msg.sender.transfer(dividends); emit LogPayDividends(msg.sender, now, dividends); }",
        "file_name": "0x01fd49a2042e962eb9b4f7fa1efaa8eac4cefeed.sol",
        "final_score": 8.5
    },
    {
        "function_name": "doInvest",
        "vulnerability": "Reentrancy vulnerability",
        "criticism": "The reasoning is partially correct. The function does transfer Ether back to the sender before updating some state variables, which is a common pattern that can lead to reentrancy vulnerabilities. However, the function uses the 'balanceChanged' modifier, which might mitigate reentrancy risks if it properly handles state changes. The severity is moderate because reentrancy can lead to significant financial loss, but the presence of the modifier suggests some level of protection. The profitability is high for an attacker if the reentrancy is exploitable.",
        "correctness": 6,
        "severity": 6,
        "profitability": 7,
        "reason": "The function transfers Ether to the sender before updating the state variables, making it vulnerable to reentrancy attacks. An attacker could exploit this by recursively calling the function to drain the contract's funds before the state is updated.",
        "code": "function doInvest(address referrerAddr) public payable notFromContract balanceChanged { uint investment = msg.value; uint receivedEther = msg.value; require(investment >= minInvesment, \"investment must be >= minInvesment\"); require(address(this).balance <= maxBalance, \"the contract eth balance limit\"); if (m_rgp.isActive()) { uint rpgMaxInvest = m_rgp.maxInvestmentAtNow(); rpgMaxInvest.requireNotZero(); investment = Math.min(investment, rpgMaxInvest); assert(m_rgp.saveInvestment(investment)); emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay()); } else if (m_privEnter.isActive()) { uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender); peMaxInvest.requireNotZero(); investment = Math.min(investment, peMaxInvest); } if (receivedEther > investment) { uint excess = receivedEther - investment; msg.sender.transfer(excess); receivedEther = investment; emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess); } advertisingAddress.send(m_advertisingPercent.mul(receivedEther)); adminsAddress.send(m_adminsPercent.mul(receivedEther)); bool senderIsInvestor = m_investors.isInvestor(msg.sender); if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] && referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) { m_referrals[msg.sender] = true; uint referrerBonus = m_referrer_percent.mmul(investment); if (investment > 10 ether) { referrerBonus = m_referrer_percentMax.mmul(investment); } uint referalBonus = m_referal_percent.mmul(investment); assert(m_investors.addInvestment(referrerAddr, referrerBonus)); investment += referalBonus; emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus); } uint dividends = calcDividends(msg.sender); if (senderIsInvestor && dividends.notZero()) { investment += dividends; emit LogAutomaticReinvest(msg.sender, now, dividends); } if (senderIsInvestor) { assert(m_investors.addInvestment(msg.sender, investment)); assert(m_investors.setPaymentTime(msg.sender, now)); } else { assert(m_investors.newInvestor(msg.sender, investment, now)); emit LogNewInvestor(msg.sender, now); } investmentsNumber++; emit LogNewInvesment(msg.sender, now, investment, receivedEther); }",
        "file_name": "0x01fd49a2042e962eb9b4f7fa1efaa8eac4cefeed.sol",
        "final_score": 6.25
    },
    {
        "function_name": "disqalify",
        "vulnerability": "Lack of event logging",
        "criticism": "The reasoning is correct. The function modifies the state by setting an investor's investment to zero without emitting an event. This lack of transparency can lead to difficulties in tracking changes and could be exploited by the owner to disqualify investors without leaving a trace. The severity is low because it does not directly lead to financial loss, but it affects transparency. The profitability is low as it does not provide direct financial gain to an attacker.",
        "correctness": 8,
        "severity": 3,
        "profitability": 1,
        "reason": "The function modifies the state without emitting an event, which can lead to lack of transparency and difficulty in tracking changes to the contract state. In a real-world scenario, this might enable an owner to disqualify investors without leaving a trace in the event logs.",
        "code": "function disqalify(address addr) public onlyOwner returns (bool) { if (isInvestor(addr)) { investors[addr].investment = 0; } }",
        "file_name": "0x01fd49a2042e962eb9b4f7fa1efaa8eac4cefeed.sol",
        "final_score": 5.0
    }
]