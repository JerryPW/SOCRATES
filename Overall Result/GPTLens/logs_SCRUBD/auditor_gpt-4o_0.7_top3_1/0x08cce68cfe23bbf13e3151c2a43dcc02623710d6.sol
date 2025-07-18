[
    {
        "function_name": "setDistributionCriteria",
        "code": "function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external onlyOwner { moneyPrinter.setDistributionCriteria(newMinPeriod, newMinDistribution); }",
        "vulnerability": "Improper Access Control",
        "reason": "The function 'setDistributionCriteria' is onlyOwner, which allows the contract owner to set new distribution criteria. However, this can be manipulated by the owner to set arbitrary values that may disrupt or prevent the distribution process, potentially leading to a denial of service for other shareholders.",
        "file_name": "0x08cce68cfe23bbf13e3151c2a43dcc02623710d6.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal lockTheSwap { uint256 tokenBalance = _balances[address(this)]; uint256 tokensForLiquidity = tokenBalance.mul(toLiquidity).div(100).div(2); uint256 amountToSwap = tokenBalance.sub(tokensForLiquidity); swapTokensForEth(amountToSwap); uint256 totalEthBalance = address(this).balance; uint256 ethForDigitalGold = totalEthBalance.mul(toReflections).div(100); uint256 ethForMarketing = totalEthBalance.mul(toMarketing).div(100); uint256 ethForLiquidity = totalEthBalance.mul(toLiquidity).div(100).div(2); if (totalEthBalance > 0){ payable(marketingWallet).transfer(ethForMarketing); } try moneyPrinter.deposit{value: ethForDigitalGold}() {} catch {} if (tokensForLiquidity > 0){ addLiquidity(tokensForLiquidity, ethForLiquidity); } }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function 'swapBack' transfers ETH to the marketing wallet without any checks after the transfer. An attacker could potentially exploit this by reentering the contract through recursive calls, especially if the recipient is a contract that can perform further actions upon receiving ETH.",
        "file_name": "0x08cce68cfe23bbf13e3151c2a43dcc02623710d6.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; emit OwnershipTransferred(adr); }",
        "vulnerability": "Ownership Transfer to Arbitrary Address",
        "reason": "The function 'transferOwnership' allows the current owner to transfer ownership to any arbitrary address without any checks (e.g., non-zero address check). This can potentially lead to the loss of control over the contract if the owner accidentally or maliciously transfers ownership to an incorrect or malicious address.",
        "file_name": "0x08cce68cfe23bbf13e3151c2a43dcc02623710d6.sol"
    }
]