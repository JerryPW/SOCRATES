[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) { if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to].add(_value) > balances[_to]) { balances[_to] = _value.add(balances[_to]); balances[_from] = balances[_from].sub(_value); allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); emit Transfer(_from, _to, _value); return true; } else { return false; } }",
        "vulnerability": "Missing zero-value check in allowance",
        "reason": "The `transferFrom` function does not properly check if the allowance is non-zero before performing a transfer, which can lead to the 'approve/transferFrom' race condition. An attacker can exploit this by front-running a transaction that changes the allowance, causing unexpected token transfers.",
        "file_name": "0x8c73696a453f67ea5b7e5f2cd58ca0ad72ecaaeb.sol"
    },
    {
        "function_name": "deposit",
        "code": "function deposit(address _userAddress, uint256 _amount, uint256 _days) public ownerOnly { require(_amount > 0); require(md.transferFrom(_userAddress, this, _amount)); uint256 releaseTime = block.timestamp + _days * 1 days; LockRecord memory r = LockRecord(_userAddress, _amount, releaseTime); uint256 l = lockRecords.push(r); emit Deposit(_userAddress, _amount, releaseTime, l.sub(1)); }",
        "vulnerability": "Lack of check for `_days` overflow",
        "reason": "The `_days` parameter is used to calculate the `releaseTime` without checking for overflow. If `_days` is sufficiently large, it can cause the `releaseTime` to overflow and become a past timestamp, allowing immediate release of funds that should be locked.",
        "file_name": "0x8c73696a453f67ea5b7e5f2cd58ca0ad72ecaaeb.sol"
    },
    {
        "function_name": "kill",
        "code": "function kill() public ownerOnly { md.transfer(owner, getContractBalance()); selfdestruct(owner); }",
        "vulnerability": "Potential loss of tokens during self-destruct",
        "reason": "The `kill` function transfers the balance of the `TokenLock` contract to the owner before calling `selfdestruct`. If the transfer fails (e.g., due to insufficient gas or a fallback function that reverts), tokens in the `TokenLock` contract will be permanently lost upon self-destruction.",
        "file_name": "0x8c73696a453f67ea5b7e5f2cd58ca0ad72ecaaeb.sol"
    }
]