[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address src, address dst, uint amount) public returns (bool){ address sender = msg.sender; require(approvals[src][sender] >= amount); if (src != sender) { approvals[src][sender] -= amount; } moveTokens(src,dst,amount); return true; }",
        "vulnerability": "Missing check for sufficient balance",
        "reason": "The function transferFrom does not check whether the src address has a sufficient balance to transfer the specified amount. An attacker could exploit this by convincing a token holder to approve a transfer amount greater than their balance, resulting in unexpected behavior or potential loss of funds.",
        "file_name": "0x2980b7c0c8e1a2c0bdecff55cde9e3576aaf9eaf.sol"
    },
    {
        "function_name": "transferToContract",
        "code": "function transferToContract(address _to, uint _value, bytes memory _data) private returns (bool) { moveTokens(msg.sender, _to, _value); ERC223ReceivingContract receiver = ERC223ReceivingContract(_to); receiver.tokenFallback(msg.sender, _value, _data); emit Transfer(msg.sender, _to, _value, _data); return true; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The call to tokenFallback in an external contract (_to) is made before the state changes (emitting Transfer and returning true) in transferToContract. This could allow a reentrant call, potentially allowing an attacker to call back into the contract and exploit it by altering the state in an unintended way.",
        "file_name": "0x2980b7c0c8e1a2c0bdecff55cde9e3576aaf9eaf.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint amount) public returns(uint){ address payable sender = msg.sender; uint upScaleDivs = (uint)((int256)( earningsPerResolve * resolveWeight[sender] ) - payouts[sender]); uint totalEarnings = upScaleDivs / scaleFactor; require( amount <= totalEarnings && amount > 0 ); uint oldWeight = resolveWeight[sender]; resolveWeight[sender] = oldWeight * ( totalEarnings - amount ) / totalEarnings; uint weightDiff = oldWeight - resolveWeight[sender]; resolveToken.transfer( address0, weightDiff); dissolvingResolves -= weightDiff; int withdrawnEarnings = (int)(upScaleDivs * amount / totalEarnings) - (int)(weightDiff*earningsPerResolve); payouts[sender] += withdrawnEarnings; earningsOffset += withdrawnEarnings; (bool success, ) = sender.call{value: amount}(\"\"); require(success, \"Transfer failed.\"); emit Withdraw( sender, amount, weightDiff); return weightDiff; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function withdraw uses call to send Ether to the sender. This is a low-level call, and if the sender is a contract, it can exploit this by re-entering the withdraw function and altering the state (payouts and earningsOffset) multiple times before the function fully executes, potentially leading to double withdrawals.",
        "file_name": "0x2980b7c0c8e1a2c0bdecff55cde9e3576aaf9eaf.sol"
    }
]