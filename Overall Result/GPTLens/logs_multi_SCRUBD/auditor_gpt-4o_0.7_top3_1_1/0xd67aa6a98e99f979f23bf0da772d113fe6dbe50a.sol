[
    {
        "function_name": "sendToBeneficiary",
        "code": "function sendToBeneficiary() public onlyOwner { if (beneficiary.send(amountRaised)) { amountRaised = 0; emit FundTransfer(beneficiary, amountRaised, false); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The sendToBeneficiary function uses the send method for transferring ether, which forwards 2300 gas and can lead to reentrancy attacks. If the beneficiary is a contract with a fallback function that calls back into sendToBeneficiary, it can potentially drain funds or cause inconsistent state changes before amountRaised is reset to 0.",
        "file_name": "0xd67aa6a98e99f979f23bf0da772d113fe6dbe50a.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function () public payable { require(!crowdsaleClosed); require(now <= deadline); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; allAmountRaised += amount; tokenReward.transfer(msg.sender, amount / price); emit FundTransfer(msg.sender, amount, true); if (amountRaised >= limitTransfer) { if (beneficiary.send(amountRaised)) { amountRaised = 0; emit FundTransfer(beneficiary, amountRaised, false); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "Similar to the sendToBeneficiary function, this fallback function uses the send method to transfer ether to the beneficiary. If the beneficiary is a contract with a fallback function that calls back into this function, it may lead to reentrancy attacks, allowing the attacker to manipulate the state before amountRaised is reset.",
        "file_name": "0xd67aa6a98e99f979f23bf0da772d113fe6dbe50a.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function () public payable { require(!crowdsaleClosed); require(now <= deadline); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; allAmountRaised += amount; tokenReward.transfer(msg.sender, amount / price); emit FundTransfer(msg.sender, amount, true); if (amountRaised >= limitTransfer) { if (beneficiary.send(amountRaised)) { amountRaised = 0; emit FundTransfer(beneficiary, amountRaised, false); } } }",
        "vulnerability": "Lack of validation for token transfer",
        "reason": "The contract does not check the return value of the tokenReward.transfer call. If the token transfer fails, the function will proceed as if it succeeded, which may lead to users believing they received tokens when they didn't. This could be exploited if the token contract is malicious or has bugs.",
        "file_name": "0xd67aa6a98e99f979f23bf0da772d113fe6dbe50a.sol"
    }
]