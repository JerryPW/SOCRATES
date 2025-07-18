[
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _amount) public onlyOwner { require(_amount > 0); uint256 amount = _amount; updateReleasedBalance(); uint256 available_balance = getAvailableBalance(); if (amount > available_balance) { amount = available_balance; } withdrawnBalance = withdrawnBalance.add(amount); owner.transfer(amount); emit WithdrawalHistory(\"ETH\", amount); }",
        "vulnerability": "Owner can withdraw beyond available balance",
        "reason": "The function does not adequately check whether the _amount parameter exceeds the available balance. Although the function attempts to limit the withdrawal to the available balance, the use of updateReleasedBalance() and getAvailableBalance() are not atomic operations with the transfer. This setup may allow the owner to withdraw more funds than intended if the state changes between the calls.",
        "file_name": "0x136e99a415957fc3f23e0a6885b22bcd0c475ab4.sol"
    },
    {
        "function_name": "selfDestruction",
        "code": "function selfDestruction() external onlyVoting { status = Status.Destructed; updateReleasedBalance(); releasedBalance = releasedBalance.add(closingRelease.mul(tap)); updateTap(0); uint256 _totalSupply = ERC20Interface(votingTokenAddr).totalSupply(); refundRateNano = address(this).balance.sub(getAvailableBalance()).mul(10**9).div(_totalSupply); }",
        "vulnerability": "Incorrect refund rate calculation",
        "reason": "The function calculates refundRateNano using address(this).balance.sub(getAvailableBalance()). This calculation can result in negative values or incorrect refund rates if getAvailableBalance() returns a value greater than address(this).balance due to race conditions or reentrancy issues.",
        "file_name": "0x136e99a415957fc3f23e0a6885b22bcd0c475ab4.sol"
    },
    {
        "function_name": "vote",
        "code": "function vote (bool agree, uint256 amount) external { require(ERC20Interface(votingTokenAddr).transferFrom(msg.sender, this, amount)); uint256 pid = this.getCurrentVoting(); require(pid != PROPOSAL_EMPTY); require(proposals[pid].start_time <= block.timestamp); require(proposals[pid].end_time >= block.timestamp); if (deposits[pid][msg.sender] == 0) { proposals[pid].voter_count = proposals[pid].voter_count.add(1); } deposits[pid][msg.sender] = deposits[pid][msg.sender].add(amount); proposals[pid].votes[agree] = proposals[pid].votes[agree].add(amount); emit Vote(msg.sender, amount); }",
        "vulnerability": "No check on double voting",
        "reason": "The function allows users to vote multiple times by transferring tokens again. The deposits and votes are simply incremented, allowing a single address to cast multiple votes if they transfer additional tokens, which could lead to skewed voting results.",
        "file_name": "0x136e99a415957fc3f23e0a6885b22bcd0c475ab4.sol"
    }
]