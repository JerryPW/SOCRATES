[
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _amount) public onlyOwner { require(_amount > 0); uint256 amount = _amount; updateReleasedBalance(); uint256 available_balance = getAvailableBalance(); if (amount > available_balance) { amount = available_balance; } withdrawnBalance = withdrawnBalance.add(amount); owner.transfer(amount); emit WithdrawalHistory(\"ETH\", amount); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The withdraw function transfers Ether to the owner before updating the withdrawnBalance state variable. This could allow a reentrancy attack if the recipient is a contract with a fallback function that calls withdraw again.",
        "file_name": "0x136e99a415957fc3f23e0a6885b22bcd0c475ab4.sol"
    },
    {
        "function_name": "refund",
        "code": "function refund(uint256 tokenAmount) external poolDestructed { require(ERC20Interface(votingTokenAddr).transferFrom(msg.sender, this, tokenAmount)); uint256 refundingEther = tokenAmount.mul(refundRateNano).div(10**9); emit Refund(msg.sender, tokenAmount); msg.sender.transfer(refundingEther); }",
        "vulnerability": "Improper check on transferFrom function",
        "reason": "The refund function assumes that transferFrom will succeed without checking its return value. If transferFrom fails silently, the contract may proceed with issuing a refund without actually receiving tokens, which could lead to financial discrepancies.",
        "file_name": "0x136e99a415957fc3f23e0a6885b22bcd0c475ab4.sol"
    },
    {
        "function_name": "addProposal",
        "code": "function addProposal (Subject _subject, string _reason) internal returns(uint256) { require(msg.value == proposalCostWei); require(DaicoPool(poolAddr).isStateProjectInProgress()); poolAddr.transfer(msg.value); Proposal memory proposal; proposal.subject = _subject; proposal.reason = _reason; proposal.start_time = block.timestamp; proposal.end_time = block.timestamp + VOTING_PERIOD; proposal.voter_count = 0; proposal.isFinalized = false; proposals.push(proposal); uint256 newID = proposals.length - 1; return newID; }",
        "vulnerability": "Improper Ether handling with msg.value",
        "reason": "The function relies on msg.value for validating proposal costs, but it doesn't ensure that msg.value is correctly handled or refunded if conditions fail. This can result in Ether being locked or improperly handled.",
        "file_name": "0x136e99a415957fc3f23e0a6885b22bcd0c475ab4.sol"
    }
]