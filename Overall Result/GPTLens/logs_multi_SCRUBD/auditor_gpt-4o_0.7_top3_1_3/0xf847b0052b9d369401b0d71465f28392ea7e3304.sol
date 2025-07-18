[
    {
        "function_name": "payReward",
        "code": "function payReward() internal { Investor memory investor; investor = investors[msg.sender]; if (investor.invested != 0) { uint getPay = investor.invested*DAY_PERC/100*(block.number-investor.lastBlockReward)/5900; uint sumPay = getPay.add(investor.paid); if (sumPay > investor.invested.mul(2)) { getPay = investor.invested.mul(2).sub(investor.paid); investor.paid = 0; investor.lastBlockReward = block.number; investor.invested = msg.value; }else{ investor.paid += getPay; investor.lastBlockReward = block.number; investor.invested += msg.value; } investors[msg.sender] = investor; if(address(this).balance < getPay){ getPay = address(this).balance; } msg.sender.transfer(getPay); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function transfers Ether to the caller before updating the investor state. This allows an attacker to call the function again in a fallback function, potentially draining the contract balance or manipulating internal state.",
        "file_name": "0xf847b0052b9d369401b0d71465f28392ea7e3304.sol"
    },
    {
        "function_name": "returnDeposit",
        "code": "function returnDeposit() internal { if (msg.value == RETURN_DEPOSIT){ Investor memory investor; investor = investors[msg.sender]; if (investor.invested != 0){ uint getPay = ((investor.invested.sub(investor.paid)).mul(RETURN_PERCENT).div(100)).sub(msg.value); msg.sender.transfer(getPay); investor.paid = 0; investor.invested = 0; investors[msg.sender] = investor; } } }",
        "vulnerability": "Potentially incorrect payout calculation",
        "reason": "The payout calculation in 'returnDeposit' may result in incorrect or negative values due to the subtraction of 'msg.value'. If 'msg.value' is greater than the payout, it could lead to an unexpected transfer or revert.",
        "file_name": "0xf847b0052b9d369401b0d71465f28392ea7e3304.sol"
    },
    {
        "function_name": "payToMarketingReferral",
        "code": "function payToMarketingReferral() internal { address referral = investors[msg.sender].referral; if (referral == MARKETING) { MARKETING.send(msg.value / 10); }else{ MARKETING.send(msg.value / 20); referral.send(msg.value / 20); } }",
        "vulnerability": "Usage of send for Ether transfer",
        "reason": "The use of 'send' for transferring Ether is unsafe because it fails silently on error, potentially leaving the contract with unintentional states. Additionally, it only forwards 2300 gas, which might not be enough for complex fallback functions.",
        "file_name": "0xf847b0052b9d369401b0d71465f28392ea7e3304.sol"
    }
]