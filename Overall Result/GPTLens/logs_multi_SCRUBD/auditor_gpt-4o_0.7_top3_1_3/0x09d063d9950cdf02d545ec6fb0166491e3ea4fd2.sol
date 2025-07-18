[
    {
        "function_name": "setDistributionCriteria",
        "code": "function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external override onlyToken {\n    minPeriod = newMinPeriod;\n    minDistribution = newMinDistribution;\n}",
        "vulnerability": "Lack of Access Control",
        "reason": "The function `setDistributionCriteria` can be called by any address that is set as `_token`, allowing them to adjust distribution criteria arbitrarily. If `_token` is compromised or set incorrectly, an attacker could manipulate distribution settings to their advantage.",
        "file_name": "0x09d063d9950cdf02d545ec6fb0166491e3ea4fd2.sol"
    },
    {
        "function_name": "deposit",
        "code": "function deposit() public payable override {\n    uint256 balanceBefore = IERC20(REVIVAL).balanceOf(address(this));\n    address[] memory path = new address[](2);\n    path[0] = router.WETH();\n    path[1] = address(REVIVAL);\n    router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}( 0, path, address(this), block.timestamp );\n    uint256 amount = IERC20(REVIVAL).balanceOf(address(this)).sub(balanceBefore);\n    totalDividends = totalDividends.add(amount);\n    dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));\n}",
        "vulnerability": "Reentrancy",
        "reason": "The `deposit` function is vulnerable to reentrancy attacks since it allows for arbitrary function calls by external contracts during the token swap process. If an attacker uses a token with a malicious fallback, they could potentially reenter the contract and manipulate state variables like `totalDividends`.",
        "file_name": "0x09d063d9950cdf02d545ec6fb0166491e3ea4fd2.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal lockTheSwap {\n    uint256 tokenBalance = _balances[address(this)];\n    uint256 tokensForLiquidity = tokenBalance.mul(toLiquidity).div(100).div(2);\n    uint256 amountToSwap = tokenBalance.sub(tokensForLiquidity);\n    swapTokensForEth(amountToSwap);\n    uint256 totalEthBalance = address(this).balance;\n    uint256 ethForREVIVAL = totalEthBalance.mul(toReflections).div(100);\n    uint256 ethForDev = totalEthBalance.mul(toMarketing).div(100);\n    uint256 ethForLiquidity = totalEthBalance.mul(toLiquidity).div(100).div(2);\n    if (totalEthBalance > 0){\n        payable(devWallet).transfer(ethForDev);\n    }\n    try bensRevival.deposit{value: ethForREVIVAL}() {} catch {}\n    if (tokensForLiquidity > 0){\n        addLiquidity(tokensForLiquidity, ethForLiquidity);\n    }\n}",
        "vulnerability": "Unchecked External Call",
        "reason": "In the `swapBack` function, the contract attempts to call `bensRevival.deposit{value: ethForREVIVAL}()` which can fail silently due to the try-catch block. If this call fails, any ETH meant for distribution will be locked in the contract, potentially causing a denial of service for reflection distribution.",
        "file_name": "0x09d063d9950cdf02d545ec6fb0166491e3ea4fd2.sol"
    }
]