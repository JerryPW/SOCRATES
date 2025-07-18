[
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _value) public returns (bool) { allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; }",
        "vulnerability": "Race Condition (ERC20 Approve/TransferFrom)",
        "reason": "The approve function is susceptible to the well-known race condition where a spender could potentially drain funds if the allowance is reset. This occurs when a spender gets approval, spends the tokens, and then the owner resets the allowance without first setting it to zero, allowing the spender to spend more tokens.",
        "file_name": "0xc64fd3ff188c4f1f1e34bbff54f67d8c88175696.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address newOwner) public onlyOwner { require(newOwner != address(0)); OwnershipTransferred(owner, newOwner); owner = newOwner; }",
        "vulnerability": "Ownership Transfer to Zero Address",
        "reason": "Although the function checks that the newOwner is not the zero address, there's no mechanism to prevent improper access control if the check is bypassed in the future or if the newOwner is set to an unintended address due to a front-running attack. This could lead to loss of control over the contract.",
        "file_name": "0xc64fd3ff188c4f1f1e34bbff54f67d8c88175696.sol"
    },
    {
        "function_name": "withdrawRejected",
        "code": "function withdrawRejected() external { uint value = etherRejected[msg.sender]; etherRejected[msg.sender] = 0; (msg.sender).transfer(value); emit RejectedWithdrawn(msg.sender, value); }",
        "vulnerability": "Reentrancy Attack",
        "reason": "The withdrawRejected function is vulnerable to reentrancy because it transfers Ether to the caller before setting the etherRejected balance to zero. An attacker could exploit this by calling the function recursively before the state update, allowing them to withdraw more funds than they're entitled to.",
        "file_name": "0xc64fd3ff188c4f1f1e34bbff54f67d8c88175696.sol"
    }
]