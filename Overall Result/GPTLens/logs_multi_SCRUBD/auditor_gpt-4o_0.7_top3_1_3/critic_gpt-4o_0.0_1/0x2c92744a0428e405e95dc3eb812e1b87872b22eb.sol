[
    {
        "function_name": "withdraw",
        "vulnerability": "Fixed Fee Transfer to Null Address",
        "criticism": "The reasoning is correct in identifying that the fee is sent to a null address, effectively burning the fee. This may not be the intended behavior if the fee is meant for operational or treasury purposes. The severity is moderate as it affects the contract's financial operations, but it does not directly harm users. The profitability is low because an external attacker cannot exploit this for financial gain.",
        "correctness": 8,
        "severity": 5,
        "profitability": 0,
        "reason": "The fee calculated during withdrawal is sent to the hardcoded address '0x1111111111111111111111111111111111111111' which is a null address. This effectively burns the fee amount, which may not be the intended behavior. Additionally, it prevents any use of the fee for treasury or operational purposes.",
        "code": "function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) { require(amount > 0, \"Cannot withdraw 0\"); require(_balances[msg.sender].sub(amount) >= minLp || _balances[msg.sender].sub(amount) == 0, \"wrong amount\"); _totalSupply = _totalSupply.sub(amount); _balances[msg.sender] = _balances[msg.sender].sub(amount); uint256 fee = amount.div(feeRate); stakingToken.transfer(0x1111111111111111111111111111111111111111, fee); stakingToken.transfer(msg.sender, amount.sub(fee)); emit Withdrawn(msg.sender, amount); }",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    },
    {
        "function_name": "swapExactETHForTokens",
        "vulnerability": "Usage of deprecated .value() syntax",
        "criticism": "The reasoning is correct in identifying the use of the deprecated `.value()` syntax, which is not supported in Solidity 0.6.0 and above. This will cause the function to fail, leading to a denial of service for any functionality relying on this swap. The severity is high because it renders the function unusable, but the profitability is low as it does not provide a direct financial benefit to an attacker.",
        "correctness": 9,
        "severity": 7,
        "profitability": 0,
        "reason": "The function uses the deprecated `.value()` syntax for sending ETH along with a function call, which is not supported in Solidity 0.6.0 and above. This will cause the contract to fail when executing this function, leading to a denial of service for any functionality that relies on this swap.",
        "code": "function swapExactETHForTokens(uint amountEth) internal { uniswap.swapExactETHForTokens.value(amountEth)(0, getPathForTokenToEth(address(NDR)), address(this), now + deadline); }",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    },
    {
        "function_name": "addLiquidityETH",
        "vulnerability": "Usage of deprecated .value() syntax",
        "criticism": "The reasoning is correct in identifying the use of the deprecated `.value()` syntax, similar to the swapExactETHForTokens function. This will lead to a failure in executing the function, rendering the liquidity addition functionality unusable. The severity is high due to the impact on the contract's functionality, but the profitability is low as it does not provide a direct financial benefit to an attacker.",
        "correctness": 9,
        "severity": 7,
        "profitability": 0,
        "reason": "Similar to the swapExactETHForTokens function, this function also uses the deprecated `.value()` syntax for sending ETH with a function call, which is not supported in Solidity 0.6.0 and above. This will lead to a failure in executing the function, rendering the liquidity addition functionality unusable.",
        "code": "function addLiquidityETH(uint amountTokenDesired, uint amountEth) internal { IERC20(NDR).approve(address(uniswap), amountTokenDesired); uint amountADesired = getAmountsOut(amountEth, NDR); (uint amountTokenMin,) = quote(amountADesired, amountEth); uniswap.addLiquidityETH.value(amountEth) (address(NDR), amountTokenDesired, amountTokenMin, amountEth, address(0), now + deadline); }",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    }
]