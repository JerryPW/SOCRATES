[
    {
        "function_name": "setBots",
        "code": "function setBots(address[] memory bots_) external onlyHldAdmin { for (uint i = 0; i < bots_.length; i++) { bots[bots_[i]] = true; } }",
        "vulnerability": "Centralized control over bot list",
        "reason": "The setBots function allows the hldAdmin to arbitrarily set any address as a bot. This can be exploited to exclude certain users from participating in transactions, effectively freezing their funds. The function lacks any checks or balances and can be misused by a malicious or compromised hldAdmin.",
        "file_name": "0x300af88747b3f913012753071f209b48b30ea1ac.sol"
    },
    {
        "function_name": "removeHldAdmin",
        "code": "function removeHldAdmin() public virtual onlyOwner { hldAdmin = address(0); }",
        "vulnerability": "Irreversible removal of hldAdmin",
        "reason": "The removeHldAdmin function allows the owner to set the hldAdmin address to zero, which is irreversible. Once the hldAdmin is removed, any functionality depending on this role, such as managing the bot list or updating certain parameters, will be permanently disabled, which could lead to loss of control over critical contract features.",
        "file_name": "0x300af88747b3f913012753071f209b48b30ea1ac.sol"
    },
    {
        "function_name": "changeFees",
        "code": "function changeFees(uint256 initialReflectionFee, uint256 initialReflectionFeeOnSell, uint256 initialLpFee, uint256 initialLpFeeOnSell, uint256 initialDevFee, uint256 initialDevFeeOnSell) external onlyOwner { reflectionFee = initialReflectionFee; lpFee = initialLpFee; devFee = initialDevFee; reflectionFeeOnSell = initialReflectionFeeOnSell; lpFeeOnSell = initialLpFeeOnSell; devFeeOnSell = initialDevFeeOnSell; totalFee = devFee.add(lpFee).add(reflectionFee).add(hldFee); totalFeeIfSelling = devFeeOnSell.add(lpFeeOnSell).add(reflectionFeeOnSell).add(hldFee); require(totalFee <= 12, \"Too high fee\"); require(totalFeeIfSelling <= 17, \"Too high fee\"); }",
        "vulnerability": "Potential for high transaction fees",
        "reason": "The changeFees function allows the owner to modify the fees associated with transactions. Although there are constraints on the maximum fees, the limits are relatively high (up to 12% for normal transactions and 17% for selling). This could potentially be exploited by the owner to impose excessively high fees, discouraging transactions and harming users financially.",
        "file_name": "0x300af88747b3f913012753071f209b48b30ea1ac.sol"
    }
]