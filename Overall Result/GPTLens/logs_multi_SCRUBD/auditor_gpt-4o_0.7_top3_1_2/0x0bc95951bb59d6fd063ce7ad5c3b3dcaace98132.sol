[
    {
        "function_name": "contribute",
        "code": "function contribute() public notFinishedOrHold payable { require(whiteList[msg.sender] == true); require(msg.value >= 0.1 ether); uint256 tokenBought = 0; totalRaised = totalRaised.add(msg.value); ethOnContract[msg.sender] = ethOnContract[msg.sender].add(msg.value); if (state == State.PreSale){ require(now >= PreSaleStart); tokenBought = msg.value.mul(rates[0]); PreSaleDistributed = PreSaleDistributed.add(tokenBought); } else if (state == State.MainSale){ require(now >= MainSaleStart); if (now <= MainSaleStart.add(1 weeks)){ tokenBought = msg.value.mul(rates[1]); } else if (now <= MainSaleStart.add(2 weeks)){ tokenBought = msg.value.mul(rates[2]); } else if (now <= MainSaleStart.add(3 weeks)){ tokenBought = msg.value.mul(rates[3]); } else tokenBought = msg.value.mul(rates[4]); } require(totalDistributed.add(tokenBought) <= hardCap); if(KYCValid[msg.sender] == true){ uint256 tempBalance = balance[msg.sender]; balance[msg.sender] = 0; require(tokenReward.transfer(msg.sender, tokenBought.add(tempBalance))); tokensSent[msg.sender] = tokensSent[msg.sender].add(tokenBought.add(tempBalance)); emit LogContributorsPayout(msg.sender, tokenBought.add(tempBalance)); } else{ balance[msg.sender] = balance[msg.sender].add(tokenBought); } totalDistributed = totalDistributed.add(tokenBought); emit LogFundingReceived(msg.sender, msg.value, totalRaised); checkIfFundingCompleteOrExpired(); }",
        "vulnerability": "KYC bypass",
        "reason": "An attacker can call contribute() multiple times before completing KYC validation, accumulating a balance of tokens without receiving them. Once KYC is validated, they can claim all tokens at once, bypassing the intended KYC check during token distribution.",
        "file_name": "0x0bc95951bb59d6fd063ce7ad5c3b3dcaace98132.sol"
    },
    {
        "function_name": "successful",
        "code": "function successful() public { require(state == State.Successful); if (now > completedAt.add(14 days)){ uint256 remanent = tokenReward.balanceOf(this); tokenReward.transfer(creator,remanent); emit LogContributorsPayout(creator, remanent); } creator.transfer(address(this).balance); emit LogBeneficiaryPaid(creator); }",
        "vulnerability": "Lack of access control",
        "reason": "The successful() function is publicly callable, allowing anyone to execute it and transfer all remaining tokens and Ether to the creator address. This should be restricted to the contract owner or admin.",
        "file_name": "0x0bc95951bb59d6fd063ce7ad5c3b3dcaace98132.sol"
    },
    {
        "function_name": "refund",
        "code": "function refund() public { require(state == State.Failed); if (now < completedAt.add(90 days)){ uint256 holderTokens = tokensSent[msg.sender]; tokensSent[msg.sender] = 0; balance[msg.sender] = 0; uint256 holderETH = ethOnContract[msg.sender]; ethOnContract[msg.sender] = 0; require(tokenReward.transferFrom(msg.sender,address(this),holderTokens)); msg.sender.transfer(holderETH); emit LogRefund(msg.sender,holderETH); } else{ require(level[msg.sender] >= 2); uint256 remanent = tokenReward.balanceOf(this); creator.transfer(address(this).balance); tokenReward.transfer(creator,remanent); emit LogBeneficiaryPaid(creator); emit LogContributorsPayout(creator, remanent); } }",
        "vulnerability": "Token approval requirement",
        "reason": "The refund process requires token transfer approval from the contributor (transferFrom), which may not be approved beforehand, making it difficult for users to claim refunds. This can be exploited by preventing refunds if the token transfer is not approved.",
        "file_name": "0x0bc95951bb59d6fd063ce7ad5c3b3dcaace98132.sol"
    }
]