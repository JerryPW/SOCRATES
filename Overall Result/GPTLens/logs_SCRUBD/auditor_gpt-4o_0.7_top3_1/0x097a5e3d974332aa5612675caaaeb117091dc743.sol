[
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal lockTheSwap { uint256 tokenBalance = _balances[address(this)]; uint256 tokensForLiquidity = tokenBalance.mul(toLiquidity).div(100).div(2); uint256 amountToSwap = tokenBalance.sub(tokensForLiquidity); swapTokensForEth(amountToSwap); uint256 totalEthBalance = address(this).balance; uint256 ethForSHIL = totalEthBalance.mul(toReflections).div(100); uint256 ethForUncle = totalEthBalance.mul(toMarketing).div(100); uint256 ethForLiquidity = totalEthBalance.mul(toLiquidity).div(100).div(2); if (totalEthBalance > 0){ payable(uncleWallet).transfer(ethForUncle); } try coolUncle.deposit{value: ethForSHIL}() {} catch {} if (tokensForLiquidity > 0){ addLiquidity(tokensForLiquidity, ethForLiquidity); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The swapBack function transfers Ether to the uncleWallet before depositing it into the CoolUncle contract without updating the state first. This could potentially allow a reentrancy attack if the uncleWallet is a contract that calls back into swapBack.",
        "file_name": "0x097a5e3d974332aa5612675caaaeb117091dc743.sol"
    },
    {
        "function_name": "setOwnerWallet",
        "code": "function setOwnerWallet(address newOwnerWallet) internal { tokenOwner = newOwnerWallet; }",
        "vulnerability": "Improper access control",
        "reason": "The setOwnerWallet function is marked as internal and can be called by any function within the contract, potentially allowing unauthorized changes to the tokenOwner address without any restrictions.",
        "file_name": "0x097a5e3d974332aa5612675caaaeb117091dc743.sol"
    },
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner { launchedAt = block.number; tradingOpen = true; }",
        "vulnerability": "Front-running risk",
        "reason": "The openTrading function allows anyone with knowledge of the impending call to front-run trades, as it opens trading without any delay or mechanism to prevent bots from exploiting this opportunity.",
        "file_name": "0x097a5e3d974332aa5612675caaaeb117091dc743.sol"
    }
]