[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address newOwner) onlyOwner public { owner = newOwner; }",
        "vulnerability": "Ownership can be transferred to a zero address",
        "reason": "The function does not check if the new owner address is a non-zero address. This could lead to a loss of control over the contract if the ownership is transferred to the zero address, making it impossible to call functions restricted by the 'onlyOwner' modifier.",
        "file_name": "0xafb7ae966a9a7801beace4a7d5bbee91d860f616.sol"
    },
    {
        "function_name": "withdrawToken",
        "code": "function withdrawToken() onlyOwner public { token.transfer(owner, tokenBalance()); }",
        "vulnerability": "Potential for token loss due to unchecked return values",
        "reason": "The function does not check the return value of the `token.transfer` function. If the token contract does not return true or throws an error, the tokens may not be transferred to the owner, leading to potential loss or locking of tokens.",
        "file_name": "0xafb7ae966a9a7801beace4a7d5bbee91d860f616.sol"
    },
    {
        "function_name": "buyTokens",
        "code": "function buyTokens(address _buyer) private { require(_buyer != 0x0); require(msg.value > 0); uint256 tokens = msg.value * WeiRatio; require(tokenBalance() >= tokens, \"Not enough tokens for sale\"); token.transfer(_buyer, tokens); SellAmount += tokens; emit Buy(msg.sender,WeiRatio,msg.value,tokens); }",
        "vulnerability": "No reentrancy protection",
        "reason": "The buyTokens function transfers tokens to the buyer before updating the SellAmount state variable. This lack of reentrancy protection could be exploited by an attacker to create a reentrancy attack, allowing them to repeatedly call the function and drain tokens from the contract before the SellAmount is updated.",
        "file_name": "0xafb7ae966a9a7801beace4a7d5bbee91d860f616.sol"
    }
]