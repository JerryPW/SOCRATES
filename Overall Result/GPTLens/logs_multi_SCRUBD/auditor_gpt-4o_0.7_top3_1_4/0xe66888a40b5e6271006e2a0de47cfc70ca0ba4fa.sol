[
    {
        "function_name": "airdrop",
        "code": "function airdrop(address[] _recipients, uint[] _amounts) public onlyOwner isAllowed { for (uint i = 0; i < _recipients.length; i++) { require(_recipients[i] != address(0)); require(tokenReceived[_recipients[i]] == false); require(token.transfer(_recipients[i], _amounts[i])); tokenReceived[_recipients[i]] = true; totalClaimed = totalClaimed.add(_amounts[i]); } }",
        "vulnerability": "Lack of batch processing limits",
        "reason": "The airdrop function processes all recipients in a single transaction, which can lead to block gas limit issues if the _recipients array is too large. This can cause the transaction to fail and potentially become a denial of service vector.",
        "file_name": "0xe66888a40b5e6271006e2a0de47cfc70ca0ba4fa.sol"
    },
    {
        "function_name": "setTokenAddress",
        "code": "function setTokenAddress(address _token) public onlyOwner { require(_token != address(0)); token = ERC20(_token); }",
        "vulnerability": "Token contract address changeable at any time",
        "reason": "The setTokenAddress function allows the owner to change the token contract address at any time. This could be exploited if the owner sets the token to a malicious contract that could manipulate token balances, leading to potential loss of funds.",
        "file_name": "0xe66888a40b5e6271006e2a0de47cfc70ca0ba4fa.sol"
    },
    {
        "function_name": "airdrop",
        "code": "function airdrop(address[] _recipients, uint[] _amounts) public onlyOwner isAllowed { for (uint i = 0; i < _recipients.length; i++) { require(_recipients[i] != address(0)); require(tokenReceived[_recipients[i]] == false); require(token.transfer(_recipients[i], _amounts[i])); tokenReceived[_recipients[i]] = true; totalClaimed = totalClaimed.add(_amounts[i]); } }",
        "vulnerability": "No verification for total supply limit",
        "reason": "The airdrop function does not verify that the total of _amounts does not exceed the contract's token balance or the total supply limit. This can result in failed transactions if the contract does not hold enough tokens to cover the airdrop.",
        "file_name": "0xe66888a40b5e6271006e2a0de47cfc70ca0ba4fa.sol"
    }
]