[
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) { require(amount > 0, \"Cannot withdraw 0\"); require(_balances[msg.sender].sub(amount) >= minLp || _balances[msg.sender].sub(amount) == 0, \"wrong amount\"); _totalSupply = _totalSupply.sub(amount); _balances[msg.sender] = _balances[msg.sender].sub(amount); uint256 fee = amount.div(feeRate); stakingToken.transfer(0x1111111111111111111111111111111111111111, fee); stakingToken.transfer(msg.sender, amount.sub(fee)); emit Withdrawn(msg.sender, amount); }",
        "vulnerability": "Fixed Fee Transfer to Null Address",
        "reason": "The fee calculated during withdrawal is sent to the hardcoded address '0x1111111111111111111111111111111111111111' which is a null address. This effectively burns the fee amount, which may not be the intended behavior. Additionally, it prevents any use of the fee for treasury or operational purposes.",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    },
    {
        "function_name": "swapExactETHForTokens",
        "code": "function swapExactETHForTokens(uint amountEth) internal { uniswap.swapExactETHForTokens.value(amountEth)(0, getPathForTokenToEth(address(NDR)), address(this), now + deadline); }",
        "vulnerability": "Usage of deprecated .value() syntax",
        "reason": "The function uses the deprecated `.value()` syntax for sending ETH along with a function call, which is not supported in Solidity 0.6.0 and above. This will cause the contract to fail when executing this function, leading to a denial of service for any functionality that relies on this swap.",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    },
    {
        "function_name": "addLiquidityETH",
        "code": "function addLiquidityETH(uint amountTokenDesired, uint amountEth) internal { IERC20(NDR).approve(address(uniswap), amountTokenDesired); uint amountADesired = getAmountsOut(amountEth, NDR); (uint amountTokenMin,) = quote(amountADesired, amountEth); uniswap.addLiquidityETH.value(amountEth) (address(NDR), amountTokenDesired, amountTokenMin, amountEth, address(0), now + deadline); }",
        "vulnerability": "Usage of deprecated .value() syntax",
        "reason": "Similar to the swapExactETHForTokens function, this function also uses the deprecated `.value()` syntax for sending ETH with a function call, which is not supported in Solidity 0.6.0 and above. This will lead to a failure in executing the function, rendering the liquidity addition functionality unusable.",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    }
]