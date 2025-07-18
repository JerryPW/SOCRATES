[
    {
        "function_name": "withdrawBody",
        "code": "function withdrawBody(address addr, uint limit) public onlyOwner returns (uint) { Investment[] investments = investors[addr].investments; uint valueToWithdraw = 0; for (uint i = 0; i < investments.length; i++) { if (!investments[i].partiallyWithdrawn && investments[i].date <= now - 30 days && valueToWithdraw + investments[i].value/2 <= limit) { investments[i].partiallyWithdrawn = true; valueToWithdraw += investments[i].value/2; investors[addr].overallInvestment -= investments[i].value/2; } if (!investments[i].fullyWithdrawn && investments[i].date <= now - 60 days && valueToWithdraw + investments[i].value/2 <= limit) { investments[i].fullyWithdrawn = true; valueToWithdraw += investments[i].value/2; investors[addr].overallInvestment -= investments[i].value/2; } return valueToWithdraw; } return valueToWithdraw; }",
        "vulnerability": "Immediate Return in Loop",
        "reason": "The function immediately returns after processing the first investment due to the misplaced return statement inside the loop. This prevents the function from processing multiple investments for partial or full withdrawals, which can be exploited for incorrect withdrawal logic.",
        "file_name": "0x04d660832910ff492e940daff9ec7b3497e886ac.sol"
    },
    {
        "function_name": "doInvest",
        "code": "function doInvest(address referrerAddr) public payable notFromContract balanceChanged { uint investment = msg.value; uint receivedEther = msg.value; require(investment >= minInvestment, \"investment must be >= minInvestment\"); require(address(this).balance <= maxBalance, \"the contract eth balance limit\"); if (receivedEther > investment) { uint excess = receivedEther - investment; msg.sender.transfer(excess); receivedEther = investment; emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess); } advertisingAddress.send(m_advertisingPercent.mul(receivedEther)); adminsAddress.send(m_adminsPercent.mul(receivedEther)); bool senderIsInvestor = m_investors.isInvestor(msg.sender); if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] && referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) { m_referrals[msg.sender] = true; uint referrerBonus = m_referrer_percent.mmul(investment); uint referalBonus = m_referal_percent.mmul(investment); assert(m_investors.addInvestment(referrerAddr, referrerBonus)); investment += referalBonus; emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus); } uint dividends = calcDividends(msg.sender); if (senderIsInvestor && dividends.notZero()) { investment += dividends; emit LogAutomaticReinvest(msg.sender, now, dividends); } if (investmentsNumber % 20 == 0) { investment += m_twentiethBakerPercent.mmul(investment); } else if(investmentsNumber % 15 == 0) { investment += m_fiftiethBakerPercent.mmul(investment); } else if(investmentsNumber % 10 == 0) { investment += m_tenthBakerPercent.mmul(investment); } if (senderIsInvestor) { assert(m_investors.addInvestment(msg.sender, investment)); assert(m_investors.setPaymentTime(msg.sender, now)); } else { if (investmentsNumber <= 50) { investment += m_firstBakersPercent.mmul(investment); } assert(m_investors.newInvestor(msg.sender, investment, now)); emit LogNewInvestor(msg.sender, now); } investmentsNumber++; emit LogNewInvestment(msg.sender, now, investment, receivedEther); }",
        "vulnerability": "Unsafe Ether Transfer",
        "reason": "The function uses send() for transferring Ether which can fail silently without reverting the transaction. This is unsafe as it does not handle errors properly and could lead to Ether being stuck if the recipient is a contract with a failing fallback function.",
        "file_name": "0x04d660832910ff492e940daff9ec7b3497e886ac.sol"
    },
    {
        "function_name": "testWithdraw",
        "code": "function testWithdraw(address addr) public onlyOwner { addr.transfer(address(this).balance); }",
        "vulnerability": "Owner can drain contract",
        "reason": "This function allows the contract owner to withdraw the entire balance of the contract to any address they specify without any restrictions. This is a critical vulnerability as it allows the owner to potentially steal all funds from the contract.",
        "file_name": "0x04d660832910ff492e940daff9ec7b3497e886ac.sol"
    }
]