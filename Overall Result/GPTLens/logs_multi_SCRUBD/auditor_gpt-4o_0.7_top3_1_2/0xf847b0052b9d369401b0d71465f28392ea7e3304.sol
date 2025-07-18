[
    {
        "function_name": "payReward",
        "code": "function payReward() internal { Investor memory investor; investor = investors[msg.sender]; if (investor.invested != 0) { uint getPay = investor.invested*DAY_PERC/100*(block.number-investor.lastBlockReward)/5900; uint sumPay = getPay.add(investor.paid); if (sumPay > investor.invested.mul(2)) { getPay = investor.invested.mul(2).sub(investor.paid); investor.paid = 0; investor.lastBlockReward = block.number; investor.invested = msg.value; }else{ investor.paid += getPay; investor.lastBlockReward = block.number; investor.invested += msg.value; } investors[msg.sender] = investor; if(address(this).balance < getPay){ getPay = address(this).balance; } msg.sender.transfer(getPay); } }",
        "vulnerability": "Reentrancy",
        "reason": "The function `payReward` transfers Ether to the `msg.sender` without updating the state first. This can allow a reentrancy attack where an attacker can repeatedly call the function to drain the contract's funds before their balance is updated.",
        "file_name": "0xf847b0052b9d369401b0d71465f28392ea7e3304.sol"
    },
    {
        "function_name": "payToMarketingReferral",
        "code": "function payToMarketingReferral() internal { address referral = investors[msg.sender].referral; if (referral == MARKETING) { MARKETING.send(msg.value / 10); }else{ MARKETING.send(msg.value / 20); referral.send(msg.value / 20); } }",
        "vulnerability": "Unsafe Ether Send",
        "reason": "The function uses `.send()` to transfer Ether which only forwards 2300 gas, possibly causing the send to fail if the recipient requires more gas. This can lead to locked funds or alter contract behavior unexpectedly if the transfer fails.",
        "file_name": "0xf847b0052b9d369401b0d71465f28392ea7e3304.sol"
    },
    {
        "function_name": "returnDeposit",
        "code": "function returnDeposit() internal { if (msg.value == RETURN_DEPOSIT){ Investor memory investor; investor = investors[msg.sender]; if (investor.invested != 0){ uint getPay = ((investor.invested.sub(investor.paid)).mul(RETURN_PERCENT).div(100)).sub(msg.value); msg.sender.transfer(getPay); investor.paid = 0; investor.invested = 0; investors[msg.sender] = investor; } } }",
        "vulnerability": "Incorrect Calculation Logic",
        "reason": "In `returnDeposit`, the calculation for `getPay` subtracts `msg.value` after calculating the percentage, which can lead to incorrect payouts, potentially allowing users to withdraw more than they should.",
        "file_name": "0xf847b0052b9d369401b0d71465f28392ea7e3304.sol"
    }
]