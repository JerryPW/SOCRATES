[
    {
        "function_name": "setBlacklistWallet",
        "vulnerability": "Centralized control over blacklisting",
        "criticism": "The reasoning is correct in identifying the centralized control aspect of this function. The owner has the power to blacklist any address, which can indeed be misused to block legitimate users. This undermines the principle of decentralization and poses a risk if the owner's account is compromised. The severity is moderate because it affects user participation and trust, but it is not a direct financial exploit. The profitability is low for external attackers, as only the owner can exploit this.",
        "correctness": 8,
        "severity": 5,
        "profitability": 1,
        "reason": "The function allows the owner to blacklist any address at their discretion. This gives the owner centralized control over the smart contract, which can be misused to block legitimate users from transferring tokens or participating in the token ecosystem. This undermines the decentralization principle and can be exploited by the owner or if the owner's account is compromised.",
        "code": "function setBlacklistWallet(address account, bool blacklisted) external onlyOwner() { _isBlacklistWallet[account] = blacklisted; }",
        "file_name": "0x0e30bc9512306534b85afd0c75065b455af55d45.sol"
    },
    {
        "function_name": "setFeesPercent",
        "vulnerability": "High fee manipulation",
        "criticism": "The reasoning is accurate in highlighting the potential for the owner to set exorbitant transaction fees, up to 90%. This can severely impact the usability and value of the token, effectively draining user funds through high fees. The severity is high because it can render the token ecosystem non-functional. The profitability is moderate for the owner, as they can extract value through fees, but not for external attackers.",
        "correctness": 9,
        "severity": 8,
        "profitability": 4,
        "reason": "The owner can set the total transaction fees to be as high as 90% by calling this function. This could be exploited to drain user funds through exorbitant fees on transactions, effectively making the tokens worthless for users. This centralizes control and can be used maliciously by the owner.",
        "code": "function setFeesPercent(uint256 distributionFee, uint256 liquidityFee, uint256 marketingFee, uint256 burnFee,uint256 devFee ) external onlyOwner() { require(distributionFee + liquidityFee + marketingFee + burnFee + devFee <= 900, \"Total tax should not more than 90% (900/1000)\"); _taxFee = distributionFee; _liquidityFee = liquidityFee; _marketingFee = marketingFee; _burnFee = burnFee; _devFee = devFee; _marketingDevLiquidNBurnFee = _liquidityFee + _marketingFee + _burnFee + _devFee; }",
        "file_name": "0x0e30bc9512306534b85afd0c75065b455af55d45.sol"
    },
    {
        "function_name": "manualsend",
        "vulnerability": "Unrestricted withdrawal by owner",
        "criticism": "The reasoning correctly identifies the risk of unrestricted withdrawal by the owner. This function allows the owner to withdraw all ETH from the contract, which can lead to fund mismanagement or theft, especially if the owner's account is compromised. The severity is high due to the potential for complete fund depletion. The profitability is high for the owner, as they can directly extract all funds, but not for external attackers.",
        "correctness": 9,
        "severity": 8,
        "profitability": 7,
        "reason": "The function allows the owner to withdraw all ETH balance from the contract at any time. This can be misused by the owner to drain funds from the contract, leaving users with no ETH liquidity. It increases the risk of fund mismanagement or theft if the owner's account is compromised.",
        "code": "function manualsend() external onlyOwner() { uint256 amount = address(this).balance; uint256 ethMarketing = amount.mul(_marketingFee).div(_devFee.add(_marketingFee)); uint256 ethDev = amount.mul(_devFee).div(_devFee.add(_marketingFee)); if(ethDev > 0) payable(devWallet).transfer(ethDev); if(ethMarketing > 0) payable(marketingWallet).transfer(ethMarketing); }",
        "file_name": "0x0e30bc9512306534b85afd0c75065b455af55d45.sol"
    }
]