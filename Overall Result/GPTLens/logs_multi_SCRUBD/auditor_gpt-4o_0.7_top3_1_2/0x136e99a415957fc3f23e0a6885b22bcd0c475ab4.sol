[
    {
        "function_name": "selfDestruction",
        "code": "function selfDestruction() external onlyVoting { status = Status.Destructed; updateReleasedBalance(); releasedBalance = releasedBalance.add(closingRelease.mul(tap)); updateTap(0); uint256 _totalSupply = ERC20Interface(votingTokenAddr).totalSupply(); refundRateNano = address(this).balance.sub(getAvailableBalance()).mul(10**9).div(_totalSupply); }",
        "vulnerability": "Potential incorrect refundRateNano calculation",
        "reason": "If the available balance is greater than the current contract balance, the subtraction can result in a negative number for refundRateNano, leading to an incorrect refund calculation.",
        "file_name": "0x136e99a415957fc3f23e0a6885b22bcd0c475ab4.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _amount) public onlyOwner { require(_amount > 0); uint256 amount = _amount; updateReleasedBalance(); uint256 available_balance = getAvailableBalance(); if (amount > available_balance) { amount = available_balance; } withdrawnBalance = withdrawnBalance.add(amount); owner.transfer(amount); emit WithdrawalHistory(\"ETH\", amount); }",
        "vulnerability": "Potential for owner to withdraw beyond the limits",
        "reason": "The getAvailableBalance function does not accurately account for all edge cases, allowing the owner to potentially withdraw more funds than should be permissible under certain conditions.",
        "file_name": "0x136e99a415957fc3f23e0a6885b22bcd0c475ab4.sol"
    },
    {
        "function_name": "addProposal",
        "code": "function addProposal (Subject _subject, string _reason) internal returns(uint256) { require(msg.value == proposalCostWei); require(DaicoPool(poolAddr).isStateProjectInProgress()); poolAddr.transfer(msg.value); Proposal memory proposal; proposal.subject = _subject; proposal.reason = _reason; proposal.start_time = block.timestamp; proposal.end_time = block.timestamp + VOTING_PERIOD; proposal.voter_count = 0; proposal.isFinalized = false; proposals.push(proposal); uint256 newID = proposals.length - 1; return newID; }",
        "vulnerability": "Insecure ether transfer without checks",
        "reason": "The function transfers ether without verifying the success of the transfer, which could lead to loss of ether if the transfer fails. Additionally, it assumes msg.value is always equal to proposalCostWei, which could be exploited if the cost changes.",
        "file_name": "0x136e99a415957fc3f23e0a6885b22bcd0c475ab4.sol"
    }
]