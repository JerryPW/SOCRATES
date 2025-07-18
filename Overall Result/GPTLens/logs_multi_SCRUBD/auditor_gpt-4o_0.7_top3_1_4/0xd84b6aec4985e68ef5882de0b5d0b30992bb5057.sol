[
    {
        "function_name": "withdraw",
        "code": "function withdraw(bytes32 _secret, address _ownerAddress) public { Swap memory swap = swaps[_ownerAddress][msg.sender]; require(swap.secretHash == ripemd160(_secret)); require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) > now); ERC20(swap.token).transfer(swap.targetWallet, swap.balance); swaps[_ownerAddress][msg.sender].balance = 0; swaps[_ownerAddress][msg.sender].secret = _secret; Withdraw(msg.sender, _ownerAddress, now); }",
        "vulnerability": "Pre-image Attack Vulnerability",
        "reason": "The function relies on a pre-image of a hash (ripemd160) for authentication, which can be vulnerable if the secret is not sufficiently random or long. An attacker with enough computational resources could potentially find a correct pre-image for the hash and withdraw funds.",
        "file_name": "0xd84b6aec4985e68ef5882de0b5d0b30992bb5057.sol"
    },
    {
        "function_name": "refund",
        "code": "function refund(address _participantAddress) public { Swap memory swap = swaps[msg.sender][_participantAddress]; require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) < now); ERC20(swap.token).transfer(msg.sender, swap.balance); clean(msg.sender, _participantAddress); Refund(); }",
        "vulnerability": "Potential Denial of Service (DoS)",
        "reason": "If the ERC20 token contract does not return true or reverts (as some token contracts might not strictly follow the ERC20 standard), the transfer call might fail and cause a DoS for any subsequent refund attempts.",
        "file_name": "0xd84b6aec4985e68ef5882de0b5d0b30992bb5057.sol"
    },
    {
        "function_name": "createSwap",
        "code": "function createSwap(bytes20 _secretHash, address _participantAddress, uint256 _value, address _token) public { require(_value > 0); require(swaps[msg.sender][_participantAddress].balance == uint256(0)); require(ERC20(_token).transferFrom(msg.sender, this, _value)); swaps[msg.sender][_participantAddress] = Swap( _token, _participantAddress, bytes32(0), _secretHash, now, _value ); CreateSwap(_token, _participantAddress, msg.sender, _value, _secretHash, now); }",
        "vulnerability": "Token Transfer Check Vulnerability",
        "reason": "The function does not properly check the result of the transferFrom call. If the token does not return a boolean indicating success, the contract will assume the transfer was successful even if it was not, leading to potential discrepancies in balances.",
        "file_name": "0xd84b6aec4985e68ef5882de0b5d0b30992bb5057.sol"
    }
]