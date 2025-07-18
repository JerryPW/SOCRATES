[
    {
        "function_name": "deposit",
        "code": "function deposit() public payable override { uint256 balanceBefore = IERC20(HAY).balanceOf(address(this)); address[] memory path = new address[](2); path[0] = router.WETH(); path[1] = address(HAY); router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}( 0, path, address(this), block.timestamp ); uint256 amount = IERC20(HAY).balanceOf(address(this)).sub(balanceBefore); totalDividends = totalDividends.add(amount); dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares)); }",
        "vulnerability": "Reentrancy Attack",
        "reason": "The deposit function allows for receiving ETH and swapping it to HAY tokens without reentrancy protection. Although the swap function itself is external and might not trigger reentrancy, other interactions could exploit this function by causing repeated deposits before the first call completes.",
        "file_name": "0x372bf2843c4e4e2f6f7fba9e2e6dbe6adf2b760f.sol"
    },
    {
        "function_name": "setShare",
        "code": "function setShare(address shareholder, uint256 amount) external override onlyToken { if(shares[shareholder].amount > 0){ distributeDividend(shareholder); } if(amount > 0 && shares[shareholder].amount == 0){ addShareholder(shareholder); }else if(amount == 0 && shares[shareholder].amount > 0){ removeShareholder(shareholder); } totalShares = totalShares.sub(shares[shareholder].amount).add(amount); shares[shareholder].amount = amount; shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount); }",
        "vulnerability": "Potential Overflows and Underflows",
        "reason": "The setShare function directly manipulates the totalShares without validating the potential for underflow or overflow when subtracting or adding shares. While SafeMath is used, logical errors or incorrect external calls can lead to inconsistent states or allow attackers to manipulate share distributions.",
        "file_name": "0x372bf2843c4e4e2f6f7fba9e2e6dbe6adf2b760f.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) { if (sender!= owner() && recipient!= owner()) require(tradingOpen, \"hold ur horses big guy.\"); require(!bots[sender] && !bots[recipient]); if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); } require(amount <= maxTx || isTxLimitExempt[sender], \"tx\"); if(!isTxLimitExempt[recipient] && antiBot) { require(_balances[recipient].add(amount) <= maxWallet, \"wallet\"); } if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); } _balances[sender] = _balances[sender].sub(amount, \"Insufficient Balance\"); uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount; _balances[recipient] = _balances[recipient].add(finalAmount); if(!isDividendExempt[sender]) { try hayReflections.setShare(sender, _balances[sender]) {} catch {} } if(!isDividendExempt[recipient]) { try hayReflections.setShare(recipient, _balances[recipient]) {} catch {} } emit Transfer(sender, recipient, finalAmount); return true; }",
        "vulnerability": "Potential Denial of Service through Gas Limit",
        "reason": "The _transfer function calls external contract functions like setShare within a try-catch block. This could potentially be exploited to cause a denial of service by continuously consuming the gas limit, preventing the function from completing other critical operations, especially if the external calls are expensive.",
        "file_name": "0x372bf2843c4e4e2f6f7fba9e2e6dbe6adf2b760f.sol"
    }
]