[
    {
        "function_name": "function() payable",
        "code": "function () payable public{ require(!crowdsaleClosed); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; tokenReward.transfer(msg.sender, amount*10000); FundTransfer(msg.sender, amount, true); if(beneficiary.send(amount)) { FundTransfer(beneficiary, amount, false); } else { amountLeft += amountLeft; } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The use of `beneficiary.send(amount)` creates a potential reentrancy vulnerability since it sends Ether before updating the state variable `amountLeft`. An attacker can exploit this by recursively calling the fallback function, leading to multiple transfers of Ether before the state update.",
        "file_name": "0xc67c1f88f31e724b137a057292e55cb42a5f3241.sol"
    },
    {
        "function_name": "function() payable",
        "code": "function () payable public{ require(!crowdsaleClosed); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; tokenReward.transfer(msg.sender, amount*10000); FundTransfer(msg.sender, amount, true); if(beneficiary.send(amount)) { FundTransfer(beneficiary, amount, false); } else { amountLeft += amountLeft; } }",
        "vulnerability": "Token reward miscalculation",
        "reason": "The calculation `amount*10000` for token rewards does not take into account the token's decimals or potential large value overflows, which could lead to incorrect token distribution or facilitating an integer overflow attack.",
        "file_name": "0xc67c1f88f31e724b137a057292e55cb42a5f3241.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline public{ if (beneficiary == msg.sender&& amountLeft > 0) { if (beneficiary.send(amountLeft)) { FundTransfer(beneficiary, amountLeft, false); } else { } } }",
        "vulnerability": "Insecure Ether transfer",
        "reason": "The `beneficiary.send(amountLeft)` method provides only 2300 gas which might not be enough if the beneficiary's address is a contract with a fallback function requiring more gas, potentially causing the withdrawal to fail.",
        "file_name": "0xc67c1f88f31e724b137a057292e55cb42a5f3241.sol"
    }
]