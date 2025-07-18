[
    {
        "function_name": "payReward",
        "code": "function payReward() internal { Investor memory investor; investor = investors[msg.sender]; if (investor.invested != 0) { uint getPay = investor.invested*DAY_PERC/100*(block.number-investor.lastBlockReward)/5900; uint sumPay = getPay.add(investor.paid); if (sumPay > investor.invested.mul(2)) { getPay = investor.invested.mul(2).sub(investor.paid); investor.paid = 0; investor.lastBlockReward = block.number; investor.invested = msg.value; }else{ investor.paid += getPay; investor.lastBlockReward = block.number; investor.invested += msg.value; } investors[msg.sender] = investor; if(address(this).balance < getPay){ getPay = address(this).balance; } msg.sender.transfer(getPay); } }",
        "vulnerability": "Reentrancy",
        "reason": "The `payReward` function transfers Ether to the caller using `msg.sender.transfer(getPay)`, which forwards a limited amount of gas. However, despite the limited gas, the contract logic can still be exploited in scenarios where multiple calls manipulate state changes between the checks and updates. An attacker could potentially exploit this to repeatedly call `payReward` before the state is updated, allowing them to drain funds.",
        "file_name": "0xf847b0052b9d369401b0d71465f28392ea7e3304.sol"
    },
    {
        "function_name": "returnDeposit",
        "code": "function returnDeposit() internal { if (msg.value == RETURN_DEPOSIT){ Investor memory investor; investor = investors[msg.sender]; if (investor.invested != 0){ uint getPay = ((investor.invested.sub(investor.paid)).mul(RETURN_PERCENT).div(100)).sub(msg.value); msg.sender.transfer(getPay); investor.paid = 0; investor.invested = 0; investors[msg.sender] = investor; } } }",
        "vulnerability": "Incorrect Balance Calculation",
        "reason": "The `returnDeposit` function subtracts `msg.value` after calculating the payout amount. This may lead to incorrect refund amounts if the ether sent is not properly accounted for, allowing an attacker to manipulate the value returned by sending incorrect amounts of ether.",
        "file_name": "0xf847b0052b9d369401b0d71465f28392ea7e3304.sol"
    },
    {
        "function_name": "payToMarketingReferral",
        "code": "function payToMarketingReferral() internal { address referral = investors[msg.sender].referral; if (referral == MARKETING) { MARKETING.send(msg.value / 10); }else{ MARKETING.send(msg.value / 20); referral.send(msg.value / 20); } }",
        "vulnerability": "Unsafe Ether Transfer",
        "reason": "The `payToMarketingReferral` function uses `.send()` for transferring ether, which forwards a limited amount of gas and does not revert on failure. This can lead to situations where transfers fail silently. Additionally, it allows an attacker to potentially manipulate the referral structure to redirect rewards to an unintended address.",
        "file_name": "0xf847b0052b9d369401b0d71465f28392ea7e3304.sol"
    }
]