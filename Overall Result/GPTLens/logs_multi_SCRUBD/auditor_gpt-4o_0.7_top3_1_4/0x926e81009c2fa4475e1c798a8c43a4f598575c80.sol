[
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _value) returns (bool success) { allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; }",
        "vulnerability": "Race condition vulnerability",
        "reason": "The approve function is vulnerable to the well-known ERC20 race condition attack. If a user wants to change the allowance given to a spender, the spender can potentially use both the old and new allowance in a race condition. This can lead to the spender transferring more tokens than intended by the owner. It's recommended to either set the allowance to 0 first and then set it again, or use the newer approach of increase/decrease allowance.",
        "file_name": "0x926e81009c2fa4475e1c798a8c43a4f598575c80.sol"
    },
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address _from, address _to, uint256 _value) returns(bool){ require(balances[_from] >= _value); require(allowed[_from][msg.sender] >= _value); require(balances[_to] + _value > balances[_to]); balances[_to] = safeAdd(balances[_to],_value); balances[_from] = safeSub(balances[_from],_value); allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value); Transfer(_from, _to, _value); return true; }",
        "vulnerability": "Integer overflow/underflow on balance and allowance",
        "reason": "The function does not use safe math operations for checking and updating balances and allowances, which makes it susceptible to integer overflow or underflow attacks. For example, if `balances[_to] + _value` overflows, it can cause a balance to be far less than intended. Although Solidity 0.4.16 does not have built-in overflow checks, using an unchecked addition here can still lead to unexpected behavior.",
        "file_name": "0x926e81009c2fa4475e1c798a8c43a4f598575c80.sol"
    },
    {
        "function_name": "withdrawTokens",
        "code": "function withdrawTokens() public { uint64 oneYearPassed = icoIsFinishedDate + 365 days; require(uint(now) >= oneYearPassed); uint total = mntToken.balanceOf(this); mntToken.transfer(teamAccountAddress,total); }",
        "vulnerability": "Potential reentrancy attack",
        "reason": "The withdrawTokens function sends all tokens to the teamAccountAddress without updating any state variables before the transfer. This could potentially allow for a reentrancy attack if the teamAccountAddress is a contract that calls back into this function or other related functions before the state is correctly updated. It is recommended to update state variables before making any external calls, or using the checks-effects-interactions pattern.",
        "file_name": "0x926e81009c2fa4475e1c798a8c43a4f598575c80.sol"
    }
]