[
    {
        "function_name": "withdraw",
        "code": "function withdraw(address _token, uint _amount) public onlyAdmin returns (bool _success) { _success = false; if (_token == address (0)) { uint weiAmount = _amount; if (weiAmount > address(this).balance) { return false; } _success = receiver.send(weiAmount); } else { Token __token = Token(_token); uint amount = _amount; if (amount > __token.balanceOf(this)) { return false; } _success = __token.transfer(receiver, amount); } if (_success) { emit Withdrawal(_token, _amount); } }",
        "vulnerability": "Unchecked return value from external call",
        "reason": "The function uses 'receiver.send(weiAmount)' which is vulnerable because it does not handle cases where the send fails. An attacker could exploit this by manipulating the fallback function of the receiver to always revert, causing a denial of service.",
        "file_name": "0x88355a32a8c5cc399aa09b9d21ebcba935ae5d2f.sol"
    },
    {
        "function_name": "fund",
        "code": "function fund(address _address, uint _amount) public onlyAuthorized returns (bool _success) { require(_amount <= maxFundAmount); _success = _address.send(_amount); if (_success) { emit Fund(_address, _amount); } }",
        "vulnerability": "Unchecked send function",
        "reason": "The function uses '_address.send(_amount)' which can fail if the receiving address does not have a fallback payable function or if there is an error in the fallback function. This unchecked call can cause loss of funds or unintended behavior if not properly handled.",
        "file_name": "0x88355a32a8c5cc399aa09b9d21ebcba935ae5d2f.sol"
    },
    {
        "function_name": "setMaxFundAmount",
        "code": "function setMaxFundAmount(uint _amount) public onlyAdmin { maxFundAmount = _amount; }",
        "vulnerability": "Lack of input validation",
        "reason": "The function allows any value for maxFundAmount. If a malicious admin sets this to a very high value, it could lead to excessive funds being transferred in the fund function, potentially draining the contract of its ether.",
        "file_name": "0x88355a32a8c5cc399aa09b9d21ebcba935ae5d2f.sol"
    }
]