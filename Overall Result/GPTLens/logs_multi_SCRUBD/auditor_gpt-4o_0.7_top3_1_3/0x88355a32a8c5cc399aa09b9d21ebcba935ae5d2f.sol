[
    {
        "function_name": "withdraw",
        "code": "function withdraw(address _token, uint _amount) public onlyAdmin returns (bool _success) { _success = false; if (_token == address (0)) { uint weiAmount = _amount; if (weiAmount > address(this).balance) { return false; } _success = receiver.send(weiAmount); } else { Token __token = Token(_token); uint amount = _amount; if (amount > __token.balanceOf(this)) { return false; } _success = __token.transfer(receiver, amount); } if (_success) { emit Withdrawal(_token, _amount); } }",
        "vulnerability": "Unsafe external call using 'send'",
        "reason": "The use of 'send' can lead to unexpected failures due to the 2300 gas stipend limit, which can cause the transaction to fail if the receiver is a contract with complex logic in its fallback function. Additionally, the state is not reverted if 'send' fails, which could lead to inconsistent states in the contract.",
        "file_name": "0x88355a32a8c5cc399aa09b9d21ebcba935ae5d2f.sol"
    },
    {
        "function_name": "fund",
        "code": "function fund(address _address, uint _amount) public onlyAuthorized returns (bool _success) { require(_amount <= maxFundAmount); _success = _address.send(_amount); if (_success) { emit Fund(_address, _amount); } }",
        "vulnerability": "No check on send failure",
        "reason": "The use of 'send' to transfer ether can fail if the receiving address is a contract with a complex fallback function due to the gas limit. There is no check to handle the failure of the 'send' operation, which means ether could be lost if the operation fails.",
        "file_name": "0x88355a32a8c5cc399aa09b9d21ebcba935ae5d2f.sol"
    },
    {
        "function_name": "setCasinoContract",
        "code": "function setCasinoContract(address _casino) public onlyAdmin { edgelessCasino = _casino; _approveForCasino(_casino, 1000000000); }",
        "vulnerability": "Lack of input validation",
        "reason": "The function allows the admin to set the 'edgelessCasino' address to any arbitrary address. Without proper validation, this could point to a malicious contract, leading to potential misuse or loss of funds.",
        "file_name": "0x88355a32a8c5cc399aa09b9d21ebcba935ae5d2f.sol"
    }
]