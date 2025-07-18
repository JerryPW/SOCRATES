[
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _value) public returns (bool) { allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; }",
        "vulnerability": "race condition (ERC20 approve vulnerability)",
        "reason": "The approve function allows setting an allowance directly, which can lead to a race condition where an allowance is spent and then reset before both actions are completed. This is a well-known vulnerability in the ERC20 standard where a spender can potentially spend both the old and new allowance.",
        "file_name": "0xc64fd3ff188c4f1f1e34bbff54f67d8c88175696.sol"
    },
    {
        "function_name": "withdrawRejected",
        "code": "function withdrawRejected() external { uint value = etherRejected[msg.sender]; etherRejected[msg.sender] = 0; (msg.sender).transfer(value); emit RejectedWithdrawn(msg.sender, value); }",
        "vulnerability": "reentrancy vulnerability",
        "reason": "The withdrawRejected function is vulnerable to reentrancy attacks because it transfers ether to msg.sender before resetting etherRejected[msg.sender]. This allows an attacker to recursively call the function before the balance is set to zero, effectively draining the contract.",
        "file_name": "0xc64fd3ff188c4f1f1e34bbff54f67d8c88175696.sol"
    },
    {
        "function_name": "transfer",
        "code": "function transfer(address _to, uint256 _value) public returns (bool) { require(mintingFinished == true); return super.transfer(_to, _value); }",
        "vulnerability": "locked token transfer",
        "reason": "The transfer function in the CrowdfundableToken contract requires that minting is finished before allowing token transfers. If minting is never finished due to an oversight or intentional withholding, it effectively locks the tokens and prevents any transfers, which can be detrimental to token holders.",
        "file_name": "0xc64fd3ff188c4f1f1e34bbff54f67d8c88175696.sol"
    }
]