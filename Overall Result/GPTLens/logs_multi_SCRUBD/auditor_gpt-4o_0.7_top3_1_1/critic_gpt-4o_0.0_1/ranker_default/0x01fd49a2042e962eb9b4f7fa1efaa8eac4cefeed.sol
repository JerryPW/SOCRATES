[
    {
        "function_name": "nextWave",
        "vulnerability": "State reset without checks",
        "criticism": "The reasoning is correct in identifying that the 'nextWave' function resets critical state variables without any checks. This can lead to a loss of historical data and disrupt the contract's normal operation if called unexpectedly or maliciously. The severity is high because it can cause significant disruption and data loss. The profitability is moderate because an attacker could potentially exploit this to disrupt the contract's operation, although direct financial gain is not guaranteed.",
        "correctness": 9,
        "severity": 8,
        "profitability": 4,
        "reason": "The 'nextWave' function resets the contract's state by creating a new 'InvestorsStorage' and resetting 'investmentsNumber'. If this function is called unexpectedly or maliciously, it can cause loss of data, including historical investor records, and disrupt the normal operation of the contract. No checks ensure the conditions under which this function should be called, making it possible to reset the state arbitrarily.",
        "code": "function nextWave() private { m_investors = new InvestorsStorage(); investmentsNumber = 0; waveStartup = now; m_rgp.startAt(now); emit LogRGPInit(now , m_rgp.startTimestamp, m_rgp.maxDailyTotalInvestment, m_rgp.activityDays); emit LogNextWave(now); }",
        "file_name": "0x01fd49a2042e962eb9b4f7fa1efaa8eac4cefeed.sol",
        "final_score": 7.5
    },
    {
        "function_name": "doInvest",
        "vulnerability": "Insecure use of 'send'",
        "criticism": "The reasoning is correct that using 'send' can lead to failed transactions if the recipient address requires more than 2300 gas. This can indeed cause a denial of service or leave the contract in an inconsistent state if not handled properly. The severity is moderate because it can disrupt the contract's operation, but it does not directly lead to a loss of funds. The profitability is low because an attacker cannot directly profit from this vulnerability, but it could be used to disrupt the contract's functionality.",
        "correctness": 9,
        "severity": 6,
        "profitability": 2,
        "reason": "The 'doInvest' function uses 'send' to transfer Ether to 'advertisingAddress' and 'adminsAddress'. This is not a secure practice as 'send' only forwards 2300 gas, which can lead to failed transactions if the recipient address requires more gas for execution. If the transfer fails, it can leave the contract in an inconsistent state or cause denial of service.",
        "code": "function doInvest(address referrerAddr) public payable notFromContract balanceChanged { uint investment = msg.value; uint receivedEther = msg.value; require(investment >= minInvesment, \"investment must be >= minInvesment\"); require(address(this).balance <= maxBalance, \"the contract eth balance limit\"); if (m_rgp.isActive()) { uint rpgMaxInvest = m_rgp.maxInvestmentAtNow(); rpgMaxInvest.requireNotZero(); investment = Math.min(investment, rpgMaxInvest); assert(m_rgp.saveInvestment(investment)); emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay()); } else if (m_privEnter.isActive()) { uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender); peMaxInvest.requireNotZero(); investment = Math.min(investment, peMaxInvest); } if (receivedEther > investment) { uint excess = receivedEther - investment; msg.sender.transfer(excess); receivedEther = investment; emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess); } advertisingAddress.send(m_advertisingPercent.mul(receivedEther)); adminsAddress.send(m_adminsPercent.mul(receivedEther)); bool senderIsInvestor = m_investors.isInvestor(msg.sender); if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] && referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) { m_referrals[msg.sender] = true; uint referrerBonus = m_referrer_percent.mmul(investment); if (investment > 10 ether) { referrerBonus = m_referrer_percentMax.mmul(investment); } uint referalBonus = m_referal_percent.mmul(investment); assert(m_investors.addInvestment(referrerAddr, referrerBonus)); investment += referalBonus; emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus); } uint dividends = calcDividends(msg.sender); if (senderIsInvestor && dividends.notZero()) { investment += dividends; emit LogAutomaticReinvest(msg.sender, now, dividends); } if (senderIsInvestor) { assert(m_investors.addInvestment(msg.sender, investment)); assert(m_investors.setPaymentTime(msg.sender, now)); } else { assert(m_investors.newInvestor(msg.sender, investment, now)); emit LogNewInvestor(msg.sender, now); } investmentsNumber++; emit LogNewInvesment(msg.sender, now, investment, receivedEther); }",
        "file_name": "0x01fd49a2042e962eb9b4f7fa1efaa8eac4cefeed.sol",
        "final_score": 6.5
    },
    {
        "function_name": "disqalify",
        "vulnerability": "Does not reset paymentTime",
        "criticism": "The reasoning is correct in identifying that the 'disqalify' function does not reset the 'paymentTime'. This could indeed lead to logical errors, as the investor's status might not be accurately reflected, potentially allowing them to bypass certain checks. However, the severity of this issue depends on how 'paymentTime' is used elsewhere in the contract. If it is crucial for determining eligibility for dividends or other benefits, the severity could be moderate. The profitability is low because an external attacker cannot directly exploit this for financial gain.",
        "correctness": 8,
        "severity": 5,
        "profitability": 1,
        "reason": "The 'disqalify' function sets the investment balance to zero but does not reset the 'paymentTime'. This could lead to logical errors in the contract when calculating dividends or determining the status of an investor, as the 'paymentTime' will still indicate that the investor has been active, potentially allowing them to bypass certain checks.",
        "code": "function disqalify(address addr) public onlyOwner returns (bool) { if (isInvestor(addr)) { investors[addr].investment = 0; } }",
        "file_name": "0x01fd49a2042e962eb9b4f7fa1efaa8eac4cefeed.sol",
        "final_score": 5.5
    }
]