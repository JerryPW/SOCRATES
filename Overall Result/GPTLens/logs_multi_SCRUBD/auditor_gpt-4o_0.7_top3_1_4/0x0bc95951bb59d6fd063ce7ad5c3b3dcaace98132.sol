[
    {
        "function_name": "refund",
        "code": "function refund() public { require(state == State.Failed); if (now < completedAt.add(90 days)){ uint256 holderTokens = tokensSent[msg.sender]; tokensSent[msg.sender] = 0; balance[msg.sender] = 0; uint256 holderETH = ethOnContract[msg.sender]; ethOnContract[msg.sender] = 0; require(tokenReward.transferFrom(msg.sender,address(this),holderTokens)); msg.sender.transfer(holderETH); emit LogRefund(msg.sender,holderETH); } else{ require(level[msg.sender] >= 2); uint256 remanent = tokenReward.balanceOf(this); creator.transfer(address(this).balance); tokenReward.transfer(creator,remanent); emit LogBeneficiaryPaid(creator); emit LogContributorsPayout(creator, remanent); } }",
        "vulnerability": "Potential token theft due to lack of approval check",
        "reason": "The refund function requires the transfer of tokens from the user back to the contract using transferFrom, but it does not check if the user has approved the contract to transfer the tokens. This can lead to failed transactions or allow a user to exploit the lack of approval check to avoid returning tokens while still receiving a refund.",
        "file_name": "0x0bc95951bb59d6fd063ce7ad5c3b3dcaace98132.sol"
    },
    {
        "function_name": "contribute",
        "code": "function contribute() public notFinishedOrHold payable { require(whiteList[msg.sender] == true); require(msg.value >= 0.1 ether); uint256 tokenBought = 0; totalRaised = totalRaised.add(msg.value); ethOnContract[msg.sender] = ethOnContract[msg.sender].add(msg.value); if (state == State.PreSale){ require(now >= PreSaleStart); tokenBought = msg.value.mul(rates[0]); PreSaleDistributed = PreSaleDistributed.add(tokenBought); } else if (state == State.MainSale){ require(now >= MainSaleStart); if (now <= MainSaleStart.add(1 weeks)){ tokenBought = msg.value.mul(rates[1]); } else if (now <= MainSaleStart.add(2 weeks)){ tokenBought = msg.value.mul(rates[2]); } else if (now <= MainSaleStart.add(3 weeks)){ tokenBought = msg.value.mul(rates[3]); } else tokenBought = msg.value.mul(rates[4]); } require(totalDistributed.add(tokenBought) <= hardCap); if(KYCValid[msg.sender] == true){ uint256 tempBalance = balance[msg.sender]; balance[msg.sender] = 0; require(tokenReward.transfer(msg.sender, tokenBought.add(tempBalance))); tokensSent[msg.sender] = tokensSent[msg.sender].add(tokenBought.add(tempBalance)); emit LogContributorsPayout(msg.sender, tokenBought.add(tempBalance)); } else{ balance[msg.sender] = balance[msg.sender].add(tokenBought); } totalDistributed = totalDistributed.add(tokenBought); emit LogFundingReceived(msg.sender, msg.value, totalRaised); checkIfFundingCompleteOrExpired(); }",
        "vulnerability": "Reentrancy vulnerability via external call",
        "reason": "The contribute function makes an external call to the tokenReward contract to transfer tokens to the sender without using a reentrancy guard or updating the state variables before the call. This could be exploited by an attacker to re-enter the function and manipulate the contract's state variables, such as totalRaised, ethOnContract, and totalDistributed, leading to inconsistent contract state or financial loss.",
        "file_name": "0x0bc95951bb59d6fd063ce7ad5c3b3dcaace98132.sol"
    },
    {
        "function_name": "successful",
        "code": "function successful() public { require(state == State.Successful); if (now > completedAt.add(14 days)){ uint256 remanent = tokenReward.balanceOf(this); tokenReward.transfer(creator,remanent); emit LogContributorsPayout(creator, remanent); } creator.transfer(address(this).balance); emit LogBeneficiaryPaid(creator); }",
        "vulnerability": "Unauthorized fund transfer to creator",
        "reason": "The successful function allows the creator to transfer all remaining ETH and tokens from the contract balance to themselves without any restrictions or checks beyond the contract state. This could be exploited if the creator or an attacker with admin privileges manipulates the contract state to Successful, allowing them to withdraw all funds regardless of other contributors or the actual success of the campaign.",
        "file_name": "0x0bc95951bb59d6fd063ce7ad5c3b3dcaace98132.sol"
    }
]