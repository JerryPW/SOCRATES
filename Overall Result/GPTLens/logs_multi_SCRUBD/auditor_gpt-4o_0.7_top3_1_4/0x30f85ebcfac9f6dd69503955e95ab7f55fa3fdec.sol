[
    {
        "function_name": "createSwap",
        "code": "function createSwap(bytes20 _secretHash, address _participantAddress, uint256 _value, address _token) public { require(_value > 0); require(swaps[msg.sender][_participantAddress].balance == uint256(0)); require(ERC20(_token).transferFrom(msg.sender, this, _value)); swaps[msg.sender][_participantAddress] = Swap( _token, _participantAddress, bytes32(0), _secretHash, now, _value ); CreateSwap(now); }",
        "vulnerability": "ERC20 token handling vulnerability",
        "reason": "The function assumes that the ERC20 token's transferFrom function will revert on failure, but not all tokens follow this convention. If the token does not revert, the contract could end up in an inconsistent state where it believes it has received tokens when it has not, leading to potential loss of funds.",
        "file_name": "0x30f85ebcfac9f6dd69503955e95ab7f55fa3fdec.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(bytes32 _secret, address _ownerAddress) public { Swap memory swap = swaps[_ownerAddress][msg.sender]; require(swap.secretHash == ripemd160(_secret)); require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) > now); ERC20(swap.token).transfer(swap.targetWallet, swap.balance); swaps[_ownerAddress][msg.sender].balance = 0; swaps[_ownerAddress][msg.sender].secret = _secret; Withdraw(); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function transfers tokens before updating the contract's state variables. An attacker could exploit this by calling back into the contract using a malicious token contract, causing unexpected behavior and potentially draining funds.",
        "file_name": "0x30f85ebcfac9f6dd69503955e95ab7f55fa3fdec.sol"
    },
    {
        "function_name": "withdrawNoMoney",
        "code": "function withdrawNoMoney(bytes32 _secret, address participantAddress) public { Swap memory swap = swaps[msg.sender][participantAddress]; require(swap.secretHash == ripemd160(_secret)); require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) > now); ERC20(swap.token).transfer(swap.targetWallet, swap.balance); swaps[msg.sender][participantAddress].balance = 0; swaps[msg.sender][participantAddress].secret = _secret; Withdraw(); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "Similar to the withdraw function, this function also performs the token transfer before updating the contract's state variables, making it susceptible to reentrancy attacks.",
        "file_name": "0x30f85ebcfac9f6dd69503955e95ab7f55fa3fdec.sol"
    }
]