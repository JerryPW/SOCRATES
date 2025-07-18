[
    {
        "function_name": "function () payable",
        "code": "function () payable public{ require(!crowdsaleClosed); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; tokenReward.transfer(msg.sender, amount*10000); FundTransfer(msg.sender, amount, true); if(beneficiary.send(amount)) { FundTransfer(beneficiary, amount, false); } else { amountLeft += amountLeft; } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function sends ether to the beneficiary using the send() function, which is unsafe without proper checks. This can be exploited by a reentrancy attack, where an attacker can reenter the contract and perform operations before the state is updated. The lack of updating the state before external calls (e.g., amountLeft) makes it susceptible.",
        "file_name": "0xc67c1f88f31e724b137a057292e55cb42a5f3241.sol"
    },
    {
        "function_name": "function () payable",
        "code": "function () payable public{ require(!crowdsaleClosed); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; tokenReward.transfer(msg.sender, amount*10000); FundTransfer(msg.sender, amount, true); if(beneficiary.send(amount)) { FundTransfer(beneficiary, amount, false); } else { amountLeft += amountLeft; } }",
        "vulnerability": "Arithmetic vulnerability",
        "reason": "The line 'amountLeft += amountLeft;' in the fallback function attempts to increment amountLeft by itself, which results in a logical error. This leads to incorrect state updates and potential integer overflow, which could be exploited by attackers to manipulate the amountLeft variable.",
        "file_name": "0xc67c1f88f31e724b137a057292e55cb42a5f3241.sol"
    },
    {
        "function_name": "function safeWithdrawal()",
        "code": "function safeWithdrawal() afterDeadline public{ if (beneficiary == msg.sender&& amountLeft > 0) { if (beneficiary.send(amountLeft)) { FundTransfer(beneficiary, amountLeft, false); } else { } } }",
        "vulnerability": "Inadequate access control",
        "reason": "The safeWithdrawal function allows the beneficiary to withdraw the entire amountLeft after the deadline. However, it does not provide a mechanism for contributors to withdraw their funds if the goal is not met. This lack of access control and refund mechanism can lead to a situation where the funds are locked, and contributors cannot retrieve their contributions.",
        "file_name": "0xc67c1f88f31e724b137a057292e55cb42a5f3241.sol"
    }
]