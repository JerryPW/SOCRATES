[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address sender, address recipient, uint amount) public override returns (bool) { require(_msgSender() != address(0)); require(sender != address(0)); _transfer(sender, recipient, amount); _allowance[sender][_msgSender()] = _allowance[sender][_msgSender()].sub(amount); return true; }",
        "vulnerability": "Missing allowance check",
        "reason": "The function does not check if the allowance is sufficient before performing the transfer. This allows a spender to possibly transfer more tokens than they are allowed to, resulting in unauthorized token transfers.",
        "file_name": "0x04e52df738e0c13bc58d6d75f964381f8d18b1b7.sol"
    },
    {
        "function_name": "getFee",
        "code": "function getFee(uint256 amount) private view returns(uint256) { uint256 fee = amount.mul(_totalFeePercent).div(_totalSupply); return fee; }",
        "vulnerability": "Incorrect fee calculation",
        "reason": "The fee is calculated using the total supply instead of a percentage of the transaction amount. This leads to incorrect fee deductions, potentially causing financial discrepancies and unfair charge distributions.",
        "file_name": "0x04e52df738e0c13bc58d6d75f964381f8d18b1b7.sol"
    },
    {
        "function_name": "swapTokensForEth",
        "code": "function swapTokensForEth(uint256 tokenAmount) private lockTheSwap { address[] memory path = new address[](2); path[0] = address(this); path[1] = uniswapV2Router.WETH(); _approve(address(this), address(uniswapV2Router), tokenAmount); uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( tokenAmount, 0, path, address(this), block.timestamp ); }",
        "vulnerability": "Unprotected swap call",
        "reason": "The function lacks access control and can potentially be called in scenarios that could manipulate token and ETH reserves, leading to front-running attacks and unfair ETH extraction from the contract.",
        "file_name": "0x04e52df738e0c13bc58d6d75f964381f8d18b1b7.sol"
    }
]