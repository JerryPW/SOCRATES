[
    {
        "function_name": "withdraw",
        "code": "function withdraw(bytes32 _secret, address _ownerAddress) public { Swap memory swap = swaps[_ownerAddress][msg.sender]; require(swap.secretHash == ripemd160(_secret)); require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) > now); ERC20(swap.token).transfer(swap.targetWallet, swap.balance); swaps[_ownerAddress][msg.sender].balance = 0; swaps[_ownerAddress][msg.sender].secret = _secret; Withdraw(msg.sender, _ownerAddress, now); }",
        "vulnerability": "Replay Attack",
        "reason": "The withdraw function does not delete the swap after a successful withdrawal. This allows an attacker to reuse the same secret to withdraw funds multiple times if the balance is not properly set to zero or if the swap is not cleaned up. This can lead to theft of funds from the contract.",
        "file_name": "0xd84b6aec4985e68ef5882de0b5d0b30992bb5057.sol"
    },
    {
        "function_name": "createSwap",
        "code": "function createSwap(bytes20 _secretHash, address _participantAddress, uint256 _value, address _token) public { require(_value > 0); require(swaps[msg.sender][_participantAddress].balance == uint256(0)); require(ERC20(_token).transferFrom(msg.sender, this, _value)); swaps[msg.sender][_participantAddress] = Swap( _token, _participantAddress, bytes32(0), _secretHash, now, _value ); CreateSwap(_token, _participantAddress, msg.sender, _value, _secretHash, now); }",
        "vulnerability": "Lack of Approval Check",
        "reason": "The createSwap function assumes that the transferFrom call will succeed without verifying if the token owner has approved the contract to spend their tokens. If the approval is not given, this will cause the function to revert, leading to a denial of service for valid swap attempts.",
        "file_name": "0xd84b6aec4985e68ef5882de0b5d0b30992bb5057.sol"
    },
    {
        "function_name": "refund",
        "code": "function refund(address _participantAddress) public { Swap memory swap = swaps[msg.sender][_participantAddress]; require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) < now); ERC20(swap.token).transfer(msg.sender, swap.balance); clean(msg.sender, _participantAddress); Refund(); }",
        "vulnerability": "Potential Race Condition",
        "reason": "The refund function first transfers the tokens and then deletes the swap entry. If an attacker can call another function that modifies the swap after the transfer but before the deletion, it could result in inconsistent state or improper handling of the swap data.",
        "file_name": "0xd84b6aec4985e68ef5882de0b5d0b30992bb5057.sol"
    }
]