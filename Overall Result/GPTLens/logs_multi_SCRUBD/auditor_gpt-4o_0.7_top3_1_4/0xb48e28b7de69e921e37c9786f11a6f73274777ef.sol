[
    {
        "function_name": "function ()",
        "code": "function () payable { require(!crowdsaleClosed); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; tokenReward.transfer(msg.sender, amount / price); beneficiary.send(amountRaised); amountRaised = 0; FundTransfer(msg.sender, amount, true); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function sends ether to the beneficiary using 'beneficiary.send(amountRaised);' before updating 'amountRaised' to zero. If the beneficiary is a contract, it could re-enter this function before 'amountRaised' is reset, leading to potential theft of funds.",
        "file_name": "0xb48e28b7de69e921e37c9786f11a6f73274777ef.sol"
    },
    {
        "function_name": "function ()",
        "code": "function () payable { require(!crowdsaleClosed); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; tokenReward.transfer(msg.sender, amount / price); beneficiary.send(amountRaised); amountRaised = 0; FundTransfer(msg.sender, amount, true); }",
        "vulnerability": "Incorrect token reward calculation",
        "reason": "The token reward calculation 'amount / price' uses integer division, which could lead to incorrect rounding and an unfair distribution of tokens to contributors, especially for small contributions. This could be exploited to receive fewer tokens than expected.",
        "file_name": "0xb48e28b7de69e921e37c9786f11a6f73274777ef.sol"
    },
    {
        "function_name": "function ()",
        "code": "function () payable { require(!crowdsaleClosed); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; tokenReward.transfer(msg.sender, amount / price); beneficiary.send(amountRaised); amountRaised = 0; FundTransfer(msg.sender, amount, true); }",
        "vulnerability": "Immediate fund transfer to beneficiary",
        "reason": "Transferring the entire 'amountRaised' to the beneficiary immediately after each contribution means that if the funding goal is not reached, refunding contributors becomes impossible because the contract does not hold the funds anymore. This could lead to loss of all contributions if the funding goal is not met.",
        "file_name": "0xb48e28b7de69e921e37c9786f11a6f73274777ef.sol"
    }
]