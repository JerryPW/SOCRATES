[
    {
        "function_name": "emergencyWithdrawToken",
        "code": "function emergencyWithdrawToken() external onlyOwner { require(_msgSender() != address(0), \"Vault: Invalid address\"); uint256 tokenAmount = _yzy.balanceOf(address(this)); require(tokenAmount > 0, \"Vault: Insufficient amount\"); _yzy.transfer(_msgSender(), tokenAmount); emit EmergencyWithdrawToken(address(this), _msgSender(), tokenAmount); }",
        "vulnerability": "Owner can withdraw all tokens",
        "reason": "The emergencyWithdrawToken function allows the contract owner to withdraw all YZY tokens from the contract. This centralizes power with the owner and poses a risk of rug pull, where the owner can drain the contract's funds, leaving other users with losses.",
        "file_name": "0x0a5a0a14419f9db1da68cf2f550720e5df49d4fe.sol"
    },
    {
        "function_name": "_sendLotteryAmount",
        "code": "function _sendLotteryAmount() internal returns (bool) { if (!_enabledLottery || _lotteryAmount <= 0) return false; uint256 usdcReserve = 0; uint256 ethReserve1 = 0; uint256 yzyReserve = 0; uint256 ethReserve2 = 0; address token0 = _usdcETHV2Pair.token0(); if (token0 == address(_weth)){ (ethReserve1, usdcReserve, ) = _usdcETHV2Pair.getReserves(); } else { (usdcReserve, ethReserve1, ) = _usdcETHV2Pair.getReserves(); } token0 = _yzyETHV2Pair.token0(); if (token0 == address(_weth)){ (ethReserve2, yzyReserve, ) = _yzyETHV2Pair.getReserves(); } else { (yzyReserve, ethReserve2, ) = _yzyETHV2Pair.getReserves(); } if (ethReserve1 <= 0 || yzyReserve <= 0) return false; uint256 yzyPrice = usdcReserve.mul(1 ether).div(ethReserve1).mul(ethReserve2).div(yzyReserve); uint256 lotteryValue = yzyPrice.mul(_lotteryAmount).div(1 ether); if (lotteryValue > 0 && lotteryValue >= _lotteryLimit) { uint256 amount = _lotteryLimit.mul(1 ether).div(yzyPrice); if (amount > _lotteryAmount) amount = _lotteryAmount; _yzy.transfer(_msgSender(), amount); _lotteryAmount = _lotteryAmount.sub(amount); _lotteryPaidOut = _lotteryPaidOut.add(amount); emit SentLotteryAmount(_msgSender(), amount, true); winnerInfo.push( WinnerInfo({ winner: _msgSender(), amount: amount, timestamp: block.timestamp }) ); } return false; }",
        "vulnerability": "Lottery payout manipulation",
        "reason": "The _sendLotteryAmount function can be manipulated by providing skewed reserve values through the getReserves calls of _usdcETHV2Pair and _yzyETHV2Pair. An attacker could manipulate the price of YZY to receive a larger lottery payout than intended by influencing the reserves in these pairs.",
        "file_name": "0x0a5a0a14419f9db1da68cf2f550720e5df49d4fe.sol"
    },
    {
        "function_name": "swapETHForTokens",
        "code": "function swapETHForTokens(uint256 ethAmount) private { address[] memory path = new address[](2); path[0] = _uniswapV2Router.WETH(); path[1] = address(_yzy); _uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{ value: ethAmount }(0, path, address(this), block.timestamp); }",
        "vulnerability": "Lack of slippage protection",
        "reason": "The function swapETHForTokens does not include a minimum amount of tokens to receive parameter, which makes it vulnerable to slippage attacks. An attacker could exploit this by manipulating the price of YZY between the time the transaction is signed and when it is mined, causing the user to receive fewer tokens than expected.",
        "file_name": "0x0a5a0a14419f9db1da68cf2f550720e5df49d4fe.sol"
    }
]