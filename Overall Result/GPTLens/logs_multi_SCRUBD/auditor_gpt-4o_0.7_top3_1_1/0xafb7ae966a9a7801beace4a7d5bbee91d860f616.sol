[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address newOwner) onlyOwner public { owner = newOwner; }",
        "vulnerability": "No null address check for new owner",
        "reason": "The function does not check if the new owner address is a null address (address(0)). Setting the owner to address(0) would make the contract irreversibly ownerless, potentially locking certain functionalities which are restricted to the owner.",
        "file_name": "0xafb7ae966a9a7801beace4a7d5bbee91d860f616.sol"
    },
    {
        "function_name": "withdrawToken",
        "code": "function withdrawToken() onlyOwner public { token.transfer(owner, tokenBalance()); }",
        "vulnerability": "No return value check on token transfer",
        "reason": "The function does not check the return value of the token's `transfer` function. If the transfer fails, it would not be evident, potentially causing a loss of tokens if the function is expected to always succeed. This could be exploited if the token contract is malicious or non-standard.",
        "file_name": "0xafb7ae966a9a7801beace4a7d5bbee91d860f616.sol"
    },
    {
        "function_name": "buyTokens",
        "code": "function buyTokens(address _buyer) private { require(_buyer != 0x0); require(msg.value > 0); uint256 tokens = msg.value * WeiRatio; require(tokenBalance() >= tokens, \"Not enough tokens for sale\"); token.transfer(_buyer, tokens); SellAmount += tokens; emit Buy(msg.sender,WeiRatio,msg.value,tokens); }",
        "vulnerability": "No return value check on token transfer",
        "reason": "The function does not check the return value of the token's `transfer` function. If the transfer fails, the Ether would still be deducted from the buyer without them receiving the tokens. This could be exploited if there are issues with the token contract or if it is maliciously designed.",
        "file_name": "0xafb7ae966a9a7801beace4a7d5bbee91d860f616.sol"
    }
]