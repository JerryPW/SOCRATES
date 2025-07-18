[
    {
        "function_name": "payReward",
        "code": "function payReward() internal { Investor memory investor; investor = investors[msg.sender]; if (investor.invested != 0) { uint getPay = investor.invested*DAY_PERC/100*(block.number-investor.lastBlockReward)/5900; uint sumPay = getPay.add(investor.paid); if (sumPay > investor.invested.mul(2)) { getPay = investor.invested.mul(2).sub(investor.paid); investor.paid = 0; investor.lastBlockReward = block.number; investor.invested = msg.value; }else{ investor.paid += getPay; investor.lastBlockReward = block.number; investor.invested += msg.value; } investors[msg.sender] = investor; if(address(this).balance < getPay){ getPay = address(this).balance; } msg.sender.transfer(getPay); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function executes an external call to msg.sender.transfer(getPay) before updating the Investor's state variables in storage, specifically the 'investors' mapping. This can allow an attacker to repeatedly call payReward and drain the contract's balance before the state variables are updated, resulting in a reentrancy attack.",
        "file_name": "0xf847b0052b9d369401b0d71465f28392ea7e3304.sol"
    },
    {
        "function_name": "payToMarketingReferral",
        "code": "function payToMarketingReferral() internal { address referral = investors[msg.sender].referral; if (referral == MARKETING) { MARKETING.send(msg.value / 10); }else{ MARKETING.send(msg.value / 20); referral.send(msg.value / 20); } }",
        "vulnerability": "Unsafe use of send",
        "reason": "The use of the send function is unsafe because it does not throw an exception on failure and only forwards a limited amount of gas. If the send fails, it is not handled, which could lead to unexpected scenarios where funds are not properly transferred to the designated addresses. This can potentially result in the loss of funds intended for marketing or referrals.",
        "file_name": "0xf847b0052b9d369401b0d71465f28392ea7e3304.sol"
    },
    {
        "function_name": "bytesToAddress",
        "code": "function bytesToAddress(bytes _b) private pure returns (address addr) { assembly { addr := mload(add(_b, 20)) } }",
        "vulnerability": "Unsafe type conversion",
        "reason": "The function directly converts bytes to an address using inline assembly, which is unsafe because it can lead to unexpected behavior if the input bytes are not properly validated. This could allow an attacker to manipulate input data to create a valid address leading to unexpected behavior or vulnerabilities.",
        "file_name": "0xf847b0052b9d369401b0d71465f28392ea7e3304.sol"
    }
]