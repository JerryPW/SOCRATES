[
    {
        "function_name": "createSwap",
        "code": "function createSwap(bytes20 _secretHash, address _participantAddress, uint256 _value, address _token) public { require(_value > 0); require(swaps[msg.sender][_participantAddress].balance == uint256(0)); require(ERC20(_token).transferFrom(msg.sender, this, _value)); swaps[msg.sender][_participantAddress] = Swap( _token, _participantAddress, bytes32(0), _secretHash, now, _value ); CreateSwap(now); }",
        "vulnerability": "Incorrect approval model",
        "reason": "The function relies on ERC20 tokens being approved for transfer using transferFrom, but it does not handle the case where the token owner has not approved the contract to spend tokens. This could lead to a situation where the function call fails, locking any further operations that depend on this transaction.",
        "file_name": "0x30f85ebcfac9f6dd69503955e95ab7f55fa3fdec.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(bytes32 _secret, address _ownerAddress) public { Swap memory swap = swaps[_ownerAddress][msg.sender]; require(swap.secretHash == ripemd160(_secret)); require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) > now); ERC20(swap.token).transfer(swap.targetWallet, swap.balance); swaps[_ownerAddress][msg.sender].balance = 0; swaps[_ownerAddress][msg.sender].secret = _secret; Withdraw(); }",
        "vulnerability": "Time-dependent reentrancy",
        "reason": "The function is vulnerable to reentrancy attacks due to the external call to the token's transfer function before the balance is set to zero. An attacker could use a malicious token contract to re-enter the withdraw function before the balance is set to zero, allowing them to drain the contract.",
        "file_name": "0x30f85ebcfac9f6dd69503955e95ab7f55fa3fdec.sol"
    },
    {
        "function_name": "refund",
        "code": "function refund(address _participantAddress) public { Swap memory swap = swaps[msg.sender][_participantAddress]; require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) < now); ERC20(swap.token).transfer(msg.sender, swap.balance); clean(msg.sender, _participantAddress); Refund(); }",
        "vulnerability": "Lack of reentrancy protection",
        "reason": "Similar to the withdraw function, refund is also vulnerable to reentrancy attacks. The external call to the token's transfer function is executed before the balance is cleared, which could allow an attacker to perform a reentrant call and claim multiple refunds.",
        "file_name": "0x30f85ebcfac9f6dd69503955e95ab7f55fa3fdec.sol"
    }
]