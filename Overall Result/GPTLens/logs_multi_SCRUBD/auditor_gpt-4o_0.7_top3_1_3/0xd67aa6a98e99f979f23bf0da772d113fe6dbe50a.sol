[
    {
        "function_name": "sendToBeneficiary",
        "code": "function sendToBeneficiary() public onlyOwner { if (beneficiary.send(amountRaised)) { amountRaised = 0; emit FundTransfer(beneficiary, amountRaised, false); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The sendToBeneficiary function uses 'beneficiary.send()', which is vulnerable to reentrancy attacks. An attacker can exploit this by recursively calling this function before the 'amountRaised' is set to 0, potentially draining the contract's funds.",
        "file_name": "0xd67aa6a98e99f979f23bf0da772d113fe6dbe50a.sol"
    },
    {
        "function_name": "function ()",
        "code": "function () public payable { require(!crowdsaleClosed); require(now <= deadline); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; allAmountRaised += amount; tokenReward.transfer(msg.sender, amount / price); emit FundTransfer(msg.sender, amount, true); if (amountRaised >= limitTransfer) { if (beneficiary.send(amountRaised)) { amountRaised = 0; emit FundTransfer(beneficiary, amountRaised, false); } } }",
        "vulnerability": "Reentrancy in fallback function",
        "reason": "The fallback function also has a similar reentrancy issue due to the use of 'beneficiary.send(amountRaised)'. An attacker can exploit this by sending ether multiple times in quick succession, causing the function to be re-entered before 'amountRaised' is reset.",
        "file_name": "0xd67aa6a98e99f979f23bf0da772d113fe6dbe50a.sol"
    },
    {
        "function_name": "changeDeadline",
        "code": "function changeDeadline(uint durationInMinutes) public onlyOwner { crowdsaleClosed = false; deadline = now + durationInMinutes * 1 minutes; }",
        "vulnerability": "Arbitrary deadline extension",
        "reason": "The changeDeadline function allows the owner to arbitrarily extend the crowdsale duration, which could be used to manipulate the crowdsale process and is unfair to contributors who may expect the crowdsale to end at a specific time.",
        "file_name": "0xd67aa6a98e99f979f23bf0da772d113fe6dbe50a.sol"
    }
]