[
    {
        "function_name": "transfer",
        "code": "function transfer(address recipient, uint256 amount) public override returns (bool) { _transfer(_msgSender(), recipient, amount); return true; }",
        "vulnerability": "Lack of trading activation check",
        "reason": "The transfer function does not check if trading is enabled. Although there are checks within the _transfer function to ensure trading is active, the lack of initial checks within transfer may lead to unexpected behavior if the _transfer function's logic is modified or bypassed in future updates.",
        "file_name": "0x0e30bc9512306534b85afd0c75065b455af55d45.sol"
    },
    {
        "function_name": "setFeesPercent",
        "code": "function setFeesPercent(uint256 distributionFee, uint256 liquidityFee, uint256 marketingFee, uint256 burnFee,uint256 devFee ) external onlyOwner() { require(distributionFee + liquidityFee + marketingFee + burnFee + devFee <= 900, \"Total tax should not more than 90% (900/1000)\"); _taxFee = distributionFee; _liquidityFee = liquidityFee; _marketingFee = marketingFee; _burnFee = burnFee; _devFee = devFee; _marketingDevLiquidNBurnFee = _liquidityFee + _marketingFee + _burnFee + _devFee; }",
        "vulnerability": "High fee setting",
        "reason": "This function allows the owner to set very high fees, up to 90% of the transaction amount. This could be used maliciously to siphon funds from users when trading is enabled, either intentionally or due to a compromised owner account.",
        "file_name": "0x0e30bc9512306534b85afd0c75065b455af55d45.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address newOwner) public virtual onlyOwner { require(newOwner != address(0), \"Ownable: new owner is the zero address\"); emit OwnershipTransferred(_owner, newOwner); _owner = newOwner; }",
        "vulnerability": "Ownership transfer risk",
        "reason": "The transferOwnership function does not have additional checks or conditions that could prevent accidental or malicious transfer of ownership to an unintended address, aside from the zero address check. If the owner's account is compromised, the attacker could easily transfer ownership.",
        "file_name": "0x0e30bc9512306534b85afd0c75065b455af55d45.sol"
    }
]