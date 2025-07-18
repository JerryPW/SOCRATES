[
    {
        "function_name": "function () payable",
        "code": "function () payable public{ require(!crowdsaleClosed); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; tokenReward.transfer(msg.sender, amount*10000); FundTransfer(msg.sender, amount, true); if(beneficiary.send(amount)) { FundTransfer(beneficiary, amount, false); } else { amountLeft += amountLeft; } }",
        "vulnerability": "Reentrancy via fallback function",
        "reason": "The fallback function allows Ether transfers to the 'beneficiary' without using the checks-effects-interactions pattern. If 'beneficiary' is a contract, it could re-enter the fallback function before the state variables are updated, potentially leading to multiple token rewards being issued for a single transaction.",
        "file_name": "0xc67c1f88f31e724b137a057292e55cb42a5f3241.sol"
    },
    {
        "function_name": "function () payable",
        "code": "function () payable public{ require(!crowdsaleClosed); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; tokenReward.transfer(msg.sender, amount*10000); FundTransfer(msg.sender, amount, true); if(beneficiary.send(amount)) { FundTransfer(beneficiary, amount, false); } else { amountLeft += amountLeft; } }",
        "vulnerability": "Integer overflow on 'amountLeft'",
        "reason": "In the fallback function, if sending Ether to the 'beneficiary' fails, the code attempts to update 'amountLeft' using 'amountLeft += amountLeft', which is incorrect and will result in an integer overflow, potentially resetting 'amountLeft' to zero.",
        "file_name": "0xc67c1f88f31e724b137a057292e55cb42a5f3241.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline public{ if (beneficiary == msg.sender&& amountLeft > 0) { if (beneficiary.send(amountLeft)) { FundTransfer(beneficiary, amountLeft, false); } else { } } }",
        "vulnerability": "Lack of withdrawal mechanism for non-beneficiary users",
        "reason": "The 'safeWithdrawal' function only allows the beneficiary to withdraw 'amountLeft'. There is no mechanism for individual contributors to withdraw their funds if the crowdsale fails to meet its goal.",
        "file_name": "0xc67c1f88f31e724b137a057292e55cb42a5f3241.sol"
    }
]