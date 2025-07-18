[
    {
        "function_name": "setTokenAddress",
        "code": "function setTokenAddress(address _token) public onlyOwner { require(_token != address(0)); token = ERC20(_token); }",
        "vulnerability": "Token address can be manipulated",
        "reason": "The function allows the owner to change the ERC20 token contract address at any time. This means that the owner can potentially set the token address to a malicious contract, leading to unauthorized token transfers or other malicious behaviors.",
        "file_name": "0xe66888a40b5e6271006e2a0de47cfc70ca0ba4fa.sol"
    },
    {
        "function_name": "airdrop",
        "code": "function airdrop(address[] _recipients, uint[] _amounts) public onlyOwner isAllowed { for (uint i = 0; i < _recipients.length; i++) { require(_recipients[i] != address(0)); require(tokenReceived[_recipients[i]] == false); require(token.transfer(_recipients[i], _amounts[i])); tokenReceived[_recipients[i]] = true; totalClaimed = totalClaimed.add(_amounts[i]); } }",
        "vulnerability": "Lack of input validation for arrays",
        "reason": "The function does not validate that the lengths of the _recipients and _amounts arrays are equal. This could lead to scenarios where mismatched arrays cause unintended behavior or errors, potentially allowing the owner to transfer tokens to unintended recipients or amounts.",
        "file_name": "0xe66888a40b5e6271006e2a0de47cfc70ca0ba4fa.sol"
    },
    {
        "function_name": "airdropManually",
        "code": "function airdropManually(address _holder, uint _amount) public onlyOwner isAllowed { require(_holder != address(0)); require(tokenReceived[_holder] == false); if (!token.transfer(_holder, _amount)) revert(); tokenReceived[_holder] = true; totalClaimed = totalClaimed.add(_amount); }",
        "vulnerability": "Single point of failure in token transfer",
        "reason": "The function relies on the token contract's transfer function for token distribution. If the token contract is malicious or has bugs, the transfer can fail or be manipulated. Additionally, without any checks on the total supply or balances, the owner can potentially withdraw more tokens than intended if the token balance of the contract is not properly managed.",
        "file_name": "0xe66888a40b5e6271006e2a0de47cfc70ca0ba4fa.sol"
    }
]