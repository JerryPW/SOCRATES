[
    {
        "function_name": "setDistributionCriteria",
        "code": "function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external override onlyToken { minPeriod = newMinPeriod; minDistribution = newMinDistribution; }",
        "vulnerability": "Insufficient Access Control",
        "reason": "The function can be called by any address with the token role, which can be manipulated by attackers if they gain control of the token contract. This could allow them to set distribution criteria to values that disrupt the expected dividend distribution mechanism.",
        "file_name": "0x372bf2843c4e4e2f6f7fba9e2e6dbe6adf2b760f.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal lockTheSwap { uint256 tokenBalance = _balances[address(this)]; uint256 tokensForLiquidity = tokenBalance.mul(toLiquidity).div(100).div(2); uint256 amountToSwap = tokenBalance.sub(tokensForLiquidity); swapTokensForEth(amountToSwap); uint256 totalEthBalance = address(this).balance; uint256 ethForHAY = totalEthBalance.mul(toReflections).div(100); uint256 ethForDev = totalEthBalance.mul(toMarketing).div(100); uint256 ethForLiquidity = totalEthBalance.mul(toLiquidity).div(100).div(2); if (totalEthBalance > 0){ payable(devWallet).transfer(ethForDev); } try hayReflections.deposit{value: ethForHAY}() {} catch {} if (tokensForLiquidity > 0){ addLiquidity(tokensForLiquidity, ethForLiquidity); } }",
        "vulnerability": "Potential Reentrancy",
        "reason": "The swapBack function transfers Ether to an external address (devWallet) and then calls the deposit function on the hayReflections contract. If the hayReflections contract allows reentrancy, this could lead to potential reentrancy attacks, where an attacker could exploit this to drain funds.",
        "file_name": "0x372bf2843c4e4e2f6f7fba9e2e6dbe6adf2b760f.sol"
    },
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner { launchedAt = block.number; tradingOpen = true; }",
        "vulnerability": "Insufficient Anti-bot Measures",
        "reason": "The openTrading function, once called, allows unrestricted trading. Without thorough anti-bot protections (e.g., bot whitelisting), bots could exploit the initial trading window to perform front-running or other malicious trading activities.",
        "file_name": "0x372bf2843c4e4e2f6f7fba9e2e6dbe6adf2b760f.sol"
    }
]