[
    {
        "function_name": "rescueDividends",
        "code": "function rescueDividends(address to) external onlyToken {\n    RewardToken.transfer(to, RewardToken.balanceOf(address(this)));\n}",
        "vulnerability": "Unrestricted access to all dividends",
        "reason": "The `rescueDividends` function allows the token contract to transfer all RewardTokens from the dividend distributor contract to an arbitrary address without any restriction on the amount or checks on the purpose. This can be exploited by an attacker with control over the token contract to drain the dividend balance entirely, preventing rightful shareholders from receiving their dividends.",
        "file_name": "0x3848d38145ef835b7570768dbc98a3d8ceb46cd5.sol"
    },
    {
        "function_name": "setRewardToken",
        "code": "function setRewardToken(address _rewardToken) external _onlyOwner {\n    dividendDistributor.setRewardToken(_rewardToken);\n}",
        "vulnerability": "Arbitrary reward token change",
        "reason": "The `setRewardToken` function allows the contract owner to arbitrarily change the reward token for the dividend distribution. An attacker who gains control over the owner's account can change the reward token to a different token with no value or a malicious token, which can disrupt the intended functioning of the dividend distribution and potentially defraud shareholders of their expected rewards.",
        "file_name": "0x3848d38145ef835b7570768dbc98a3d8ceb46cd5.sol"
    },
    {
        "function_name": "_transferFrom",
        "code": "function _transferFrom( address sender, address recipient, uint256 amount ) internal returns (bool) {\n    if (inSwapAndLiquify) {\n        return _basicTransfer(sender, recipient, amount);\n    }\n    if(normalTransferAddress[sender]==true){\n        return _basicTransfer(sender, recipient, amount);\n    }\n    require( amount <= _maxTxAmount || isTxLimitExempt[sender], \"TX Limit Exceeded\" );\n    if ( msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold ) {\n        swapBack();\n    }\n    if (!launched() && recipient == pair) {\n        require(_balances[sender] > 0);\n        launch();\n    }\n    if (recipient != pair && sender != pair) {\n        return _basicTransfer(sender, recipient, amount);\n    }\n    _balances[sender] = _balances[sender].sub( amount, \"Insufficient Balance\" );\n    if (!isTxLimitExempt[recipient] && restrictWhales) {\n        require(_balances[recipient].add(amount) <= _walletMax);\n    }\n    uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;\n    _balances[recipient] = _balances[recipient].add(finalAmount);\n    if (!isDividendExempt[sender]) {\n        try dividendDistributor.setShare(sender, _balances[sender]) {} catch {}\n    }\n    if (!isDividendExempt[recipient]) {\n        try dividendDistributor.setShare(recipient, _balances[recipient]) {} catch {}\n    }\n    try dividendDistributor.process(distributorGas) {} catch {}\n    emit Transfer(sender, recipient, finalAmount);\n    return true;\n}",
        "vulnerability": "Potential bypass of fee and limits",
        "reason": "The `_transferFrom` function contains conditions that may allow certain transfers to bypass fees and limits. If a sender is marked as a `normalTransferAddress`, the transfer will execute as a basic transfer without enforcing transaction limits or fees. This can be exploited by marking an arbitrary address as `normalTransferAddress`, allowing it to transfer tokens without incurring fees, disrupting the tokenomics and potentially leading to loss of revenue for the contract.",
        "file_name": "0x3848d38145ef835b7570768dbc98a3d8ceb46cd5.sol"
    }
]