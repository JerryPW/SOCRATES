[
    {
        "function_name": "withdraw",
        "code": "function withdraw(bytes32 _secret, address _ownerAddress) public { Swap memory swap = swaps[_ownerAddress][msg.sender]; require(swap.secretHash == ripemd160(_secret)); require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) > now); ERC20(swap.token).transfer(swap.targetWallet, swap.balance); swaps[_ownerAddress][msg.sender].balance = 0; swaps[_ownerAddress][msg.sender].secret = _secret; Withdraw(); }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The 'withdraw' function transfers tokens before updating the swap state. An attacker can exploit this by re-entering the function through a fallback function in the target contract, allowing multiple withdrawals before the balance is zeroed.",
        "file_name": "0x30f85ebcfac9f6dd69503955e95ab7f55fa3fdec.sol"
    },
    {
        "function_name": "withdrawNoMoney",
        "code": "function withdrawNoMoney(bytes32 _secret, address participantAddress) public { Swap memory swap = swaps[msg.sender][participantAddress]; require(swap.secretHash == ripemd160(_secret)); require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) > now); ERC20(swap.token).transfer(swap.targetWallet, swap.balance); swaps[msg.sender][participantAddress].balance = 0; swaps[msg.sender][participantAddress].secret = _secret; Withdraw(); }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "Similar to the 'withdraw' function, 'withdrawNoMoney' transfers tokens before updating the swap state, leaving it vulnerable to reentrancy attacks where the balance can be drained by re-entering the function.",
        "file_name": "0x30f85ebcfac9f6dd69503955e95ab7f55fa3fdec.sol"
    },
    {
        "function_name": "refund",
        "code": "function refund(address _participantAddress) public { Swap memory swap = swaps[msg.sender][_participantAddress]; require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) < now); ERC20(swap.token).transfer(msg.sender, swap.balance); clean(msg.sender, _participantAddress); Refund(); }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The 'refund' function allows token transfers before the swap state is cleaned. An attacker can exploit this by re-entering the refund process to obtain multiple refunds before the swap is deleted.",
        "file_name": "0x30f85ebcfac9f6dd69503955e95ab7f55fa3fdec.sol"
    }
]