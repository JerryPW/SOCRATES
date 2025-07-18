[
    {
        "function_name": "investInternal",
        "code": "function investInternal(address receiver, uint128 customerId) stopInEmergency private { if(getState() == State.PreFunding) { if(!earlyParticipantWhitelist[receiver]) { throw; } } else if(getState() == State.Funding) { } else { throw; } uint weiAmount = msg.value; uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals()); if(tokenAmount == 0) { throw; } if(investedAmountOf[receiver] == 0) { investorCount++; } investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount); tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount); weiRaised = weiRaised.plus(weiAmount); tokensSold = tokensSold.plus(tokenAmount); if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) { throw; } assignTokens(receiver, tokenAmount); if(!multisigWallet.send(weiAmount)) throw; Invested(receiver, weiAmount, tokenAmount, customerId); }",
        "vulnerability": "Lack of Cap Verification",
        "reason": "The function does not adequately prevent investments that exceed the crowdsale cap, which could lead to selling more tokens than intended.",
        "file_name": "0x3085c9403871c00f7fd2e84dac1bdaa05f5f652e.sol"
    },
    {
        "function_name": "setEndsAt",
        "code": "function setEndsAt(uint time) onlyOwner { if(now > time) { throw; } endsAt = time; EndsAtChanged(endsAt); }",
        "vulnerability": "Arbitrary End Time Change",
        "reason": "The owner can set the crowdsale end time to any future point, potentially extending the sale indefinitely, which could be exploited to manipulate investment periods.",
        "file_name": "0x3085c9403871c00f7fd2e84dac1bdaa05f5f652e.sol"
    },
    {
        "function_name": "buyForEverybody",
        "code": "function buyForEverybody() stopInEmergency public { if(getState() != State.Funding) { throw; } if(address(crowdsale) == 0) throw; crowdsale.invest.value(weiRaisedTotal)(address(this)); tokensBought = getToken().balanceOf(address(this)); if(tokensBought == 0) { throw; } TokensBoughts(tokensBought); }",
        "vulnerability": "Reentrancy Risk",
        "reason": "The function sends Ether to an external contract without proper checks and balances, leading to potential reentrancy attacks if the external contract is compromised.",
        "file_name": "0x3085c9403871c00f7fd2e84dac1bdaa05f5f652e.sol"
    }
]