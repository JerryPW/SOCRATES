[
    {
        "function_name": "withdraw",
        "code": "function withdraw(bytes32 _secret, address _ownerAddress) public { Swap memory swap = swaps[_ownerAddress][msg.sender]; require(swap.secretHash == ripemd160(_secret)); require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) > now); ERC20(swap.token).transfer(swap.targetWallet, swap.balance); swaps[_ownerAddress][msg.sender].balance = 0; swaps[_ownerAddress][msg.sender].secret = _secret; Withdraw(msg.sender, _ownerAddress, now); }",
        "vulnerability": "No access control on withdraw",
        "reason": "The `withdraw` function lacks proper access control, allowing anyone with the correct secret to withdraw funds. This is problematic because if the secret is compromised or guessed, an attacker can withdraw funds intended for the participant.",
        "file_name": "0xd84b6aec4985e68ef5882de0b5d0b30992bb5057.sol"
    },
    {
        "function_name": "refund",
        "code": "function refund(address _participantAddress) public { Swap memory swap = swaps[msg.sender][_participantAddress]; require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) < now); ERC20(swap.token).transfer(msg.sender, swap.balance); clean(msg.sender, _participantAddress); Refund(); }",
        "vulnerability": "No access control on refund",
        "reason": "The `refund` function can be called by anyone who has set up a swap, allowing them to claim back their tokens if the `SafeTime` has passed, even if the counterparty is unavailable. This could potentially be exploited in a scenario where the initiator acts maliciously to prevent the transaction from completing.",
        "file_name": "0xd84b6aec4985e68ef5882de0b5d0b30992bb5057.sol"
    },
    {
        "function_name": "createSwap",
        "code": "function createSwap(bytes20 _secretHash, address _participantAddress, uint256 _value, address _token) public { require(_value > 0); require(swaps[msg.sender][_participantAddress].balance == uint256(0)); require(ERC20(_token).transferFrom(msg.sender, this, _value)); swaps[msg.sender][_participantAddress] = Swap( _token, _participantAddress, bytes32(0), _secretHash, now, _value ); CreateSwap(_token, _participantAddress, msg.sender, _value, _secretHash, now); }",
        "vulnerability": "Lack of validation on token address",
        "reason": "The `createSwap` function does not validate whether the `_token` address is a valid ERC20 token. This could lead to scenarios where invalid or malicious token contracts are used, potentially causing the swap to fail or behave unexpectedly.",
        "file_name": "0xd84b6aec4985e68ef5882de0b5d0b30992bb5057.sol"
    }
]