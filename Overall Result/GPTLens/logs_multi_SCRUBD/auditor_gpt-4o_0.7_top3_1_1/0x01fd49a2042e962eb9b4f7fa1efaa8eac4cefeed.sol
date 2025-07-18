[
    {
        "function_name": "disqalify",
        "code": "function disqalify(address addr) public onlyOwner returns (bool) { if (isInvestor(addr)) { investors[addr].investment = 0; } }",
        "vulnerability": "Function does not reset paymentTime",
        "reason": "The 'disqalify' function sets the investment balance to zero but does not reset the 'paymentTime'. This could lead to logical errors in the contract when calculating dividends or determining the status of an investor, as the 'paymentTime' will still indicate that the investor has been active, potentially allowing them to bypass certain checks.",
        "file_name": "0x01fd49a2042e962eb9b4f7fa1efaa8eac4cefeed.sol"
    },
    {
        "function_name": "doInvest",
        "code": "function doInvest(address referrerAddr) public payable notFromContract balanceChanged { uint investment = msg.value; uint receivedEther = msg.value; require(investment >= minInvesment, \"investment must be >= minInvesment\"); require(address(this).balance <= maxBalance, \"the contract eth balance limit\"); if (m_rgp.isActive()) { uint rpgMaxInvest = m_rgp.maxInvestmentAtNow(); rpgMaxInvest.requireNotZero(); investment = Math.min(investment, rpgMaxInvest); assert(m_rgp.saveInvestment(investment)); emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay()); } else if (m_privEnter.isActive()) { uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender); peMaxInvest.requireNotZero(); investment = Math.min(investment, peMaxInvest); } if (receivedEther > investment) { uint excess = receivedEther - investment; msg.sender.transfer(excess); receivedEther = investment; emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess); } advertisingAddress.send(m_advertisingPercent.mul(receivedEther)); adminsAddress.send(m_adminsPercent.mul(receivedEther)); bool senderIsInvestor = m_investors.isInvestor(msg.sender); if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] && referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) { m_referrals[msg.sender] = true; uint referrerBonus = m_referrer_percent.mmul(investment); if (investment > 10 ether) { referrerBonus = m_referrer_percentMax.mmul(investment); } uint referalBonus = m_referal_percent.mmul(investment); assert(m_investors.addInvestment(referrerAddr, referrerBonus)); investment += referalBonus; emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus); } uint dividends = calcDividends(msg.sender); if (senderIsInvestor && dividends.notZero()) { investment += dividends; emit LogAutomaticReinvest(msg.sender, now, dividends); } if (senderIsInvestor) { assert(m_investors.addInvestment(msg.sender, investment)); assert(m_investors.setPaymentTime(msg.sender, now)); } else { assert(m_investors.newInvestor(msg.sender, investment, now)); emit LogNewInvestor(msg.sender, now); } investmentsNumber++; emit LogNewInvesment(msg.sender, now, investment, receivedEther); }",
        "vulnerability": "Insecure use of 'send' for transferring Ether",
        "reason": "The 'doInvest' function uses 'send' to transfer Ether to 'advertisingAddress' and 'adminsAddress'. This is not a secure practice as 'send' only forwards 2300 gas, which can lead to failed transactions if the recipient address requires more gas for execution. If the transfer fails, it can leave the contract in an inconsistent state or cause denial of service.",
        "file_name": "0x01fd49a2042e962eb9b4f7fa1efaa8eac4cefeed.sol"
    },
    {
        "function_name": "nextWave",
        "code": "function nextWave() private { m_investors = new InvestorsStorage(); investmentsNumber = 0; waveStartup = now; m_rgp.startAt(now); emit LogRGPInit(now , m_rgp.startTimestamp, m_rgp.maxDailyTotalInvestment, m_rgp.activityDays); emit LogNextWave(now); }",
        "vulnerability": "Resetting state without proper checks",
        "reason": "The 'nextWave' function resets the contract's state by creating a new 'InvestorsStorage' and resetting 'investmentsNumber'. If this function is called unexpectedly or maliciously, it can cause loss of data, including historical investor records, and disrupt the normal operation of the contract. No checks ensure the conditions under which this function should be called, making it possible to reset the state arbitrarily.",
        "file_name": "0x01fd49a2042e962eb9b4f7fa1efaa8eac4cefeed.sol"
    }
]