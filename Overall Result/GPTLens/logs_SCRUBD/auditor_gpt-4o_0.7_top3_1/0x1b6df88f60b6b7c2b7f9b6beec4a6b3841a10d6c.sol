[
    {
        "function_name": "function()",
        "code": "function() public payable { require(allowance[msg.sender] > 0); require(msg.value >= contributionInWei); ERC20(_tokenAddress).transfer(msg.sender, allowance[msg.sender]); allowance[msg.sender] = 0; _wallet.transfer(msg.value); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function transfers tokens before resetting the allowance to zero. This could allow a reentrancy attack where a malicious contract calls back into the fallback function before the state change, thus claiming more tokens than intended.",
        "file_name": "0x1b6df88f60b6b7c2b7f9b6beec4a6b3841a10d6c.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 amount) external onlyOwner { ERC20(_tokenAddress).transfer(msg.sender, amount); }",
        "vulnerability": "Potential arbitrary token withdrawal",
        "reason": "The 'withdraw' function allows the contract owner to withdraw any amount of tokens from the contract, potentially draining all tokens stored if there are no proper checks on the 'amount' parameter. This does not pose a direct risk to external users but could be considered a centralization risk.",
        "file_name": "0x1b6df88f60b6b7c2b7f9b6beec4a6b3841a10d6c.sol"
    },
    {
        "function_name": "setWalletAddress",
        "code": "function setWalletAddress(address newWalletAddress) external onlyOwner { _wallet = newWalletAddress; }",
        "vulnerability": "Wallet address changeability",
        "reason": "The function allows the owner to change the wallet address at any time, which can lead to misdirection of funds if the owner\u2019s account is compromised. An attacker with control over the owner\u2019s account could redirect future contributions to an address they control.",
        "file_name": "0x1b6df88f60b6b7c2b7f9b6beec4a6b3841a10d6c.sol"
    }
]