[
    {
        "function_name": "_transfer",
        "code": "function _transfer( address sender, address recipient, uint256 amount ) private { require(sender != address(0), 'ERC20: transfer from the zero address'); require(recipient != address(0), 'ERC20: transfer to the zero address'); require(amount > 0, 'Transfer amount must be greater than zero'); if (sender != owner() && recipient != owner()) require( amount <= _maxTxAmount, 'Transfer amount exceeds the maxTxAmount.' ); uint256 contractTokenBalance = balanceOf(address(this)); if (contractTokenBalance >= _maxTxAmount) { contractTokenBalance = _maxTxAmount; } bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam; if ( !inSwap && swapEnabled && overMinTokenBalance && (recipient == uniswapV2Pair || _isUniswapPair[recipient]) ) { swapTokensForEth(contractTokenBalance); uint256 contractETHBalance = address(this).balance; if (contractETHBalance > 0) { sendETHToTeam(address(this).balance); } } bool takeFee = false; if ( (sender == uniswapV2Pair || recipient == uniswapV2Pair || _isUniswapPair[recipient] || _isUniswapPair[sender]) && !(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) ) { takeFee = true; } _tokenTransfer(sender, recipient, amount, takeFee); }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function does not use the checks-effects-interactions pattern, allowing potential reentrancy attacks when calling external contracts during token swaps and ETH transfers.",
        "file_name": "0x16a76a81bb2c2b16ca7b0a2ea4f093bcdf47ae7b.sol"
    },
    {
        "function_name": "Airdrop",
        "code": "function Airdrop(AirdropReceiver[] memory recipients) external onlyOwner { for (uint256 _i = 0; _i < recipients.length; _i++) { AirdropReceiver memory _user = recipients[_i]; transferFrom(msg.sender, _user.addy, _user.amount); } }",
        "vulnerability": "Lack of Input Validation",
        "reason": "The function does not validate the recipients' addresses or amounts, potentially allowing incorrect or malicious inputs. This could lead to airdropping tokens to unintended or non-existent addresses.",
        "file_name": "0x16a76a81bb2c2b16ca7b0a2ea4f093bcdf47ae7b.sol"
    },
    {
        "function_name": "manualSwap",
        "code": "function manualSwap() external onlyOwner { uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Owner Centralization Risk",
        "reason": "The owner can manually trigger token swaps, leading to potential abuse or manipulation of token price and liquidity. This centralizes control and can be exploited if the owner is malicious or compromised.",
        "file_name": "0x16a76a81bb2c2b16ca7b0a2ea4f093bcdf47ae7b.sol"
    }
]