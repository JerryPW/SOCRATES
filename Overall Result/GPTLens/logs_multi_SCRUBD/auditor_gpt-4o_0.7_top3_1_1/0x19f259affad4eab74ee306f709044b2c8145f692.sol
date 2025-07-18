[
    {
        "function_name": "setSwapTreshold",
        "code": "function setSwapTreshold(uint newSwapTresholdPermille) external onlyOwner{ require(newSwapTresholdPermille<=10); swapTreshold=newSwapTresholdPermille; emit SwapThresholdChange(newSwapTresholdPermille); }",
        "vulnerability": "Inadequate validation for swap threshold",
        "reason": "The function allows the owner to set a swap threshold as high as 10 permille (1%), which could be exploited by the owner to manipulate the contract's behavior, potentially causing large amounts of tokens to be swapped at once, affecting price stability.",
        "file_name": "0x19f259affad4eab74ee306f709044b2c8145f692.sol"
    },
    {
        "function_name": "ManageBlacklist",
        "code": "function ManageBlacklist(address[] calldata addresses, bool status) external onlyOwner { for (uint256 i; i < addresses.length; ++i) { isBlacklisted[addresses[i]] = status; } emit BlacklistUpdated(); }",
        "vulnerability": "Blacklist control by owner",
        "reason": "The owner has complete control over the blacklist status of any address, which could be used maliciously to block addresses from trading. This centralized control is against the decentralized nature and could be misused to freeze specific accounts, affecting their ability to trade tokens.",
        "file_name": "0x19f259affad4eab74ee306f709044b2c8145f692.sol"
    },
    {
        "function_name": "ReleaseLP",
        "code": "function ReleaseLP() external onlyOwner { IERC20 liquidityToken = IERC20(_PairAddress); uint amount = liquidityToken.balanceOf(address(this)); liquidityToken.transfer(msg.sender, amount); emit OnReleaseLP(); }",
        "vulnerability": "Liquidity pool draining by owner",
        "reason": "This function allows the owner to transfer all liquidity pool tokens held by the contract to their own address. This can drain the liquidity pool, severely affecting the token's market stability and liquidity, and can be used to manipulate the token price or execute a rug pull.",
        "file_name": "0x19f259affad4eab74ee306f709044b2c8145f692.sol"
    }
]