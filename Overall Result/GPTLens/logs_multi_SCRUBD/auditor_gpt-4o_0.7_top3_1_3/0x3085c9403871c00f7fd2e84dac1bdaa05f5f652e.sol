[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address newOwner) onlyOwner { if (newOwner != address(0)) { owner = newOwner; } }",
        "vulnerability": "Lack of event emission on ownership transfer",
        "reason": "The `transferOwnership` function changes the owner of the contract but does not emit an event. This makes it difficult to track changes in ownership, which is crucial for transparency and auditing. Emitting an event would allow off-chain systems to listen for and respond to changes in the contract's state.",
        "file_name": "0x3085c9403871c00f7fd2e84dac1bdaa05f5f652e.sol"
    },
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint _value) returns (bool success) { if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw; allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; }",
        "vulnerability": "Race condition in approve function (ERC20 approve/transferFrom issue)",
        "reason": "There is a known race condition in the ERC20 `approve` function. If an attacker monitors a change in the allowance, they can invoke `transferFrom` repeatedly before the allowance is updated, leading to potential double-spending. The conditional check `if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;` attempts to mitigate this, but it introduces usability issues and is not a foolproof solution.",
        "file_name": "0x3085c9403871c00f7fd2e84dac1bdaa05f5f652e.sol"
    },
    {
        "function_name": "investInternal",
        "code": "function investInternal(address receiver, uint128 customerId) stopInEmergency private { if(getState() == State.PreFunding) { if(!earlyParticipantWhitelist[receiver]) { throw; } } else if(getState() == State.Funding) { } else { throw; } uint weiAmount = msg.value; uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals()); if(tokenAmount == 0) { throw; } if(investedAmountOf[receiver] == 0) { investorCount++; } investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount); tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount); weiRaised = weiRaised.plus(weiAmount); tokensSold = tokensSold.plus(tokenAmount); if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) { throw; } assignTokens(receiver, tokenAmount); if(!multisigWallet.send(weiAmount)) throw; Invested(receiver, weiAmount, tokenAmount, customerId); }",
        "vulnerability": "Sending Ether to untrusted address",
        "reason": "The `investInternal` function sends Ether directly to the `multisigWallet` using the `send` method. If the `multisigWallet` address is not controlled by the contract owner or is a contract with a fallback function, it may lead to reentrancy attacks or loss of funds if the transfer fails. Using `transfer` or `call.value` with appropriate checks is recommended to handle such cases safely.",
        "file_name": "0x3085c9403871c00f7fd2e84dac1bdaa05f5f652e.sol"
    }
]