[
    {
        "function_name": "withdraw",
        "code": "function withdraw(bytes32 _secret, address _ownerAddress) public { Swap memory swap = swaps[_ownerAddress][msg.sender]; require(swap.secretHash == ripemd160(_secret)); require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) > now); ERC20(swap.token).transfer(swap.targetWallet, swap.balance); swaps[_ownerAddress][msg.sender].balance = 0; swaps[_ownerAddress][msg.sender].secret = _secret; Withdraw(); }",
        "vulnerability": "Lack of reentrancy protection",
        "reason": "The `withdraw` function transfers tokens to the target wallet before setting the swap balance to zero. This allows for a potential reentrancy attack where an attacker can repeatedly call `withdraw` before the balance is set to zero, withdrawing more tokens than intended.",
        "file_name": "0x30f85ebcfac9f6dd69503955e95ab7f55fa3fdec.sol"
    },
    {
        "function_name": "withdrawNoMoney",
        "code": "function withdrawNoMoney(bytes32 _secret, address participantAddress) public { Swap memory swap = swaps[msg.sender][participantAddress]; require(swap.secretHash == ripemd160(_secret)); require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) > now); ERC20(swap.token).transfer(swap.targetWallet, swap.balance); swaps[msg.sender][participantAddress].balance = 0; swaps[msg.sender][participantAddress].secret = _secret; Withdraw(); }",
        "vulnerability": "Lack of reentrancy protection",
        "reason": "Similar to the `withdraw` function, `withdrawNoMoney` transfers tokens before setting the swap balance to zero. This can be exploited by reentrancy attacks to drain tokens by repeatedly calling the function before the balance update.",
        "file_name": "0x30f85ebcfac9f6dd69503955e95ab7f55fa3fdec.sol"
    },
    {
        "function_name": "refund",
        "code": "function refund(address _participantAddress) public { Swap memory swap = swaps[msg.sender][_participantAddress]; require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) < now); ERC20(swap.token).transfer(msg.sender, swap.balance); clean(msg.sender, _participantAddress); Refund(); }",
        "vulnerability": "Improper order of operations",
        "reason": "The `refund` function transfers tokens back to the caller before deleting the swap record. If the token contract is malicious or allows reentrancy, this could lead to inconsistencies or double refunds.",
        "file_name": "0x30f85ebcfac9f6dd69503955e95ab7f55fa3fdec.sol"
    }
]