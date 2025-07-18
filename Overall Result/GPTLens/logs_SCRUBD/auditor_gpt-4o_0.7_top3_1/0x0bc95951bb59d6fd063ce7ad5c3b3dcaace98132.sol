[
    {
        "function_name": "refund",
        "code": "function refund() public { require(state == State.Failed); if (now < completedAt.add(90 days)){ uint256 holderTokens = tokensSent[msg.sender]; tokensSent[msg.sender] = 0; balance[msg.sender] = 0; uint256 holderETH = ethOnContract[msg.sender]; ethOnContract[msg.sender] = 0; require(tokenReward.transferFrom(msg.sender,address(this),holderTokens)); msg.sender.transfer(holderETH); emit LogRefund(msg.sender,holderETH); } else{ require(level[msg.sender] >= 2); uint256 remanent = tokenReward.balanceOf(this); creator.transfer(address(this).balance); tokenReward.transfer(creator,remanent); emit LogBeneficiaryPaid(creator); emit LogContributorsPayout(creator, remanent); } }",
        "vulnerability": "Incorrect token transfer handling",
        "reason": "The refund function attempts to transfer tokens from msg.sender to the contract using transferFrom without ensuring prior approval. This can cause the transaction to revert if the sender has not set an allowance for the contract to spend their tokens, preventing users from being refunded as intended.",
        "file_name": "0x0bc95951bb59d6fd063ce7ad5c3b3dcaace98132.sol"
    },
    {
        "function_name": "successful",
        "code": "function successful() public { require(state == State.Successful); if (now > completedAt.add(14 days)){ uint256 remanent = tokenReward.balanceOf(this); tokenReward.transfer(creator,remanent); emit LogContributorsPayout(creator, remanent); } creator.transfer(address(this).balance); emit LogBeneficiaryPaid(creator); }",
        "vulnerability": "Lack of access control",
        "reason": "The successful function can be called by anyone once the state is marked as Successful. This allows any user to transfer all remaining tokens and ETH balance to the creator even before the 14-day period has passed, which should be restricted to specific roles or conditions to prevent misuse.",
        "file_name": "0x0bc95951bb59d6fd063ce7ad5c3b3dcaace98132.sol"
    },
    {
        "function_name": "claimEth",
        "code": "function claimEth() onlyAdmin(2) public { require(totalDistributed >= softCap); creator.transfer(address(this).balance); emit LogBeneficiaryPaid(creator); }",
        "vulnerability": "No state check for claim",
        "reason": "The claimEth function allows the creator to withdraw all ETH from the contract as long as totalDistributed is above the softCap, without checking if the sale has been marked as Successful. This means that funds could be prematurely withdrawn even if the sale is ongoing or incomplete, which can lead to loss of funds for contributors.",
        "file_name": "0x0bc95951bb59d6fd063ce7ad5c3b3dcaace98132.sol"
    }
]