[
    {
        "function_name": "withdraw",
        "code": "function withdraw(bytes32 _secret, address _ownerAddress) public { Swap memory swap = swaps[_ownerAddress][msg.sender]; require(swap.secretHash == ripemd160(_secret)); require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) > now); ERC20(swap.token).transfer(swap.targetWallet, swap.balance); swaps[_ownerAddress][msg.sender].balance = 0; swaps[_ownerAddress][msg.sender].secret = _secret; Withdraw(msg.sender, _ownerAddress, now); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function first transfers tokens to the target wallet and then sets the swap balance to zero. An attacker can exploit this by calling the function recursively before the balance is set to zero, allowing them to withdraw tokens multiple times.",
        "file_name": "0xd84b6aec4985e68ef5882de0b5d0b30992bb5057.sol"
    },
    {
        "function_name": "withdrawNoMoney",
        "code": "function withdrawNoMoney(bytes32 _secret, address participantAddress) public { Swap memory swap = swaps[msg.sender][participantAddress]; require(swap.secretHash == ripemd160(_secret)); require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) > now); ERC20(swap.token).transfer(swap.targetWallet, swap.balance); swaps[msg.sender][participantAddress].balance = 0; swaps[msg.sender][participantAddress].secret = _secret; Withdraw(participantAddress, msg.sender, now); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "Similar to the 'withdraw' function, this function also transfers tokens before setting the balance to zero. An attacker can recursively call this function to exploit the timing and withdraw tokens multiple times.",
        "file_name": "0xd84b6aec4985e68ef5882de0b5d0b30992bb5057.sol"
    },
    {
        "function_name": "createSwap",
        "code": "function createSwap(bytes20 _secretHash, address _participantAddress, uint256 _value, address _token) public { require(_value > 0); require(swaps[msg.sender][_participantAddress].balance == uint256(0)); require(ERC20(_token).transferFrom(msg.sender, this, _value)); swaps[msg.sender][_participantAddress] = Swap( _token, _participantAddress, bytes32(0), _secretHash, now, _value ); CreateSwap(_token, _participantAddress, msg.sender, _value, _secretHash, now); }",
        "vulnerability": "Lack of input validation",
        "reason": "The 'createSwap' function does not validate the '_token' address. An attacker can provide an incorrect or malicious token address which could lead to unexpected behavior or loss of funds.",
        "file_name": "0xd84b6aec4985e68ef5882de0b5d0b30992bb5057.sol"
    }
]