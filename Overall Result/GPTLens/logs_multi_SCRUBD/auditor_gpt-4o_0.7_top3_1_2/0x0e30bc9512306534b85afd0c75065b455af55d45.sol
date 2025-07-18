[
    {
        "function_name": "setBlacklistWallet",
        "code": "function setBlacklistWallet(address account, bool blacklisted) external onlyOwner() { _isBlacklistWallet[account] = blacklisted; }",
        "vulnerability": "Centralized control over blacklisting",
        "reason": "The function allows the owner to blacklist any address at their discretion. This gives the owner centralized control over the smart contract, which can be misused to block legitimate users from transferring tokens or participating in the token ecosystem. This undermines the decentralization principle and can be exploited by the owner or if the owner's account is compromised.",
        "file_name": "0x0e30bc9512306534b85afd0c75065b455af55d45.sol"
    },
    {
        "function_name": "setFeesPercent",
        "code": "function setFeesPercent(uint256 distributionFee, uint256 liquidityFee, uint256 marketingFee, uint256 burnFee,uint256 devFee ) external onlyOwner() { require(distributionFee + liquidityFee + marketingFee + burnFee + devFee <= 900, \"Total tax should not more than 90% (900/1000)\"); _taxFee = distributionFee; _liquidityFee = liquidityFee; _marketingFee = marketingFee; _burnFee = burnFee; _devFee = devFee; _marketingDevLiquidNBurnFee = _liquidityFee + _marketingFee + _burnFee + _devFee; }",
        "vulnerability": "High fee manipulation",
        "reason": "The owner can set the total transaction fees to be as high as 90% by calling this function. This could be exploited to drain user funds through exorbitant fees on transactions, effectively making the tokens worthless for users. This centralizes control and can be used maliciously by the owner.",
        "file_name": "0x0e30bc9512306534b85afd0c75065b455af55d45.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external onlyOwner() { uint256 amount = address(this).balance; uint256 ethMarketing = amount.mul(_marketingFee).div(_devFee.add(_marketingFee)); uint256 ethDev = amount.mul(_devFee).div(_devFee.add(_marketingFee)); if(ethDev > 0) payable(devWallet).transfer(ethDev); if(ethMarketing > 0) payable(marketingWallet).transfer(ethMarketing); }",
        "vulnerability": "Unrestricted withdrawal by owner",
        "reason": "The function allows the owner to withdraw all ETH balance from the contract at any time. This can be misused by the owner to drain funds from the contract, leaving users with no ETH liquidity. It increases the risk of fund mismanagement or theft if the owner's account is compromised.",
        "file_name": "0x0e30bc9512306534b85afd0c75065b455af55d45.sol"
    }
]