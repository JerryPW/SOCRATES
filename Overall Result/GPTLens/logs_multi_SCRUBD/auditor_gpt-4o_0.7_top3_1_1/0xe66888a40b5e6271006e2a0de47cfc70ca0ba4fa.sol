[
    {
        "function_name": "airdrop",
        "code": "function airdrop(address[] _recipients, uint[] _amounts) public onlyOwner isAllowed { for (uint i = 0; i < _recipients.length; i++) { require(_recipients[i] != address(0)); require(tokenReceived[_recipients[i]] == false); require(token.transfer(_recipients[i], _amounts[i])); tokenReceived[_recipients[i]] = true; totalClaimed = totalClaimed.add(_amounts[i]); } }",
        "vulnerability": "Lack of input validation",
        "reason": "The airdrop function does not validate that the length of _recipients matches the length of _amounts, potentially leading to out-of-bounds errors or unintended behaviors. An attacker could exploit this by passing mismatched arrays, causing the function to revert or function incorrectly.",
        "file_name": "0xe66888a40b5e6271006e2a0de47cfc70ca0ba4fa.sol"
    },
    {
        "function_name": "airdrop",
        "code": "function airdrop(address[] _recipients, uint[] _amounts) public onlyOwner isAllowed { for (uint i = 0; i < _recipients.length; i++) { require(_recipients[i] != address(0)); require(tokenReceived[_recipients[i]] == false); require(token.transfer(_recipients[i], _amounts[i])); tokenReceived[_recipients[i]] = true; totalClaimed = totalClaimed.add(_amounts[i]); } }",
        "vulnerability": "Gas limit vulnerability",
        "reason": "The airdrop function processes a potentially large array of recipients and amounts, which could exceed the block gas limit, causing the function to fail. An attacker could exploit this by providing large input arrays, leading to denial of service.",
        "file_name": "0xe66888a40b5e6271006e2a0de47cfc70ca0ba4fa.sol"
    },
    {
        "function_name": "setTokenAddress",
        "code": "function setTokenAddress(address _token) public onlyOwner { require(_token != address(0)); token = ERC20(_token); }",
        "vulnerability": "Token contract address change",
        "reason": "The setTokenAddress function allows the owner to change the token contract address at any time. This could be exploited if the owner sets the address to a malicious contract that behaves unexpectedly or steals tokens.",
        "file_name": "0xe66888a40b5e6271006e2a0de47cfc70ca0ba4fa.sol"
    }
]