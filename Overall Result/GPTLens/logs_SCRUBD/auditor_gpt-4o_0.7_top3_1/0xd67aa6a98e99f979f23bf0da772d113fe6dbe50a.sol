[
    {
        "function_name": "sendToBeneficiary",
        "code": "function sendToBeneficiary() public onlyOwner { if (beneficiary.send(amountRaised)) { amountRaised = 0; emit FundTransfer(beneficiary, amountRaised, false); } }",
        "vulnerability": "Potential Reentrancy Attack",
        "reason": "The function uses the send method to transfer Ether, which forwards a limited amount of gas and does not prevent reentrancy attacks. If the beneficiary is a contract with a fallback function, it can reenter the contract before the amountRaised is reset to zero, potentially allowing for multiple withdrawals.",
        "file_name": "0xd67aa6a98e99f979f23bf0da772d113fe6dbe50a.sol"
    },
    {
        "function_name": "function (fallback function)",
        "code": "function () public payable { require(!crowdsaleClosed); require(now <= deadline); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; allAmountRaised += amount; tokenReward.transfer(msg.sender, amount / price); emit FundTransfer(msg.sender, amount, true); if (amountRaised >= limitTransfer) { if (beneficiary.send(amountRaised)) { amountRaised = 0; emit FundTransfer(beneficiary, amountRaised, false); } } }",
        "vulnerability": "Lack of SafeMath Usage",
        "reason": "Arithmetic operations such as addition and division are performed without checking for overflow or division by zero, which can lead to incorrect calculations and potential vulnerabilities. Specifically, calculations involving amountRaised, balanceOf, and token transfers are vulnerable.",
        "file_name": "0xd67aa6a98e99f979f23bf0da772d113fe6dbe50a.sol"
    },
    {
        "function_name": "changeDeadline",
        "code": "function changeDeadline(uint durationInMinutes) public onlyOwner { crowdsaleClosed = false; deadline = now + durationInMinutes * 1 minutes; }",
        "vulnerability": "Arbitrary Deadline Extension",
        "reason": "The owner can arbitrarily extend the deadline of the crowdsale, which can be used maliciously to keep the crowdsale open indefinitely, preventing contributors from potentially withdrawing their funds if they expected the crowdsale to close at a certain time.",
        "file_name": "0xd67aa6a98e99f979f23bf0da772d113fe6dbe50a.sol"
    }
]