[
    {
        "function_name": "function()",
        "code": "function () payable public{ require(!crowdsaleClosed); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; tokenReward.transfer(msg.sender, amount*10000); FundTransfer(msg.sender, amount, true); if(beneficiary.send(amount)) { FundTransfer(beneficiary, amount, false); } else { amountLeft += amountLeft; } }",
        "vulnerability": "Reentrancy",
        "reason": "The fallback function directly sends Ether to the beneficiary using `beneficiary.send(amount)` before updating the `amountLeft`. This exposes the contract to reentrancy attacks where an attacker could recursively call the fallback function to drain funds. This is because the state changes are not made before sending Ether, allowing for reentrancy before the state is updated.",
        "file_name": "0xc67c1f88f31e724b137a057292e55cb42a5f3241.sol"
    },
    {
        "function_name": "function()",
        "code": "function () payable public{ require(!crowdsaleClosed); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; tokenReward.transfer(msg.sender, amount*10000); FundTransfer(msg.sender, amount, true); if(beneficiary.send(amount)) { FundTransfer(beneficiary, amount, false); } else { amountLeft += amountLeft; } }",
        "vulnerability": "Token Amount Mismatch",
        "reason": "The function transfers `amount * 10000` tokens to the sender regardless of the token's decimal places or price. This could lead to an incorrect number of tokens being sent if the token's decimals are not 18, or if the rate is not exactly 10000 tokens per Ether. This could be exploited by attackers to receive more tokens than they should.",
        "file_name": "0xc67c1f88f31e724b137a057292e55cb42a5f3241.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline public{ if (beneficiary == msg.sender&& amountLeft > 0) { if (beneficiary.send(amountLeft)) { FundTransfer(beneficiary, amountLeft, false); } else { } } }",
        "vulnerability": "Incorrect Logic for amountLeft Update",
        "reason": "The `amountLeft` is never updated within the contract. In the fallback function, if `beneficiary.send(amount)` fails, `amountLeft` is updated incorrectly with `amountLeft += amountLeft;`, which does not reflect the intended logic of adding the failed amount to `amountLeft`. This could lead to incorrect balances and unexpected behaviors in withdrawals.",
        "file_name": "0xc67c1f88f31e724b137a057292e55cb42a5f3241.sol"
    }
]