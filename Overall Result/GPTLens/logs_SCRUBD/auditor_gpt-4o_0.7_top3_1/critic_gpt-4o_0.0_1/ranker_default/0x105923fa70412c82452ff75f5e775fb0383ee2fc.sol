[
    {
        "function_name": "setFeesPercent",
        "vulnerability": "Owner Can Set High Fees",
        "criticism": "The reasoning is correct in identifying that the owner can set fees up to 90%, which is extremely high and could effectively trap token holders by making transactions economically unfeasible. This is a significant vulnerability as it gives the owner excessive control over the token's usability. The severity is high because it can severely impact token holders' ability to transact. The profitability for the owner is high, as they could potentially extract value from trapped token holders.",
        "correctness": 9,
        "severity": 8,
        "profitability": 7,
        "reason": "The function allows the owner to set fees up to 90% of the transaction amount. This could be abused by the owner to effectively 'trap' token holders by imposing prohibitively high fees on transactions, making it impossible or economically unfeasible for them to transfer or sell their tokens.",
        "code": "function setFeesPercent(uint256 distributionFee, uint256 liquidityFee, uint256 marketingFee, uint256 burnFee,uint256 devFee ) external onlyOwner() { require(distributionFee + liquidityFee + marketingFee + burnFee + devFee <= 900, \"Total tax should not more than 90% (900/1000)\"); _taxFee = distributionFee; _liquidityFee = liquidityFee; _marketingFee = marketingFee; _burnFee = burnFee; _devFee = devFee; _marketingDevLiquidNBurnFee = _liquidityFee + _marketingFee + _burnFee + _devFee; }",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol",
        "final_score": 8.25
    },
    {
        "function_name": "setBlacklistWallet",
        "vulnerability": "Arbitrary Blacklisting",
        "criticism": "The reasoning is correct in pointing out that the owner can arbitrarily blacklist any address, which can freeze assets and prevent participation in token transfers. This is a significant vulnerability as it can be used maliciously to target specific users. The severity is high because it can completely restrict a user's access to their tokens. The profitability is moderate, as it depends on the owner's intentions and the potential for extortion or manipulation.",
        "correctness": 9,
        "severity": 8,
        "profitability": 5,
        "reason": "This function gives the owner the ability to blacklist any address at will. Once blacklisted, an address cannot participate in token transfers. This could be exploited by a malicious or compromised owner to freeze the assets of any token holder arbitrarily.",
        "code": "function setBlacklistWallet(address account, bool blacklisted) external onlyOwner() { _isBlacklistWallet[account] = blacklisted; }",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol",
        "final_score": 7.75
    },
    {
        "function_name": "transferOwnership",
        "vulnerability": "Ownership Transfer to Untrusted Address",
        "criticism": "The reasoning is correct in identifying the risk of transferring ownership to a potentially malicious address. This could lead to the new owner exploiting the contract by using functions that require owner permissions. The severity is moderate because it depends on the new owner's intentions, but the potential for abuse is significant. The profitability is moderate, as a malicious new owner could exploit the contract for personal gain.",
        "correctness": 8,
        "severity": 6,
        "profitability": 5,
        "reason": "The function allows the current owner to transfer ownership to any address, including potentially malicious or compromised addresses. This is dangerous because if the ownership is transferred to a bad actor, they could exploit the contract by using functions that require owner permissions, such as setting high fees or blacklisting users.",
        "code": "function transferOwnership(address newOwner) public virtual onlyOwner { require(newOwner != address(0), \"Ownable: new owner is the zero address\"); emit OwnershipTransferred(_owner, newOwner); _owner = newOwner; }",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol",
        "final_score": 6.75
    }
]