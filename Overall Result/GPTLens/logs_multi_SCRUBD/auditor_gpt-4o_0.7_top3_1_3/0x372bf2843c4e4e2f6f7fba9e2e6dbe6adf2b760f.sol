[
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal lockTheSwap { uint256 tokenBalance = _balances[address(this)]; uint256 tokensForLiquidity = tokenBalance.mul(toLiquidity).div(100).div(2); uint256 amountToSwap = tokenBalance.sub(tokensForLiquidity); swapTokensForEth(amountToSwap); uint256 totalEthBalance = address(this).balance; uint256 ethForHAY = totalEthBalance.mul(toReflections).div(100); uint256 ethForDev = totalEthBalance.mul(toMarketing).div(100); uint256 ethForLiquidity = totalEthBalance.mul(toLiquidity).div(100).div(2); if (totalEthBalance > 0){ payable(devWallet).transfer(ethForDev); } try hayReflections.deposit{value: ethForHAY}() {} catch {} if (tokensForLiquidity > 0){ addLiquidity(tokensForLiquidity, ethForLiquidity); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function `swapBack` transfers ETH to the `devWallet` before calling `hayReflections.deposit`. If the target contract or the devWallet is malicious, it could reenter the contract execution flow and potentially exploit the contract state, as the state is not fully updated before the transfer occurs.",
        "file_name": "0x372bf2843c4e4e2f6f7fba9e2e6dbe6adf2b760f.sol"
    },
    {
        "function_name": "setDistributionCriteria",
        "code": "function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external override onlyToken { minPeriod = newMinPeriod; minDistribution = newMinDistribution; }",
        "vulnerability": "Lack of input validation",
        "reason": "The function `setDistributionCriteria` allows the `_token` address to set arbitrary values for `minPeriod` and `minDistribution` without any validation. This could result in setting these parameters to values that could disrupt the dividend distribution logic, such as setting `minPeriod` to a very high value, effectively freezing distributions.",
        "file_name": "0x372bf2843c4e4e2f6f7fba9e2e6dbe6adf2b760f.sol"
    },
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner { launchedAt = block.number; tradingOpen = true; }",
        "vulnerability": "Centralization risk",
        "reason": "The function `openTrading` is controlled by the contract owner, meaning the owner has the sole authority to enable or disable trading. This introduces a centralization risk where the owner can potentially manipulate the market by controlling when trading is allowed, which can harm the decentralization ethos and trust in the token.",
        "file_name": "0x372bf2843c4e4e2f6f7fba9e2e6dbe6adf2b760f.sol"
    }
]