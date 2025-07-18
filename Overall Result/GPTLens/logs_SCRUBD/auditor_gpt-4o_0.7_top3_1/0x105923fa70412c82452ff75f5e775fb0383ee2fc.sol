[
    {
        "function_name": "setFeesPercent",
        "code": "function setFeesPercent(uint256 distributionFee, uint256 liquidityFee, uint256 marketingFee, uint256 burnFee,uint256 devFee ) external onlyOwner() { require(distributionFee + liquidityFee + marketingFee + burnFee + devFee <= 900, \"Total tax should not more than 90% (900/1000)\"); _taxFee = distributionFee; _liquidityFee = liquidityFee; _marketingFee = marketingFee; _burnFee = burnFee; _devFee = devFee; _marketingDevLiquidNBurnFee = _liquidityFee + _marketingFee + _burnFee + _devFee; }",
        "vulnerability": "Owner Can Set High Fees",
        "reason": "The function allows the owner to set fees up to 90% of the transaction amount. This could be abused by the owner to effectively 'trap' token holders by imposing prohibitively high fees on transactions, making it impossible or economically unfeasible for them to transfer or sell their tokens.",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol"
    },
    {
        "function_name": "setBlacklistWallet",
        "code": "function setBlacklistWallet(address account, bool blacklisted) external onlyOwner() { _isBlacklistWallet[account] = blacklisted; }",
        "vulnerability": "Arbitrary Blacklisting",
        "reason": "This function gives the owner the ability to blacklist any address at will. Once blacklisted, an address cannot participate in token transfers. This could be exploited by a malicious or compromised owner to freeze the assets of any token holder arbitrarily.",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address newOwner) public virtual onlyOwner { require(newOwner != address(0), \"Ownable: new owner is the zero address\"); emit OwnershipTransferred(_owner, newOwner); _owner = newOwner; }",
        "vulnerability": "Ownership Transfer to Untrusted Address",
        "reason": "The function allows the current owner to transfer ownership to any address, including potentially malicious or compromised addresses. This is dangerous because if the ownership is transferred to a bad actor, they could exploit the contract by using functions that require owner permissions, such as setting high fees or blacklisting users.",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol"
    }
]