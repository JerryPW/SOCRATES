[
    {
        "function_name": "transfer",
        "code": "function transfer(address recipient, uint256 amount) public override returns (bool) { _transfer(_msgSender(), recipient, amount); return true; }",
        "vulnerability": "Lack of check for blocked addresses",
        "reason": "The transfer function does not check if the sender or recipient is a blocked address (botWallet). This allows blocked addresses to potentially perform unauthorized transfers.",
        "file_name": "0x0544ada225de796baa4030877314a96faacea7fc.sol"
    },
    {
        "function_name": "airDrops",
        "code": "function airDrops(address[] calldata newholders, uint256[] calldata amounts) external { uint256 iterator = 0; require(_isExcludedFromFee[_msgSender()], \"Airdrop can only be done by excluded from fee\"); require(newholders.length == amounts.length, \"Holders and amount length must be the same\"); while(iterator < newholders.length){ _tokenTransfer(_msgSender(), newholders[iterator], amounts[iterator] * 10**9, false, false, false); iterator += 1; } }",
        "vulnerability": "Potential for large gas consumption",
        "reason": "The airDrops function could potentially consume a large amount of gas if a large array is passed to it. This could lead to a denial of service if the gas cost exceeds the block gas limit.",
        "file_name": "0x0544ada225de796baa4030877314a96faacea7fc.sol"
    },
    {
        "function_name": "sellTaxTokens",
        "code": "function sellTaxTokens() private { uint256 contractTokenBalance = balanceOf(address(this)); if(contractTokenBalance > 0) { uint ethPrice = getEthPrice(contractTokenBalance); if (ethPrice >= ethPriceToSwap && !inSwapAndLiquify && swapAndLiquifyEnabled) { distributeShares(contractTokenBalance); } } }",
        "vulnerability": "Potential reentrancy vulnerability",
        "reason": "The sellTaxTokens function transfers ETH after calling external functions. If the external contract calls back into the contract, it could potentially exploit state changes. Although the lockTheSwap modifier is used, additional checks should be in place to ensure secure state changes.",
        "file_name": "0x0544ada225de796baa4030877314a96faacea7fc.sol"
    }
]