[
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _amount) public onlyOwner { require(_amount > 0); uint256 amount = _amount; updateReleasedBalance(); uint256 available_balance = getAvailableBalance(); if (amount > available_balance) { amount = available_balance; } withdrawnBalance = withdrawnBalance.add(amount); owner.transfer(amount); emit WithdrawalHistory(\"ETH\", amount); }",
        "vulnerability": "Unrestricted Ether Withdrawal",
        "reason": "The withdraw function allows the owner to withdraw funds without any limit checks beyond the available balance. This function is vulnerable to misuse if the owner becomes malicious or if the owner's private key is compromised. An attacker could exploit this to drain the contract's funds.",
        "file_name": "0x136e99a415957fc3f23e0a6885b22bcd0c475ab4.sol"
    },
    {
        "function_name": "selfDestruction",
        "code": "function selfDestruction() external onlyVoting { status = Status.Destructed; updateReleasedBalance(); releasedBalance = releasedBalance.add(closingRelease.mul(tap)); updateTap(0); uint256 _totalSupply = ERC20Interface(votingTokenAddr).totalSupply(); refundRateNano = address(this).balance.sub(getAvailableBalance()).mul(10**9).div(_totalSupply); }",
        "vulnerability": "Potential for Incorrect Ether Distribution",
        "reason": "The selfDestruction function calculates the refund rate based on the current balance and total supply of tokens, but if there are discrepancies in the token supply or if the balance has been manipulated prior, it could lead to incorrect calculations and unfair distribution of refunds.",
        "file_name": "0x136e99a415957fc3f23e0a6885b22bcd0c475ab4.sol"
    },
    {
        "function_name": "returnToken",
        "code": "function returnToken (address account) external returns(bool) { uint256 amount = 0; for (uint256 pid = 0; pid < proposals.length; pid++) { if(!proposals[pid].isFinalized){ break; } amount = amount.add(deposits[pid][account]); deposits[pid][account] = 0; } if(amount <= 0){ return false; } require(ERC20Interface(votingTokenAddr).transfer(account, amount)); emit ReturnDeposit(account, amount); return true; }",
        "vulnerability": "Reentrancy Risk",
        "reason": "The returnToken function transfers tokens to the account after modifying the deposits mapping. This could be exploited in a reentrancy attack where a malicious contract repeatedly calls returnToken before the state is fully updated, potentially withdrawing more tokens than intended.",
        "file_name": "0x136e99a415957fc3f23e0a6885b22bcd0c475ab4.sol"
    }
]