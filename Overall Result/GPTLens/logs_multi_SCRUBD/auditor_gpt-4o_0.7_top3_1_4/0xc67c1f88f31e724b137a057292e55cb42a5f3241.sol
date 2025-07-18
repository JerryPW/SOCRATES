[
    {
        "function_name": "function()",
        "code": "function () payable public{ require(!crowdsaleClosed); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; tokenReward.transfer(msg.sender, amount*10000); FundTransfer(msg.sender, amount, true); if(beneficiary.send(amount)) { FundTransfer(beneficiary, amount, false); } else { amountLeft += amountLeft; } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function sends Ether to the beneficiary using the 'send' method, which can fail and does not properly handle the failure case. Moreover, the state changes occur after the external call, making the contract susceptible to reentrancy attacks, especially if the beneficiary is a contract with a fallback function that could re-enter the contract.",
        "file_name": "0xc67c1f88f31e724b137a057292e55cb42a5f3241.sol"
    },
    {
        "function_name": "function()",
        "code": "function () payable public{ require(!crowdsaleClosed); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; tokenReward.transfer(msg.sender, amount*10000); FundTransfer(msg.sender, amount, true); if(beneficiary.send(amount)) { FundTransfer(beneficiary, amount, false); } else { amountLeft += amountLeft; } }",
        "vulnerability": "Integer overflow on amountLeft",
        "reason": "In the fallback function, the line 'amountLeft += amountLeft;' is meant to update the amountLeft if the transfer to the beneficiary fails. This line will double the value of amountLeft instead of adding the value of 'amount'. This can lead to an integer overflow, making amountLeft incorrect and potentially very large.",
        "file_name": "0xc67c1f88f31e724b137a057292e55cb42a5f3241.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline public{ if (beneficiary == msg.sender&& amountLeft > 0) { if (beneficiary.send(amountLeft)) { FundTransfer(beneficiary, amountLeft, false); } else { } } }",
        "vulnerability": "Improper handling of failed transfer",
        "reason": "The function 'safeWithdrawal' uses 'send' to transfer Ether to the beneficiary, which can fail and doesn't handle the failure case properly. If 'send' fails, the function does nothing, potentially leaving the funds locked in the contract. This can be exploited to prevent the withdrawal of funds if an attacker can influence the failure of the send operation.",
        "file_name": "0xc67c1f88f31e724b137a057292e55cb42a5f3241.sol"
    }
]