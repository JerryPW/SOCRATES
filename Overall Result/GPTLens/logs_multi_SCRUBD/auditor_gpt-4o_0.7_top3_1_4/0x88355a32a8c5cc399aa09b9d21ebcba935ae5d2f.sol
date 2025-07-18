[
    {
        "function_name": "withdraw",
        "code": "function withdraw(address _token, uint _amount) public onlyAdmin returns (bool _success) { _success = false; if (_token == address (0)) { uint weiAmount = _amount; if (weiAmount > address(this).balance) { return false; } _success = receiver.send(weiAmount); } else { Token __token = Token(_token); uint amount = _amount; if (amount > __token.balanceOf(this)) { return false; } _success = __token.transfer(receiver, amount); } if (_success) { emit Withdrawal(_token, _amount); } }",
        "vulnerability": "Potential reentrancy attack via receiver.send",
        "reason": "The use of `receiver.send` to transfer Ether can be exploited in a reentrancy attack. An attacker can make a recursive call before the state is updated, allowing them to repeatedly drain funds. Although `send` only forwards 2300 gas, it still poses a risk as it does not update the state before the transfer. Consider using `transfer` or a pattern that prevents reentrancy.",
        "file_name": "0x88355a32a8c5cc399aa09b9d21ebcba935ae5d2f.sol"
    },
    {
        "function_name": "fund",
        "code": "function fund(address _address, uint _amount) public onlyAuthorized returns (bool _success) { require(_amount <= maxFundAmount); _success = _address.send(_amount); if (_success) { emit Fund(_address, _amount); } }",
        "vulnerability": "Potential reentrancy attack via _address.send",
        "reason": "Similar to the `withdraw` function, the use of `_address.send` to transfer Ether can be susceptible to reentrancy attacks. If the recipient address is a contract, it can execute code upon receiving funds that might attempt to drain additional funds. This function should employ measures to prevent reentrancy, such as using reentrancy guards or updating state before the call.",
        "file_name": "0x88355a32a8c5cc399aa09b9d21ebcba935ae5d2f.sol"
    },
    {
        "function_name": "setCasinoContract",
        "code": "function setCasinoContract(address _casino) public onlyAdmin { edgelessCasino = _casino; _approveForCasino(_casino, 1000000000); }",
        "vulnerability": "Unrestricted approval amount",
        "reason": "The function approves a large token amount (1 billion) for the casino contract without any checks. If an attacker gains admin access or if the admin account is compromised, they could exploit this to drain the tokens. Instead, consider setting a reasonable limit or requiring additional checks before updating token allowances.",
        "file_name": "0x88355a32a8c5cc399aa09b9d21ebcba935ae5d2f.sol"
    }
]