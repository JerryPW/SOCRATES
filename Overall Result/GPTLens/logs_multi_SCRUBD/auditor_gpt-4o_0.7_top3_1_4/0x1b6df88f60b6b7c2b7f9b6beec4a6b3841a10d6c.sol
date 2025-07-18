[
    {
        "function_name": "function()",
        "code": "function() public payable { require(allowance[msg.sender] > 0); require(msg.value >= contributionInWei); ERC20(_tokenAddress).transfer(msg.sender, allowance[msg.sender]); allowance[msg.sender] = 0; _wallet.transfer(msg.value); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function makes an external call to transfer tokens before updating the state variable 'allowance'. This can lead to reentrancy attacks where an attacker could repeatedly call the fallback function to drain the contract's balance before state is updated, as there is no reentrancy guard in place.",
        "file_name": "0x1b6df88f60b6b7c2b7f9b6beec4a6b3841a10d6c.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 amount) external onlyOwner { ERC20(_tokenAddress).transfer(msg.sender, amount); }",
        "vulnerability": "Lack of balance checks",
        "reason": "There is no check to ensure that the contract has enough balance of the token before attempting to transfer. An attacker with ownership can exploit this and call withdraw with an amount greater than the contract's balance, leading to potential failures or unexpected behavior.",
        "file_name": "0x1b6df88f60b6b7c2b7f9b6beec4a6b3841a10d6c.sol"
    },
    {
        "function_name": "setWalletAddress",
        "code": "function setWalletAddress(address newWalletAddress) external onlyOwner { _wallet = newWalletAddress; }",
        "vulnerability": "Potential for unauthorized fund diversion",
        "reason": "The owner can change the '_wallet' address to any arbitrary address, which allows them to redirect all incoming Ether contributions to an address they control. This could potentially be exploited if ownership is compromised or if the owner is malicious.",
        "file_name": "0x1b6df88f60b6b7c2b7f9b6beec4a6b3841a10d6c.sol"
    }
]