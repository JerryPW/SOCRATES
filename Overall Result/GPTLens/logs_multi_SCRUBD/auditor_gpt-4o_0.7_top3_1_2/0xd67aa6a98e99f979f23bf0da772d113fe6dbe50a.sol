[
    {
        "function_name": "sendToBeneficiary",
        "code": "function sendToBeneficiary() public onlyOwner { if (beneficiary.send(amountRaised)) { amountRaised = 0; emit FundTransfer(beneficiary, amountRaised, false); } }",
        "vulnerability": "potential_reentrancy",
        "reason": "The function sendToBeneficiary uses the send method to transfer ether to the beneficiary. This can lead to a reentrancy vulnerability because the beneficiary could be a contract that calls back into the Crowdsale contract before amountRaised is set to zero. This would allow the attacker to potentially withdraw funds multiple times, leading to a drain of the contract's balance.",
        "file_name": "0xd67aa6a98e99f979f23bf0da772d113fe6dbe50a.sol"
    },
    {
        "function_name": "fallback_function",
        "code": "function () public payable { require(!crowdsaleClosed); require(now <= deadline); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; allAmountRaised += amount; tokenReward.transfer(msg.sender, amount / price); emit FundTransfer(msg.sender, amount, true); if (amountRaised >= limitTransfer) { if (beneficiary.send(amountRaised)) { amountRaised = 0; emit FundTransfer(beneficiary, amountRaised, false); } } }",
        "vulnerability": "arithmetic_precision_issue",
        "reason": "The token transfer calculation amount / price may result in integer division truncation, where small contributions could result in zero tokens being transferred due to integer rounding. This is not immediately exploitable but could lead to unexpected loss of funds for contributors who receive fewer tokens than expected.",
        "file_name": "0xd67aa6a98e99f979f23bf0da772d113fe6dbe50a.sol"
    },
    {
        "function_name": "fallback_function",
        "code": "function () public payable { require(!crowdsaleClosed); require(now <= deadline); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; allAmountRaised += amount; tokenReward.transfer(msg.sender, amount / price); emit FundTransfer(msg.sender, amount, true); if (amountRaised >= limitTransfer) { if (beneficiary.send(amountRaised)) { amountRaised = 0; emit FundTransfer(beneficiary, amountRaised, false); } } }",
        "vulnerability": "gas_limit_and_send_failure",
        "reason": "The use of send within the fallback function to transfer ether to the beneficiary may fail if the gas cost exceeds the provided stipend. If the send operation fails, the amountRaised is not set to zero, which could leave the contract in a state where it cannot execute further operations until manually reset.",
        "file_name": "0xd67aa6a98e99f979f23bf0da772d113fe6dbe50a.sol"
    }
]