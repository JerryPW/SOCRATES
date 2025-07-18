[
    {
        "function_name": "withdraw",
        "code": "function withdraw(address _token, uint _amount) public onlyAdmin returns (bool _success) { _success = false; if (_token == address (0)) { uint weiAmount = _amount; if (weiAmount > address(this).balance) { return false; } _success = receiver.send(weiAmount); } else { Token __token = Token(_token); uint amount = _amount; if (amount > __token.balanceOf(this)) { return false; } _success = __token.transfer(receiver, amount); } if (_success) { emit Withdrawal(_token, _amount); } }",
        "vulnerability": "Unsafe use of send",
        "reason": "The use of the `send` function for transferring Ether is risky because it only forwards 2300 gas, limiting the execution of the receiving contract\u2019s fallback function. If the call fails, the function does not revert the transaction, which can lead to inconsistencies in the contract state. Instead, it should use the `transfer` or `call` method with proper handling of the success status.",
        "file_name": "0x88355a32a8c5cc399aa09b9d21ebcba935ae5d2f.sol"
    },
    {
        "function_name": "fund",
        "code": "function fund(address _address, uint _amount) public onlyAuthorized returns (bool _success) { require(_amount <= maxFundAmount); _success = _address.send(_amount); if (_success) { emit Fund(_address, _amount); } }",
        "vulnerability": "Potential reentrancy attack",
        "reason": "The `fund` function uses the `send` method to transfer Ether, which allows for a potential reentrancy attack. The function does not employ any mechanisms to mitigate reentrancy, such as using the checks-effects-interactions pattern or a reentrancy guard, which can lead to the attacker repeatedly calling the function and draining the contract of funds.",
        "file_name": "0x88355a32a8c5cc399aa09b9d21ebcba935ae5d2f.sol"
    },
    {
        "function_name": "setCasinoContract",
        "code": "function setCasinoContract(address _casino) public onlyAdmin { edgelessCasino = _casino; _approveForCasino(_casino, 1000000000); }",
        "vulnerability": "Unrestricted approval amount",
        "reason": "The `_approveForCasino` function is called with a hardcoded, extremely large approval amount (1 billion tokens), which can lead to unexpected behavior and potential token loss if the new casino contract is malicious or exploited. This can be exploited by the new contract to transfer a large amount of tokens without proper checks.",
        "file_name": "0x88355a32a8c5cc399aa09b9d21ebcba935ae5d2f.sol"
    }
]