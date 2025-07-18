[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address sender, address recipient, uint amount) public override returns (bool) { require(_msgSender() != address(0)); require(sender != address(0)); _transfer(sender, recipient, amount); _allowance[sender][_msgSender()] = _allowance[sender][_msgSender()].sub(amount); return true; }",
        "vulnerability": "Allowance double-spend vulnerability",
        "reason": "The function does not check if the amount to be transferred is less than or equal to the allowed amount. This could result in an allowance double-spend if the allowance is changed between the _transfer and allowance update. The allowance should be checked before executing the _transfer to ensure the sender's allowed amount is not exceeded.",
        "file_name": "0x04e52df738e0c13bc58d6d75f964381f8d18b1b7.sol"
    },
    {
        "function_name": "swapTokensForEth",
        "code": "function swapTokensForEth(uint256 tokenAmount) private lockTheSwap { address[] memory path = new address[](2); path[0] = address(this); path[1] = uniswapV2Router.WETH(); _approve(address(this), address(uniswapV2Router), tokenAmount); uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( tokenAmount, 0, path, address(this), block.timestamp ); }",
        "vulnerability": "Uncontrolled swap amount",
        "reason": "The swapTokensForEth function can be called with any token amount, allowing an attacker to swap excessive amounts of tokens. This can lead to draining the contract's token balance, especially since there is no upper limit or validation on tokenAmount. Implementing checks and limits on the tokenAmount parameter can mitigate this issue.",
        "file_name": "0x04e52df738e0c13bc58d6d75f964381f8d18b1b7.sol"
    },
    {
        "function_name": "sendETHToFee",
        "code": "function sendETHToFee(uint256 amount) private { (uint256 split1, uint256 split2, uint256 split3) = splitFee(amount); bool success = false; (success, ) = _sminemAddress.call{value: split1}(\"\"); require(success); (success, ) = _marketingAddress.call{value: split2}(\"\"); require(success); (success, ) = _devAddress.call{value: split3}(\"\"); require(success); }",
        "vulnerability": "Potential reentrancy vulnerability",
        "reason": "The function uses low-level call to transfer ETH to external addresses without implementing reentrancy guards. This opens up the potential for reentrancy attacks if one of the recipient addresses is malicious. Implementing reentrancy guards or using the checks-effects-interactions pattern can prevent such vulnerabilities.",
        "file_name": "0x04e52df738e0c13bc58d6d75f964381f8d18b1b7.sol"
    }
]