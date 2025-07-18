[
    {
        "function_name": "setShare",
        "code": "function setShare(address shareholder, uint256 amount) external override onlyToken { if(shares[shareholder].amount > 0){ distributeDividend(shareholder); } if(amount > 0 && shares[shareholder].amount == 0){ addShareholder(shareholder); }else if(amount == 0 && shares[shareholder].amount > 0){ removeShareholder(shareholder); } totalShares = totalShares.sub(shares[shareholder].amount).add(amount); shares[shareholder].amount = amount; shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount); }",
        "vulnerability": "Incorrect handling of totalShares",
        "reason": "The function incorrectly updates `totalShares` by subtracting the previous share amount and adding the new amount without considering edge cases where `amount` may be zero. This could lead to incorrect `totalShares` calculation, allowing attackers to manipulate the shares and dividends distribution.",
        "file_name": "0x08cce68cfe23bbf13e3151c2a43dcc02623710d6.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal lockTheSwap { uint256 tokenBalance = _balances[address(this)]; uint256 tokensForLiquidity = tokenBalance.mul(toLiquidity).div(100).div(2); uint256 amountToSwap = tokenBalance.sub(tokensForLiquidity); swapTokensForEth(amountToSwap); uint256 totalEthBalance = address(this).balance; uint256 ethForDigitalGold = totalEthBalance.mul(toReflections).div(100); uint256 ethForMarketing = totalEthBalance.mul(toMarketing).div(100); uint256 ethForLiquidity = totalEthBalance.mul(toLiquidity).div(100).div(2); if (totalEthBalance > 0){ payable(marketingWallet).transfer(ethForMarketing); } try moneyPrinter.deposit{value: ethForDigitalGold}() {} catch {} if (tokensForLiquidity > 0){ addLiquidity(tokensForLiquidity, ethForLiquidity); } }",
        "vulnerability": "Reentrancy in swapBack",
        "reason": "The function transfers ETH to the marketing wallet before interacting with the `moneyPrinter` contract. An attacker could exploit this reentrancy vulnerability by triggering a fallback function to manipulate state variables or conduct unauthorized actions within the same transaction.",
        "file_name": "0x08cce68cfe23bbf13e3151c2a43dcc02623710d6.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; emit OwnershipTransferred(adr); }",
        "vulnerability": "Unrestricted ownership transfer",
        "reason": "The function allows the current owner to transfer ownership to any address without any checks or constraints. This could result in the contract's control being transferred to a malicious address, causing loss of control over contract operations.",
        "file_name": "0x08cce68cfe23bbf13e3151c2a43dcc02623710d6.sol"
    }
]