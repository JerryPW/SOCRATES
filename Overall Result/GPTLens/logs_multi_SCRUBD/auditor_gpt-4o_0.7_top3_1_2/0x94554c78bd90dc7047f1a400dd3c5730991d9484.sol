[
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _value) public returns (bool) { allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; }",
        "vulnerability": "Race condition vulnerability with approvals",
        "reason": "The approve function allows setting an allowance for a spender without any checks for race conditions. A malicious spender can exploit this by quickly spending the old allowance before the new one is set, potentially leading to a situation where the spender can spend more than intended.",
        "file_name": "0x94554c78bd90dc7047f1a400dd3c5730991d9484.sol"
    },
    {
        "function_name": "withdrawEth",
        "code": "function withdrawEth() public { require(this.balance != 0); require(state == SaleState.ENDED); require(msg.sender == wallet); require(tokensTransferredToHold == true); uint bal = this.balance; wallet.transfer(bal); WithdrawedEthToWallet(bal); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function transfers Ether before setting the balance to zero or marking the withdrawal as complete. This can be exploited in a reentrancy attack where the attacker repeatedly calls the function before the balance updates, allowing them to drain all the Ether.",
        "file_name": "0x94554c78bd90dc7047f1a400dd3c5730991d9484.sol"
    },
    {
        "function_name": "unlockTokens",
        "code": "function unlockTokens() external { address contributor = msg.sender; if (holderList[contributor].isActive && !holderList[contributor].withdrawed) { if (now >= holderList[contributor].holdPeriodTimestamp) { if ( OppToken.transfer( msg.sender, holderList[contributor].tokens ) ) { holderList[contributor].withdrawed = true; TokensTransfered(contributor, holderList[contributor].tokens); } } else { revert(); } } else { revert(); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The unlockTokens function transfers tokens before marking the holder as 'withdrawed'. This can be exploited using a reentrancy attack, where the attacker calls this function repeatedly in a malicious contract to unlock tokens multiple times before the contract state is updated.",
        "file_name": "0x94554c78bd90dc7047f1a400dd3c5730991d9484.sol"
    }
]