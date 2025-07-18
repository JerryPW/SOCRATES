[
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 amount) external onlyOwner { ERC20(_tokenAddress).transfer(msg.sender, amount); }",
        "vulnerability": "Potential unauthorized token withdrawal",
        "reason": "The withdraw function allows the owner to transfer any amount of tokens from the contract's balance to themselves, with no checks on the balance. If ownership is compromised, an attacker can drain all tokens from the contract.",
        "file_name": "0x1b6df88f60b6b7c2b7f9b6beec4a6b3841a10d6c.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function() public payable { require(allowance[msg.sender] > 0); require(msg.value >= contributionInWei); ERC20(_tokenAddress).transfer(msg.sender, allowance[msg.sender]); allowance[msg.sender] = 0; _wallet.transfer(msg.value); }",
        "vulnerability": "Insecure Ether handling",
        "reason": "The fallback function processes incoming Ether transactions and transfers the entire msg.value to the _wallet address without any checks or limits. This setup makes it possible for the owner to change the _wallet address to a malicious address, allowing them to redirect all incoming Ether payments.",
        "file_name": "0x1b6df88f60b6b7c2b7f9b6beec4a6b3841a10d6c.sol"
    },
    {
        "function_name": "setWalletAddress",
        "code": "function setWalletAddress(address newWalletAddress) external onlyOwner { _wallet = newWalletAddress; }",
        "vulnerability": "Risk of wallet address being set to a malicious address",
        "reason": "The setWalletAddress function allows the owner to change the _wallet address without restrictions. If ownership is compromised, an attacker can redirect all Ether funds to a malicious address, resulting in potential loss of funds.",
        "file_name": "0x1b6df88f60b6b7c2b7f9b6beec4a6b3841a10d6c.sol"
    }
]