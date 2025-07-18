[
    {
        "function_name": "airdrop",
        "code": "function airdrop(address[] _recipients, uint[] _amounts) public onlyOwner isAllowed { for (uint i = 0; i < _recipients.length; i++) { require(_recipients[i] != address(0)); require(tokenReceived[_recipients[i]] == false); require(token.transfer(_recipients[i], _amounts[i])); tokenReceived[_recipients[i]] = true; totalClaimed = totalClaimed.add(_amounts[i]); } }",
        "vulnerability": "Gas Limit Issues with Loop",
        "reason": "The airdrop function processes multiple recipients in a loop. If the number of recipients is too large, the transaction may run out of gas and revert, which can lead to denial of service. An attacker can exploit this by providing a large list of recipients, causing the function to fail.",
        "file_name": "0xe66888a40b5e6271006e2a0de47cfc70ca0ba4fa.sol"
    },
    {
        "function_name": "setTokenAddress",
        "code": "function setTokenAddress(address _token) public onlyOwner { require(_token != address(0)); token = ERC20(_token); }",
        "vulnerability": "Token Address Manipulation",
        "reason": "The setTokenAddress function allows the owner to set the token address arbitrarily. This can be exploited if the contract owner is compromised, allowing the attacker to redirect token transfers to a malicious token contract.",
        "file_name": "0xe66888a40b5e6271006e2a0de47cfc70ca0ba4fa.sol"
    },
    {
        "function_name": "airdropManually",
        "code": "function airdropManually(address _holder, uint _amount) public onlyOwner isAllowed { require(_holder != address(0)); require(tokenReceived[_holder] == false); if (!token.transfer(_holder, _amount)) revert(); tokenReceived[_holder] = true; totalClaimed = totalClaimed.add(_amount); }",
        "vulnerability": "Lack of Reentrancy Protection",
        "reason": "The airdropManually function does not have protection against reentrancy attacks. If the token contract's transfer function allows for reentrancy, an attacker could potentially re-enter the airdropManually function and manipulate the state variables, such as marking tokenReceived on addresses.",
        "file_name": "0xe66888a40b5e6271006e2a0de47cfc70ca0ba4fa.sol"
    }
]