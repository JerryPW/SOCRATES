[
    {
        "function_name": "successful",
        "vulnerability": "Lack of access control",
        "criticism": "The reasoning is correct. The successful() function is publicly callable, which allows anyone to trigger the transfer of all remaining tokens and Ether to the creator. This is a significant vulnerability because it could lead to unauthorized execution of critical functions, potentially resulting in loss of funds. The severity is high because it affects the integrity of the contract's operations. The profitability is also high because an attacker could exploit this to cause financial loss to the contract.",
        "correctness": 9,
        "severity": 8,
        "profitability": 7,
        "reason": "The successful() function is publicly callable, allowing anyone to execute it and transfer all remaining tokens and Ether to the creator address. This should be restricted to the contract owner or admin.",
        "code": "function successful() public { require(state == State.Successful); if (now > completedAt.add(14 days)){ uint256 remanent = tokenReward.balanceOf(this); tokenReward.transfer(creator,remanent); emit LogContributorsPayout(creator, remanent); } creator.transfer(address(this).balance); emit LogBeneficiaryPaid(creator); }",
        "file_name": "0x0bc95951bb59d6fd063ce7ad5c3b3dcaace98132.sol",
        "final_score": 8.25
    },
    {
        "function_name": "contribute",
        "vulnerability": "KYC bypass",
        "criticism": "The reasoning is partially correct. While it is true that an attacker can accumulate a balance of tokens before completing KYC validation, the tokens are not actually distributed until KYC is validated. This means the attacker cannot bypass the KYC check to receive tokens. The vulnerability lies more in the potential for accumulating a large balance that could be claimed all at once, which might not be the intended behavior. The severity is moderate because it could lead to unexpected token distribution patterns, but it does not bypass KYC entirely. The profitability is low because the attacker still needs to pass KYC to receive tokens.",
        "correctness": 6,
        "severity": 4,
        "profitability": 2,
        "reason": "An attacker can call contribute() multiple times before completing KYC validation, accumulating a balance of tokens without receiving them. Once KYC is validated, they can claim all tokens at once, bypassing the intended KYC check during token distribution.",
        "code": "function contribute() public notFinishedOrHold payable { require(whiteList[msg.sender] == true); require(msg.value >= 0.1 ether); uint256 tokenBought = 0; totalRaised = totalRaised.add(msg.value); ethOnContract[msg.sender] = ethOnContract[msg.sender].add(msg.value); if (state == State.PreSale){ require(now >= PreSaleStart); tokenBought = msg.value.mul(rates[0]); PreSaleDistributed = PreSaleDistributed.add(tokenBought); } else if (state == State.MainSale){ require(now >= MainSaleStart); if (now <= MainSaleStart.add(1 weeks)){ tokenBought = msg.value.mul(rates[1]); } else if (now <= MainSaleStart.add(2 weeks)){ tokenBought = msg.value.mul(rates[2]); } else if (now <= MainSaleStart.add(3 weeks)){ tokenBought = msg.value.mul(rates[3]); } else tokenBought = msg.value.mul(rates[4]); } require(totalDistributed.add(tokenBought) <= hardCap); if(KYCValid[msg.sender] == true){ uint256 tempBalance = balance[msg.sender]; balance[msg.sender] = 0; require(tokenReward.transfer(msg.sender, tokenBought.add(tempBalance))); tokensSent[msg.sender] = tokensSent[msg.sender].add(tokenBought.add(tempBalance)); emit LogContributorsPayout(msg.sender, tokenBought.add(tempBalance)); } else{ balance[msg.sender] = balance[msg.sender].add(tokenBought); } totalDistributed = totalDistributed.add(tokenBought); emit LogFundingReceived(msg.sender, msg.value, totalRaised); checkIfFundingCompleteOrExpired(); }",
        "file_name": "0x0bc95951bb59d6fd063ce7ad5c3b3dcaace98132.sol",
        "final_score": 4.5
    }
]