[
    {
        "function_name": "withdrawNoMoney",
        "code": "function withdrawNoMoney(bytes32 _secret, address participantAddress) public { Swap memory swap = swaps[msg.sender][participantAddress]; require(swap.secretHash == ripemd160(_secret)); require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) > now); ERC20(swap.token).transfer(swap.targetWallet, swap.balance); swaps[msg.sender][participantAddress].balance = 0; swaps[msg.sender][participantAddress].secret = _secret; Withdraw(participantAddress, msg.sender, now); }",
        "vulnerability": "Incorrect participant address verification",
        "reason": "The function uses the msg.sender as the owner of the swap, which can be exploited by an attacker to withdraw funds from any swap they did not initiate. Since the participant address is an input to the function, an attacker can specify any participant address where msg.sender is the owner, allowing them to steal funds.",
        "file_name": "0xd84b6aec4985e68ef5882de0b5d0b30992bb5057.sol"
    },
    {
        "function_name": "withdrawOther",
        "code": "function withdrawOther(bytes32 _secret, address _ownerAddress, address participantAddress) public { Swap memory swap = swaps[_ownerAddress][participantAddress]; require(swap.secretHash == ripemd160(_secret)); require(swap.balance > uint256(0)); require(swap.createdAt.add(SafeTime) > now); ERC20(swap.token).transfer(swap.targetWallet, swap.balance); swaps[_ownerAddress][participantAddress].balance = 0; swaps[_ownerAddress][participantAddress].secret = _secret; Withdraw(participantAddress, _ownerAddress, now); }",
        "vulnerability": "No access control for withdrawal",
        "reason": "This function allows any user to withdraw funds from swaps they are not involved in, as long as they know the secret. There is no restriction on who can call this function, making it possible for an attacker who knows the secret to steal funds from any swap.",
        "file_name": "0xd84b6aec4985e68ef5882de0b5d0b30992bb5057.sol"
    },
    {
        "function_name": "getSecret",
        "code": "function getSecret(address _participantAddress) public view returns (bytes32) { return swaps[msg.sender][_participantAddress].secret; }",
        "vulnerability": "Disclosure of secret",
        "reason": "This function allows anyone to view the secret of a swap they initiated by providing the participant's address. If the balance is not yet zero, it enables an attacker to discover the secret and use it to withdraw funds prematurely, as the secret is central to authorizing withdrawals.",
        "file_name": "0xd84b6aec4985e68ef5882de0b5d0b30992bb5057.sol"
    }
]