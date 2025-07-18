[
    {
        "function_name": "contribute",
        "code": "function contribute() public notFinishedOrHold payable { require(whiteList[msg.sender] == true); require(msg.value >= 0.1 ether); uint256 tokenBought = 0; totalRaised = totalRaised.add(msg.value); ethOnContract[msg.sender] = ethOnContract[msg.sender].add(msg.value); if (state == State.PreSale){ require(now >= PreSaleStart); tokenBought = msg.value.mul(rates[0]); PreSaleDistributed = PreSaleDistributed.add(tokenBought); } else if (state == State.MainSale){ require(now >= MainSaleStart); if (now <= MainSaleStart.add(1 weeks)){ tokenBought = msg.value.mul(rates[1]); } else if (now <= MainSaleStart.add(2 weeks)){ tokenBought = msg.value.mul(rates[2]); } else if (now <= MainSaleStart.add(3 weeks)){ tokenBought = msg.value.mul(rates[3]); } else tokenBought = msg.value.mul(rates[4]); } require(totalDistributed.add(tokenBought) <= hardCap); if(KYCValid[msg.sender] == true){ uint256 tempBalance = balance[msg.sender]; balance[msg.sender] = 0; require(tokenReward.transfer(msg.sender, tokenBought.add(tempBalance))); tokensSent[msg.sender] = tokensSent[msg.sender].add(tokenBought.add(tempBalance)); emit LogContributorsPayout(msg.sender, tokenBought.add(tempBalance)); } else{ balance[msg.sender] = balance[msg.sender].add(tokenBought); } totalDistributed = totalDistributed.add(tokenBought); emit LogFundingReceived(msg.sender, msg.value, totalRaised); checkIfFundingCompleteOrExpired(); }",
        "vulnerability": "Race Condition in Funding Completion",
        "reason": "The function contribute() does not lock the contract state or totalDistributed variable while checking and updating them, leading to a race condition. Multiple transactions could be processed concurrently, potentially allowing totalDistributed to exceed the hardCap before the checkIfFundingCompleteOrExpired() function is invoked.",
        "file_name": "0x0bc95951bb59d6fd063ce7ad5c3b3dcaace98132.sol"
    },
    {
        "function_name": "successful",
        "code": "function successful() public { require(state == State.Successful); if (now > completedAt.add(14 days)){ uint256 remanent = tokenReward.balanceOf(this); tokenReward.transfer(creator,remanent); emit LogContributorsPayout(creator, remanent); } creator.transfer(address(this).balance); emit LogBeneficiaryPaid(creator); }",
        "vulnerability": "Lack of Access Control",
        "reason": "The successful() function can be called by anyone once the funding is complete, allowing any user to withdraw the entire contract balance to the creator. This should be restricted to only the creator or an admin to prevent unauthorized withdrawals.",
        "file_name": "0x0bc95951bb59d6fd063ce7ad5c3b3dcaace98132.sol"
    },
    {
        "function_name": "refund",
        "code": "function refund() public { require(state == State.Failed); if (now < completedAt.add(90 days)){ uint256 holderTokens = tokensSent[msg.sender]; tokensSent[msg.sender] = 0; balance[msg.sender] = 0; uint256 holderETH = ethOnContract[msg.sender]; ethOnContract[msg.sender] = 0; require(tokenReward.transferFrom(msg.sender,address(this),holderTokens)); msg.sender.transfer(holderETH); emit LogRefund(msg.sender,holderETH); } else{ require(level[msg.sender] >= 2); uint256 remanent = tokenReward.balanceOf(this); creator.transfer(address(this).balance); tokenReward.transfer(creator,remanent); emit LogBeneficiaryPaid(creator); emit LogContributorsPayout(creator, remanent); } }",
        "vulnerability": "Token Transfer Assumption",
        "reason": "The refund() function assumes that the transferFrom() call will always succeed. If the token contract does not have an allowance set, this will fail, preventing users from reclaiming their ETH. There should be a check to ensure that the transferFrom() call is successful and the correct amount of tokens are transferred back.",
        "file_name": "0x0bc95951bb59d6fd063ce7ad5c3b3dcaace98132.sol"
    }
]