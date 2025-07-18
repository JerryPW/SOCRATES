[
    {
        "function_name": "removeOrder",
        "code": "function removeOrder(uint256 indexOfOrder) public { if (indexOfOrder >= _userActions.length) return; require(_userActions[indexOfOrder].user == msg.sender || msg.sender == owner() || msg.sender == address(this)); if(msg.sender != address(this)){ _userActions[indexOfOrder].user.call{value: _transactionFee}(\"\"); } for (uint i = indexOfOrder; i<_userActions.length-1; i++){ _userActions[i] = _userActions[i+1]; } _userActions.pop(); }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function uses a call, which sends ether and allows the recipient to execute code before the state variables are updated. This could be exploited for reentrant attacks because the state update occurs after the external call.",
        "file_name": "0x12d82d7cf17d909fb5808707136200ed200b6d52.sol"
    },
    {
        "function_name": "submitOrder",
        "code": "function submitOrder(uint256 amount, uint256 deadline, bool deposit) public payable{ if(deposit){ require(msg.value > _transactionFee); require(acceptingNewDeposits == true); IWETH WETHContract = IWETH(WETHAddress); WETHContract.deposit{value: msg.value - _transactionFee}(); IERC20(WETHAddress).transfer(msg.sender, msg.value - _transactionFee); } else { require(amount <= balanceOf(msg.sender)); require(msg.value == _transactionFee); } _userActions.push(userInteractionInfo(msg.sender, deposit ? msg.value - _transactionFee : amount, deposit, deadline)); }",
        "vulnerability": "Incorrect Ether Handling",
        "reason": "In the deposit branch, the contract refunds WETH to the sender instead of keeping it within the contract. This could allow users to effectively bypass the deposit mechanism by exploiting the transfer call.",
        "file_name": "0x12d82d7cf17d909fb5808707136200ed200b6d52.sol"
    },
    {
        "function_name": "_swapTokens",
        "code": "function _swapTokens(address[] memory v2Path, bytes memory v3Path, uint256 amountIn, uint256 amountOutMinimum) internal returns (uint256) { address tokenIn; address tokenOut; bytes memory packedBytes; if(v2Path.length > 0){ tokenIn = v2Path[0]; tokenOut = v2Path[v2Path.length - 1]; } else { (tokenIn, tokenOut, packedBytes) = InvestmentLibrary.getInAndOutTokenAndPack(v3Path); } if(tokenIn != WETHAddress && IERC20(tokenIn).balanceOf(address(this)) - amountIn == 0 && InvestmentLibrary.isTokenHeld(_tokensHeld, tokenIn) == true){ _removeAddressFromTokensHeld(tokenIn); } if(tokenOut != WETHAddress && IERC20(tokenOut).balanceOf(address(this)) == 0 && InvestmentLibrary.isTokenHeld(_tokensHeld, tokenOut) == false){ _tokensHeld.push(tokenOut); } if(v2Path.length > 0){ uint256 balanceOfTokenBeforeSwap = IERC20(v2Path[v2Path.length - 1]).balanceOf(address(this)); IERC20(v2Path[0]).approve(address(uniswapV2Router), amountIn); uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens( amountIn, amountOutMinimum, v2Path, address(this), block.timestamp ); return IERC20(v2Path[v2Path.length - 1]).balanceOf(address(this)) - balanceOfTokenBeforeSwap; } else { IERC20(tokenIn).approve(address(swapRouter), amountIn); ISwapRouter.ExactInputParams memory params = ISwapRouter.ExactInputParams( packedBytes, address(this), block.timestamp, amountIn, amountOutMinimum ); return swapRouter.exactInput(params); } }",
        "vulnerability": "Approval Race Condition",
        "reason": "There is a potential race condition where the approved amount can be changed by an attacker before the swap occurs, leading to unexpected behavior or loss of funds.",
        "file_name": "0x12d82d7cf17d909fb5808707136200ed200b6d52.sol"
    }
]