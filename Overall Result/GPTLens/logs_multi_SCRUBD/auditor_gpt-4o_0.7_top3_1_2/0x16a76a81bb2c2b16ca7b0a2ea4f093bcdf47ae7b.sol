[
    {
        "function_name": "_transfer",
        "code": "function _transfer( address sender, address recipient, uint256 amount ) private { require(sender != address(0), 'ERC20: transfer from the zero address'); require(recipient != address(0), 'ERC20: transfer to the zero address'); require(amount > 0, 'Transfer amount must be greater than zero'); if (sender != owner() && recipient != owner()) require( amount <= _maxTxAmount, 'Transfer amount exceeds the maxTxAmount.' ); uint256 contractTokenBalance = balanceOf(address(this)); if (contractTokenBalance >= _maxTxAmount) { contractTokenBalance = _maxTxAmount; } bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam; if ( !inSwap && swapEnabled && overMinTokenBalance && (recipient == uniswapV2Pair || _isUniswapPair[recipient]) ) { swapTokensForEth(contractTokenBalance); uint256 contractETHBalance = address(this).balance; if (contractETHBalance > 0) { sendETHToTeam(address(this).balance); } } bool takeFee = false; if ( (sender == uniswapV2Pair || recipient == uniswapV2Pair || _isUniswapPair[recipient] || _isUniswapPair[sender]) && !(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) ) { takeFee = true; } _tokenTransfer(sender, recipient, amount, takeFee); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function allows swapping tokens for ETH and sending ETH to team addresses within the same function without implementing reentrancy protection. This could be exploited if an attacker uses a contract to re-enter the function during the ETH transfer, possibly manipulating contract state or balances.",
        "file_name": "0x16a76a81bb2c2b16ca7b0a2ea4f093bcdf47ae7b.sol"
    },
    {
        "function_name": "Airdrop",
        "code": "function Airdrop(AirdropReceiver[] memory recipients) external onlyOwner { for (uint256 _i = 0; _i < recipients.length; _i++) { AirdropReceiver memory _user = recipients[_i]; transferFrom(msg.sender, _user.addy, _user.amount); } }",
        "vulnerability": "Lack of input validation",
        "reason": "The Airdrop function lacks input validation for the recipients array, which could lead to excessive gas costs or out-of-gas exceptions if the array is too large. Additionally, there is no check on the total token amount to be airdropped, which could result in transfers exceeding the sender's balance or allowance.",
        "file_name": "0x16a76a81bb2c2b16ca7b0a2ea4f093bcdf47ae7b.sol"
    },
    {
        "function_name": "sendETHToTeam",
        "code": "function sendETHToTeam(uint256 amount) private { _MCCWalletAddress.call{ value: amount.div(2) }(''); _marketingWalletAddress.call{ value: amount.div(2) }(''); }",
        "vulnerability": "Potential for failed ETH transfers",
        "reason": "The function uses low-level call to transfer ETH, which does not handle failures. If the transfer fails, it does not revert the transaction, potentially leading to loss of funds or inconsistent state where ETH is deducted but not received by the intended recipient.",
        "file_name": "0x16a76a81bb2c2b16ca7b0a2ea4f093bcdf47ae7b.sol"
    }
]