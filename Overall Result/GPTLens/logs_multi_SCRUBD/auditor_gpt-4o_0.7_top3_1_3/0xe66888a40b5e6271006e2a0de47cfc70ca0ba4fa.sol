[
    {
        "function_name": "airdrop",
        "code": "function airdrop(address[] _recipients, uint[] _amounts) public onlyOwner isAllowed { for (uint i = 0; i < _recipients.length; i++) { require(_recipients[i] != address(0)); require(tokenReceived[_recipients[i]] == false); require(token.transfer(_recipients[i], _amounts[i])); tokenReceived[_recipients[i]] = true; totalClaimed = totalClaimed.add(_amounts[i]); } }",
        "vulnerability": "Out-of-gas exception",
        "reason": "The airdrop function iterates over both the _recipients and _amounts arrays. If these arrays are large, the transaction could exceed the block gas limit, causing an out-of-gas exception and potentially leaving the contract in an undesirable state.",
        "file_name": "0xe66888a40b5e6271006e2a0de47cfc70ca0ba4fa.sol"
    },
    {
        "function_name": "airdrop",
        "code": "function airdrop(address[] _recipients, uint[] _amounts) public onlyOwner isAllowed { for (uint i = 0; i < _recipients.length; i++) { require(_recipients[i] != address(0)); require(tokenReceived[_recipients[i]] == false); require(token.transfer(_recipients[i], _amounts[i])); tokenReceived[_recipients[i]] = true; totalClaimed = totalClaimed.add(_amounts[i]); } }",
        "vulnerability": "Lack of input validation",
        "reason": "The function does not check if the lengths of _recipients and _amounts arrays are equal, which can lead to unexpected behavior, such as transferring incorrect amounts or running out of tokens.",
        "file_name": "0xe66888a40b5e6271006e2a0de47cfc70ca0ba4fa.sol"
    },
    {
        "function_name": "setTokenAddress",
        "code": "function setTokenAddress(address _token) public onlyOwner { require(_token != address(0)); token = ERC20(_token); }",
        "vulnerability": "Token contract replacement",
        "reason": "The owner can change the token contract address at any time using setTokenAddress. This could be exploited to replace the token with a malicious or incorrect contract, potentially locking tokens or allowing unauthorized transfers.",
        "file_name": "0xe66888a40b5e6271006e2a0de47cfc70ca0ba4fa.sol"
    }
]