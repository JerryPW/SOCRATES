[
    {
        "function_name": "transfer",
        "code": "function transfer(address recipient, uint256 amount) external override returns (bool) { _transfer(_msgSender(), recipient, amount); return true; }",
        "vulnerability": "Blacklist Bypass",
        "reason": "The _transfer function checks if an address is blacklisted before processing a transfer. However, the transfer function directly calls _transfer without verifying the sender's blacklist status, allowing blacklisted addresses to initiate transfers.",
        "file_name": "0x052f4e43d9d65ca35ce6d3438aa956fda91ef520.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() private nonReentrant { uint256 splitLiquidityPortion = lpPortionOfSwap.div(2); uint256 amountToLiquify = balanceOf(address(this)).mul(splitLiquidityPortion).div(FEES_DIVISOR); uint256 amountToSwap = balanceOf(address(this)).sub(amountToLiquify); uint256 balanceBefore = address(this).balance; swapTokensForETH(amountToSwap); uint256 amountBNB = address(this).balance.sub(balanceBefore); uint256 amountBNBMarketing = amountBNB.mul(marketingPortionOfSwap).div(FEES_DIVISOR); uint256 amountBNBDevolpment = amountBNB.mul(devolpmentPortionOfSwap).div(FEES_DIVISOR); uint256 amountBNBLiquidity = amountBNB.mul(splitLiquidityPortion).div(FEES_DIVISOR); transferToAddress(payable(marketingWallet), amountBNBMarketing); transferToAddress(payable(devolpmentWallet), amountBNBDevolpment); _addLiquidity(amountToLiquify, amountBNBLiquidity); }",
        "vulnerability": "Improper Fee Calculation",
        "reason": "The swapBack function calculates the fee distribution based on the entire contract balance, not just the portion meant for fees. This could result in incorrect fee allocations, especially if funds are sent to the contract outside of normal operations.",
        "file_name": "0x052f4e43d9d65ca35ce6d3438aa956fda91ef520.sol"
    },
    {
        "function_name": "transferToAddress",
        "code": "function transferToAddress(address payable recipient, uint256 amount) private { require(recipient != address(0), \"Cannot transfer the ETH to a zero address\"); recipient.transfer(amount); }",
        "vulnerability": "Unsafe External Call",
        "reason": "The transferToAddress function directly transfers ETH to a recipient without further checks or mechanisms to handle potential reentrancy issues. Although the function is marked private, it can still be invoked indirectly; also, using transfer is not recommended as it can lead to unexpected failures if the gas cost is higher.",
        "file_name": "0x052f4e43d9d65ca35ce6d3438aa956fda91ef520.sol"
    }
]