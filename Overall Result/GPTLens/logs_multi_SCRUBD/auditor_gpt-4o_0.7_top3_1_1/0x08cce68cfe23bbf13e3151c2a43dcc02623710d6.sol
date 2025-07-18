[
    {
        "function_name": "setShare",
        "code": "function setShare(address shareholder, uint256 amount) external override onlyToken { if(shares[shareholder].amount > 0){ distributeDividend(shareholder); } if(amount > 0 && shares[shareholder].amount == 0){ addShareholder(shareholder); }else if(amount == 0 && shares[shareholder].amount > 0){ removeShareholder(shareholder); } totalShares = totalShares.sub(shares[shareholder].amount).add(amount); shares[shareholder].amount = amount; shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount); }",
        "vulnerability": "Lack of Access Control",
        "reason": "The setShare function can be called by any address set as the _token. If an attacker gains control over the _token address or if it's not properly protected, they can manipulate the shares and effectively drain dividends or manipulate the distribution, leading to unfair distribution or theft.",
        "file_name": "0x08cce68cfe23bbf13e3151c2a43dcc02623710d6.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal lockTheSwap { uint256 tokenBalance = _balances[address(this)]; uint256 tokensForLiquidity = tokenBalance.mul(toLiquidity).div(100).div(2); uint256 amountToSwap = tokenBalance.sub(tokensForLiquidity); swapTokensForEth(amountToSwap); uint256 totalEthBalance = address(this).balance; uint256 ethForDigitalGold = totalEthBalance.mul(toReflections).div(100); uint256 ethForMarketing = totalEthBalance.mul(toMarketing).div(100); uint256 ethForLiquidity = totalEthBalance.mul(toLiquidity).div(100).div(2); if (totalEthBalance > 0){ payable(marketingWallet).transfer(ethForMarketing); } try moneyPrinter.deposit{value: ethForDigitalGold}() {} catch {} if (tokensForLiquidity > 0){ addLiquidity(tokensForLiquidity, ethForLiquidity); } }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The swapBack function involves calling an external contract (moneyPrinter.deposit), which could potentially be exploited with a reentrancy attack. Although a lockTheSwap modifier is used, if any external call within the deposit function re-enters the contract, it could cause unexpected behavior or manipulation of Ether balance.",
        "file_name": "0x08cce68cfe23bbf13e3151c2a43dcc02623710d6.sol"
    },
    {
        "function_name": "transfer",
        "code": "function transfer(address recipient, uint256 amount) external override returns (bool) { return _transfer(msg.sender, recipient, amount); }",
        "vulnerability": "Lack of Reentrancy Guard",
        "reason": "The transfer function calls the internal _transfer function, which involves transferring tokens and updating balances. Without a reentrancy guard on the transfer function itself, there's a potential for reentrancy attacks if any token transfer hooks or callbacks are implemented in future updates or integrations, allowing attackers to manipulate balances during the transaction process.",
        "file_name": "0x08cce68cfe23bbf13e3151c2a43dcc02623710d6.sol"
    }
]