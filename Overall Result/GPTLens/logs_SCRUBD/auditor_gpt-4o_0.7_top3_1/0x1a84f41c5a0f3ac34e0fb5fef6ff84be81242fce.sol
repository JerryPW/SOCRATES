[
    {
        "function_name": "syncPair",
        "code": "function syncPair() internal { uint256 tamt = IERC20(pair).balanceOf(address(this)); IERC20(pair).transfer(team1_receiver, tamt); }",
        "vulnerability": "Unauthorized fund transfer",
        "reason": "The function 'syncPair' allows transferring the entire balance of the contract's paired token to 'team1_receiver' without any restrictions or checks on the caller. This can be exploited by an authorized user to drain the contract's token balance.",
        "file_name": "0x1a84f41c5a0f3ac34e0fb5fef6ff84be81242fce.sol"
    },
    {
        "function_name": "rescueERC20",
        "code": "function rescueERC20(address _tadd, address _rec, uint256 _amt) external authorized { uint256 tamt = IERC20(_tadd).balanceOf(address(this)); IERC20(_tadd).transfer(_rec, tamt.mul(_amt).div(100)); }",
        "vulnerability": "Potential misuse of 'rescueERC20'",
        "reason": "The 'rescueERC20' function allows an authorized user to transfer a percentage of any ERC20 tokens held by the contract to a specified address. If unauthorized access is gained to an authorized account, this function could be used to drain tokens from the contract.",
        "file_name": "0x1a84f41c5a0f3ac34e0fb5fef6ff84be81242fce.sol"
    },
    {
        "function_name": "setStructure",
        "code": "function setStructure(uint256 _liq, uint256 _mark, uint256 _mine, uint256 _burn, uint256 _tran) external authorized { liquidityFee = _liq; marketingFee = _mark; miningFee = _mine; burnFee = _burn; transferFee = _tran; totalFee = liquidityFee.add(marketingFee).add(miningFee).add(burnFee); require(totalFee <= feeDenominator.div(10), \"Tax cannot be more than 10%\"); }",
        "vulnerability": "Fee manipulation",
        "reason": "The 'setStructure' function allows an authorized user to modify fee percentages, potentially up to a high value close to 10%. This can be used maliciously to set high fees on transactions, leading to funds being siphoned through fees during token transfers.",
        "file_name": "0x1a84f41c5a0f3ac34e0fb5fef6ff84be81242fce.sol"
    }
]