[
    {
        "function_name": "withdraw",
        "code": "function withdraw(address _token, uint _amount) public onlyAdmin returns (bool _success) { _success = false; if (_token == address (0)) { uint weiAmount = _amount; if (weiAmount > address(this).balance) { return false; } _success = receiver.send(weiAmount); } else { Token __token = Token(_token); uint amount = _amount; if (amount > __token.balanceOf(this)) { return false; } _success = __token.transfer(receiver, amount); } if (_success) { emit Withdrawal(_token, _amount); } }",
        "vulnerability": "Unsafe usage of send",
        "reason": "The function uses the send() function, which only forwards 2300 gas, making it prone to failure if the receiver's fallback function requires more than this amount of gas. Additionally, it's better to use transfer() or call.value()() for ether transfers as they provide better error handling.",
        "file_name": "0x88355a32a8c5cc399aa09b9d21ebcba935ae5d2f.sol"
    },
    {
        "function_name": "fund",
        "code": "function fund(address _address, uint _amount) public onlyAuthorized returns (bool _success) { require(_amount <= maxFundAmount); _success = _address.send(_amount); if (_success) { emit Fund(_address, _amount); } }",
        "vulnerability": "Potential denial of service with send",
        "reason": "Similar to the withdraw function, the use of the send() function here can lead to a denial of service if the receiving address's fallback function requires more than 2300 gas or if it deliberately reverts the transaction. Using transfer() or call.value()() is safer and provides more robust error handling.",
        "file_name": "0x88355a32a8c5cc399aa09b9d21ebcba935ae5d2f.sol"
    },
    {
        "function_name": "setCasinoContract",
        "code": "function setCasinoContract(address _casino) public onlyAdmin { edgelessCasino = _casino; _approveForCasino(_casino, 1000000000); }",
        "vulnerability": "Unchecked approvals for token transfers",
        "reason": "The function allows an admin to set a new casino contract and immediately approve it to transfer a large amount of tokens (1 billion in this case) without any checks on the legitimacy of the new contract. This could be exploited by a malicious admin to approve an untrusted contract, leading to unauthorized token transfers.",
        "file_name": "0x88355a32a8c5cc399aa09b9d21ebcba935ae5d2f.sol"
    }
]