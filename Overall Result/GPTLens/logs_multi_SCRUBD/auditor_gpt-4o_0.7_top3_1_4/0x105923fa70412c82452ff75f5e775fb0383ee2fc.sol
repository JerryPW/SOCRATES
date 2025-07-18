[
    {
        "function_name": "setFeesPercent",
        "code": "function setFeesPercent(uint256 distributionFee, uint256 liquidityFee, uint256 marketingFee, uint256 burnFee,uint256 devFee ) external onlyOwner() { require(distributionFee + liquidityFee + marketingFee + burnFee + devFee <= 900, \"Total tax should not more than 90% (900/1000)\"); _taxFee = distributionFee; _liquidityFee = liquidityFee; _marketingFee = marketingFee; _burnFee = burnFee; _devFee = devFee; _marketingDevLiquidNBurnFee = _liquidityFee + _marketingFee + _burnFee + _devFee; }",
        "vulnerability": "High tax fee configuration by owner",
        "reason": "The `setFeesPercent` function allows the owner to set the total fees up to 90% of each transaction. This could be exploited by the owner to effectively drain all funds from users by setting extraordinarily high fees, which can discourage trading and destroy trust in the token.",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol"
    },
    {
        "function_name": "setBlacklistWallet",
        "code": "function setBlacklistWallet(address account, bool blacklisted) external onlyOwner() { _isBlacklistWallet[account] = blacklisted; }",
        "vulnerability": "Centralized control over blacklisting",
        "reason": "The owner has the ability to blacklist any address, which can prevent an address from participating in token transfers. This centralization poses a risk as it can be abused by the owner to arbitrarily restrict users from trading or accessing their tokens, which is contrary to the decentralized nature of blockchain.",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol"
    },
    {
        "function_name": "renounceOwnership",
        "code": "function renounceOwnership() public virtual onlyOwner { emit OwnershipTransferred(_owner, address(0)); _owner = address(0); }",
        "vulnerability": "Irreversible loss of ownership control",
        "reason": "The `renounceOwnership` function allows the current owner to renounce ownership, setting the owner to address(0). This makes it impossible to call any `onlyOwner` functions, including those that might be necessary for future upgrades or emergency actions, potentially leaving the contract in a vulnerable or unmanageable state.",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol"
    }
]