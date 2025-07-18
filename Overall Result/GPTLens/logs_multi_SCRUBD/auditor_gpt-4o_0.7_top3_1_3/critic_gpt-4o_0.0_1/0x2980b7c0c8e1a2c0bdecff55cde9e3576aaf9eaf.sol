[
    {
        "function_name": "transferFrom",
        "vulnerability": "Missing allowance check",
        "criticism": "The reasoning is incorrect. The function does check whether the allowance is greater than or equal to the amount with the require statement. However, the vulnerability lies in the fact that the allowance is only decremented if the source is not the sender, which could lead to incorrect allowance management. The severity is moderate as it could lead to unexpected behavior, but profitability is low as it doesn't directly allow unauthorized transfers.",
        "correctness": 3,
        "severity": 4,
        "profitability": 1,
        "reason": "The function does not check whether the allowance is greater than or equal to the amount before approving the transfer. This could allow an attacker to transfer tokens on behalf of another user without their consent, leading to unauthorized token transfers.",
        "code": "function transferFrom(address src, address dst, uint amount) public returns (bool){ address sender = msg.sender; require(approvals[src][sender] >= amount); if (src != sender) { approvals[src][sender] -= amount; } moveTokens(src,dst,amount); return true; }",
        "file_name": "0x2980b7c0c8e1a2c0bdecff55cde9e3576aaf9eaf.sol"
    },
    {
        "function_name": "withdraw",
        "vulnerability": "Reentrancy vulnerability",
        "criticism": "The reasoning is correct. The function sends Ether to the sender before updating the state variables, which is a classic reentrancy vulnerability. This could allow an attacker to re-enter the function and manipulate the state, potentially leading to theft of funds. The severity is high due to the potential for significant financial loss, and profitability is also high for an attacker who can exploit this vulnerability.",
        "correctness": 9,
        "severity": 8,
        "profitability": 8,
        "reason": "The function sends Ether to the sender before updating the state variables. This allows an attacker to re-enter the function and potentially manipulate the state, leading to potential theft of funds by exploiting the reentrancy vulnerability.",
        "code": "function withdraw(uint amount) public returns(uint){ address payable sender = msg.sender; uint upScaleDivs = (uint)((int256)( earningsPerResolve * resolveWeight[sender] ) - payouts[sender]); uint totalEarnings = upScaleDivs / scaleFactor; require( amount <= totalEarnings && amount > 0 ); uint oldWeight = resolveWeight[sender]; resolveWeight[sender] = oldWeight * ( totalEarnings - amount ) / totalEarnings; uint weightDiff = oldWeight - resolveWeight[sender]; resolveToken.transfer( address0, weightDiff); dissolvingResolves -= weightDiff; int withdrawnEarnings = (int)(upScaleDivs * amount / totalEarnings) - (int)(weightDiff*earningsPerResolve); payouts[sender] += withdrawnEarnings; earningsOffset += withdrawnEarnings; (bool success, ) = sender.call{value: amount}(\"\"); require(success, \"Transfer failed.\"); emit Withdraw( sender, amount, weightDiff); return weightDiff; }",
        "file_name": "0x2980b7c0c8e1a2c0bdecff55cde9e3576aaf9eaf.sol"
    },
    {
        "function_name": "pullResolves",
        "vulnerability": "Potential division by zero",
        "criticism": "The reasoning is correct. The function does not handle the case where 'dissolvingResolves' is zero, which could lead to a division by zero error. This could cause the contract to malfunction, but it is unlikely to be exploitable for profit. The severity is moderate as it could disrupt contract functionality, but profitability is low as it doesn't directly benefit an attacker.",
        "correctness": 8,
        "severity": 5,
        "profitability": 1,
        "reason": "The function does not properly handle the case where the variable 'dissolvingResolves' is zero, which would lead to a division by zero error. This could potentially cause the contract to malfunction or allow an attacker to exploit the contract logic.",
        "code": "function pullResolves(uint amount) public returns (uint forfeiture){ address sender = msg.sender; uint resolves = resolveWeight[ sender ]; require(amount <= resolves && amount > 0); require(amount < dissolvingResolves); uint yourTotalEarnings = (uint)((int256)(resolves * earningsPerResolve) - payouts[sender]); uint forfeitedEarnings = yourTotalEarnings * amount / resolves; payouts[sender] += (int256)(forfeitedEarnings) - (int256)(earningsPerResolve * amount); resolveWeight[sender] -= amount; dissolvingResolves -= amount; earningsPerResolve += forfeitedEarnings / dissolvingResolves; resolveToken.transfer( sender, amount ); emit PullResolves( sender, amount, forfeitedEarnings / scaleFactor); return forfeitedEarnings / scaleFactor; }",
        "file_name": "0x2980b7c0c8e1a2c0bdecff55cde9e3576aaf9eaf.sol"
    }
]