[
    {
        "function_name": "sendToBeneficiary",
        "code": "function sendToBeneficiary()public onlyOwner { if (beneficiary.send(amountRaised)) { amountRaised = 0; emit FundTransfer(beneficiary, amountRaised, false); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The use of 'send' to transfer Ether to the beneficiary allows for the possibility of a reentrancy attack. If the beneficiary is a contract with a fallback function, it can call back into the contract before amountRaised is reset to 0, allowing the attacker to potentially withdraw funds multiple times before the state is updated.",
        "file_name": "0xd67aa6a98e99f979f23bf0da772d113fe6dbe50a.sol"
    },
    {
        "function_name": "function (fallback function)",
        "code": "function () public payable { require(!crowdsaleClosed); require(now <= deadline); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; allAmountRaised += amount; tokenReward.transfer(msg.sender, amount / price); emit FundTransfer(msg.sender, amount, true); if (amountRaised >= limitTransfer) { if (beneficiary.send(amountRaised)) { amountRaised = 0; emit FundTransfer(beneficiary, amountRaised, false); } } }",
        "vulnerability": "Potential denial of service",
        "reason": "The fallback function uses 'send' to transfer Ether to the beneficiary when amountRaised exceeds limitTransfer. If the beneficiary is a contract that rejects the transfer or consumes more than 2300 gas in its fallback function, the send will fail, causing the function to revert and potentially lock funds in the contract indefinitely if the limit is constantly reached.",
        "file_name": "0xd67aa6a98e99f979f23bf0da772d113fe6dbe50a.sol"
    },
    {
        "function_name": "function (fallback function)",
        "code": "function () public payable { require(!crowdsaleClosed); require(now <= deadline); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; allAmountRaised += amount; tokenReward.transfer(msg.sender, amount / price); emit FundTransfer(msg.sender, amount, true); if (amountRaised >= limitTransfer) { if (beneficiary.send(amountRaised)) { amountRaised = 0; emit FundTransfer(beneficiary, amountRaised, false); } } }",
        "vulnerability": "Arithmetic precision error",
        "reason": "The conversion of Ether to tokens is done using integer division (amount / price), which can lead to precision errors. If the price doesn't perfectly divide the amount, the division will truncate the result, causing some Ether to not be converted into tokens, leading to potential loss of value for contributors.",
        "file_name": "0xd67aa6a98e99f979f23bf0da772d113fe6dbe50a.sol"
    }
]