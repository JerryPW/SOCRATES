[
    {
        "function_name": "buyForEverybody",
        "vulnerability": "Reentrancy Risk",
        "criticism": "The reasoning is correct. The function sends Ether to an external contract without using checks-effects-interactions pattern, which can lead to reentrancy attacks if the external contract is compromised. The severity is high because reentrancy can lead to significant financial loss, and the profitability is also high for an attacker who can exploit this vulnerability.",
        "correctness": 9,
        "severity": 8,
        "profitability": 8,
        "reason": "The function sends Ether to an external contract without proper checks and balances, leading to potential reentrancy attacks if the external contract is compromised.",
        "code": "function buyForEverybody() stopInEmergency public { if(getState() != State.Funding) { throw; } if(address(crowdsale) == 0) throw; crowdsale.invest.value(weiRaisedTotal)(address(this)); tokensBought = getToken().balanceOf(address(this)); if(tokensBought == 0) { throw; } TokensBoughts(tokensBought); }",
        "file_name": "0x3085c9403871c00f7fd2e84dac1bdaa05f5f652e.sol",
        "final_score": 8.5
    },
    {
        "function_name": "setEndsAt",
        "vulnerability": "Arbitrary End Time Change",
        "criticism": "The reasoning is correct. The owner can indeed set the end time to any future point, which could be used to manipulate the investment period. This is a design decision that allows flexibility but can be exploited if the owner is malicious. The severity is moderate because it depends on the owner's intentions, and the profitability is low for external attackers.",
        "correctness": 8,
        "severity": 5,
        "profitability": 1,
        "reason": "The owner can set the crowdsale end time to any future point, potentially extending the sale indefinitely, which could be exploited to manipulate investment periods.",
        "code": "function setEndsAt(uint time) onlyOwner { if(now > time) { throw; } endsAt = time; EndsAtChanged(endsAt); }",
        "file_name": "0x3085c9403871c00f7fd2e84dac1bdaa05f5f652e.sol",
        "final_score": 5.5
    },
    {
        "function_name": "investInternal",
        "vulnerability": "Lack of Cap Verification",
        "criticism": "The reasoning is partially correct. The function does check for cap violations with the isBreakingCap function, but the details of this function are not provided, so it's unclear if it is implemented correctly. If isBreakingCap is not properly implemented, it could indeed lead to selling more tokens than intended. The severity is potentially high if the cap is not enforced, but the profitability for an attacker is low unless they can manipulate the cap check.",
        "correctness": 5,
        "severity": 7,
        "profitability": 2,
        "reason": "The function does not adequately prevent investments that exceed the crowdsale cap, which could lead to selling more tokens than intended.",
        "code": "function investInternal(address receiver, uint128 customerId) stopInEmergency private { if(getState() == State.PreFunding) { if(!earlyParticipantWhitelist[receiver]) { throw; } } else if(getState() == State.Funding) { } else { throw; } uint weiAmount = msg.value; uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals()); if(tokenAmount == 0) { throw; } if(investedAmountOf[receiver] == 0) { investorCount++; } investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount); tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount); weiRaised = weiRaised.plus(weiAmount); tokensSold = tokensSold.plus(tokenAmount); if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) { throw; } assignTokens(receiver, tokenAmount); if(!multisigWallet.send(weiAmount)) throw; Invested(receiver, weiAmount, tokenAmount, customerId); }",
        "file_name": "0x3085c9403871c00f7fd2e84dac1bdaa05f5f652e.sol",
        "final_score": 4.75
    }
]