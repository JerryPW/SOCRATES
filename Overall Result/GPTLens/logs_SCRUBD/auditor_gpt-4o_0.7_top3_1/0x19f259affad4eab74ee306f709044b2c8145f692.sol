[
    {
        "function_name": "ManageBlacklist",
        "code": "function ManageBlacklist(address[] calldata addresses, bool status) external onlyOwner { for (uint256 i; i < addresses.length; ++i) { isBlacklisted[addresses[i]] = status; } emit BlacklistUpdated(); }",
        "vulnerability": "Owner can arbitrarily blacklist addresses.",
        "reason": "The ManageBlacklist function allows the contract owner to blacklist any address, preventing them from participating in transactions. This power can be misused to target specific users, effectively freezing their tokens and preventing them from trading or interacting with the contract.",
        "file_name": "0x19f259affad4eab74ee306f709044b2c8145f692.sol"
    },
    {
        "function_name": "manualBurnLPTokens",
        "code": "function manualBurnLPTokens(uint256 percent) external onlyOwner returns (bool){ require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , \"Must wait for cooldown to finish\"); require(percent <= 1000, \"May not nuke more than 10% of tokens in LP\"); lastManualLpBurnTime = block.timestamp; uint256 liquidityPairBalance = this.balanceOf(_PairAddress); uint256 amountToBurn = liquidityPairBalance * percent/10000; if (amountToBurn > 0){ _balances[burnWallet]+=amountToBurn; emit Transfer(_PairAddress,burnWallet,amountToBurn); } IDexPair pair = IDexPair(_PairAddress); pair.sync(); emit ManualNukeLP(); return true; }",
        "vulnerability": "Owner can perform excessive manual LP burns.",
        "reason": "The manualBurnLPTokens function allows the owner to burn up to 10% of the liquidity tokens every time the function is called after the cooldown period. This could be used to drain liquidity from the pool, adversely affecting the token's market stability and harming liquidity providers.",
        "file_name": "0x19f259affad4eab74ee306f709044b2c8145f692.sol"
    },
    {
        "function_name": "SetTaxes",
        "code": "function SetTaxes(uint buy, uint sell, uint transfer_, uint burn, uint project,uint liquidity, uint FloorSellTax) external onlyOwner{ uint maxTax=TAX_DENOMINATOR/MAXTAXDENOMINATOR; require(buy<=maxTax&&sell<=maxTax&&transfer_<=maxTax&&FloorSellTax<=maxTax,\"Tax exceeds maxTax\"); require(burn+project+liquidity==TAX_DENOMINATOR,\"Taxes don't add up to denominator\"); buyTax=buy; sellTax=sell; floorSellerTax=FloorSellTax; transferTax=transfer_; projectTax=project; liquidityTax=liquidity; burnTax=burn; emit OnSetTaxes(buy, sell, transfer_, burn, project, liquidity, FloorSellTax); }",
        "vulnerability": "Owner can set extremely high taxes.",
        "reason": "The SetTaxes function allows the owner to set taxes up to 100% (since MAXTAXDENOMINATOR is 10), which means that transactions can be taxed at extremely high rates. This could be exploited to drain users' tokens through high taxation, leading to loss of funds for token holders.",
        "file_name": "0x19f259affad4eab74ee306f709044b2c8145f692.sol"
    }
]