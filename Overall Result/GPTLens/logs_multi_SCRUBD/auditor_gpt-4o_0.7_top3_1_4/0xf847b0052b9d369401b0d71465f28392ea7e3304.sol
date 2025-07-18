[
    {
        "function_name": "payReward",
        "code": "function payReward() internal { Investor memory investor; investor = investors[msg.sender]; if (investor.invested != 0) { uint getPay = investor.invested*DAY_PERC/100*(block.number-investor.lastBlockReward)/5900; uint sumPay = getPay.add(investor.paid); if (sumPay > investor.invested.mul(2)) { getPay = investor.invested.mul(2).sub(investor.paid); investor.paid = 0; investor.lastBlockReward = block.number; investor.invested = msg.value; }else{ investor.paid += getPay; investor.lastBlockReward = block.number; investor.invested += msg.value; } investors[msg.sender] = investor; if(address(this).balance < getPay){ getPay = address(this).balance; } msg.sender.transfer(getPay); } }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The payReward function directly transfers funds to the msg.sender without updating the investor's state before the transfer. This allows for reentrancy attacks where an attacker can recursively call payReward, draining the contract. The balance update of the investor should occur before the transfer to mitigate this risk.",
        "file_name": "0xf847b0052b9d369401b0d71465f28392ea7e3304.sol"
    },
    {
        "function_name": "payToMarketingReferral",
        "code": "function payToMarketingReferral() internal { address referral = investors[msg.sender].referral; if (referral == MARKETING) { MARKETING.send(msg.value / 10); }else{ MARKETING.send(msg.value / 20); referral.send(msg.value / 20); } }",
        "vulnerability": "Use of send() Function",
        "reason": "The payToMarketingReferral function uses the send() function for Ether transfers, which can fail silently if the recipient is a contract that does not implement a fallback function. This can result in unexpected behavior and potential loss of funds. Consider using transfer() or call() with proper checks to ensure the transfer succeeds.",
        "file_name": "0xf847b0052b9d369401b0d71465f28392ea7e3304.sol"
    },
    {
        "function_name": "returnDeposit",
        "code": "function returnDeposit() internal { if (msg.value == RETURN_DEPOSIT){ Investor memory investor; investor = investors[msg.sender]; if (investor.invested != 0){ uint getPay = ((investor.invested.sub(investor.paid)).mul(RETURN_PERCENT).div(100)).sub(msg.value); msg.sender.transfer(getPay); investor.paid = 0; investor.invested = 0; investors[msg.sender] = investor; } } }",
        "vulnerability": "Incorrect Calculation of Return",
        "reason": "In the returnDeposit function, the calculation of getPay subtracts msg.value from the computed return, potentially resulting in incorrect payout amounts. If msg.value is greater than the computed return, this could lead to paying out less than intended or even zero. Proper checks and calculations should be implemented to ensure correct payouts.",
        "file_name": "0xf847b0052b9d369401b0d71465f28392ea7e3304.sol"
    }
]