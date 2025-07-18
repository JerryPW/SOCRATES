[
    {
        "function_name": "withdraw",
        "code": "function withdraw(bytes32 _secret, address _ownerAddress) public { Swap memory swap = swaps[_ownerAddress][msg.sender]; require(swap.secretHash == ripemd160(_secret)); require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) > now); ERC20(swap.token).transfer(swap.targetWallet, swap.balance); swaps[_ownerAddress][msg.sender].balance = 0; swaps[_ownerAddress][msg.sender].secret = _secret; Withdraw(); }",
        "vulnerability": "Lack of authorization in withdraw function",
        "reason": "The withdraw function does not check that the caller is authorized to complete the swap. Anyone who knows the secret can complete the swap as long as they are the participant, which is a critical security oversight as it allows unauthorized users to withdraw funds.",
        "file_name": "0x30f85ebcfac9f6dd69503955e95ab7f55fa3fdec.sol"
    },
    {
        "function_name": "withdrawNoMoney",
        "code": "function withdrawNoMoney(bytes32 _secret, address participantAddress) public { Swap memory swap = swaps[msg.sender][participantAddress]; require(swap.secretHash == ripemd160(_secret)); require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) > now); ERC20(swap.token).transfer(swap.targetWallet, swap.balance); swaps[msg.sender][participantAddress].balance = 0; swaps[msg.sender][participantAddress].secret = _secret; Withdraw(); }",
        "vulnerability": "Potential reentrancy attack in withdrawNoMoney",
        "reason": "The withdrawNoMoney function calls an external contract (ERC20 transfer) before resetting the balance, which may allow a reentrancy attack if the ERC20 token fallback function calls back into withdrawNoMoney.",
        "file_name": "0x30f85ebcfac9f6dd69503955e95ab7f55fa3fdec.sol"
    },
    {
        "function_name": "createSwap",
        "code": "function createSwap(bytes20 _secretHash, address _participantAddress, uint256 _value, address _token) public { require(_value > 0); require(swaps[msg.sender][_participantAddress].balance == uint256(0)); require(ERC20(_token).transferFrom(msg.sender, this, _value)); swaps[msg.sender][_participantAddress] = Swap( _token, _participantAddress, bytes32(0), _secretHash, now, _value ); CreateSwap(now); }",
        "vulnerability": "Potential denial of service in createSwap",
        "reason": "If the ERC20 transferFrom call fails for any reason (such as the sender not having enough tokens or not having approved the contract to spend their tokens), the transaction will revert, which is expected. However, an attacker can create a situation where the swap is never successfully created for a participant, leading to a denial of service for that participant.",
        "file_name": "0x30f85ebcfac9f6dd69503955e95ab7f55fa3fdec.sol"
    }
]