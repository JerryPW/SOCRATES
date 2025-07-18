[
    {
        "function_name": "setFeesPercent",
        "code": "function setFeesPercent(uint256 distributionFee, uint256 liquidityFee, uint256 marketingFee, uint256 burnFee,uint256 devFee ) external onlyOwner() { require(distributionFee + liquidityFee + marketingFee + burnFee + devFee <= 900, \"Total tax should not more than 90% (900/1000)\"); _taxFee = distributionFee; _liquidityFee = liquidityFee; _marketingFee = marketingFee; _burnFee = burnFee; _devFee = devFee; _marketingDevLiquidNBurnFee = _liquidityFee + _marketingFee + _burnFee + _devFee; }",
        "vulnerability": "Centralization of Control",
        "reason": "The setFeesPercent function allows the owner to set high fees up to 90%, which can be detrimental to token holders. This centralization of control can be abused by the owner to extract value from the contract, leading to potential rug-pulling scenarios.",
        "file_name": "0x0e30bc9512306534b85afd0c75065b455af55d45.sol"
    },
    {
        "function_name": "setTradingEnabled",
        "code": "function setTradingEnabled(bool _enabled) public onlyOwner() { trading = _enabled; }",
        "vulnerability": "Centralization of Control",
        "reason": "The owner has the ability to enable or disable trading at any time. This control can be exploited to prevent users from trading the token, potentially locking them into an unfavorable situation or manipulating the market.",
        "file_name": "0x0e30bc9512306534b85afd0c75065b455af55d45.sol"
    },
    {
        "function_name": "setBlacklistWallet",
        "code": "function setBlacklistWallet(address account, bool blacklisted) external onlyOwner() { _isBlacklistWallet[account] = blacklisted; }",
        "vulnerability": "Centralization of Control",
        "reason": "The owner has the ability to blacklist any wallet address, which could be used to freeze or restrict specific users' ability to trade or transfer tokens. This can be misused to target specific users or implement arbitrary restrictions.",
        "file_name": "0x0e30bc9512306534b85afd0c75065b455af55d45.sol"
    }
]