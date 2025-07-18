[
    {
        "function_name": "transfer",
        "code": "function transfer(address recipient, uint256 amount) external override returns (bool){ _transfer(_msgSender(), recipient, amount); return true; }",
        "vulnerability": "Lack of Access Control",
        "reason": "The transfer function does not enforce any user-specific conditions beyond those in _transfer. As a result, funds can be transferred to any recipient including blacklisted addresses unless explicitly checked in _transfer. The contract relies on boolean flags, which can be manipulated if not properly protected.",
        "file_name": "0x052f4e43d9d65ca35ce6d3438aa956fda91ef520.sol"
    },
    {
        "function_name": "_beforeTokenTransfer",
        "code": "function _beforeTokenTransfer(address recipient) private { if ( !isInPresale ){ uint256 contractTokenBalance = balanceOf(address(this)); bool canSwap = contractTokenBalance >= swapTokensAtAmount; if (!swapping && canSwap && swapEnabled && recipient == pair) { swapping = true; swapBack(); swapping = false; } } }",
        "vulnerability": "Reentrancy",
        "reason": "The _beforeTokenTransfer function sets the swapping state to true and performs a swapBack operation. If the swapBack function or any function it calls makes an external call, there is a risk of reentrancy. The nonReentrant modifier is not applied, which could lead to reentrant attacks exploiting this swap logic.",
        "file_name": "0x052f4e43d9d65ca35ce6d3438aa956fda91ef520.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() private nonReentrant { uint256 splitLiquidityPortion = lpPortionOfSwap.div(2); uint256 amountToLiquify = balanceOf(address(this)).mul(splitLiquidityPortion).div(FEES_DIVISOR); uint256 amountToSwap = balanceOf(address(this)).sub(amountToLiquify); uint256 balanceBefore = address(this).balance; swapTokensForETH(amountToSwap); uint256 amountBNB = address(this).balance.sub(balanceBefore); uint256 amountBNBMarketing = amountBNB.mul(marketingPortionOfSwap).div(FEES_DIVISOR); uint256 amountBNBDevolpment = amountBNB.mul(devolpmentPortionOfSwap).div(FEES_DIVISOR); uint256 amountBNBLiquidity = amountBNB.mul(splitLiquidityPortion).div(FEES_DIVISOR); transferToAddress(payable(marketingWallet), amountBNBMarketing); transferToAddress(payable(devolpmentWallet), amountBNBDevolpment); _addLiquidity(amountToLiquify, amountBNBLiquidity); }",
        "vulnerability": "Potential Loss of Funds",
        "reason": "The swapBack function performs multiple operations that depend on the contract's balance and the amounts calculated from it. If the contract balance changes between these operations due to asynchronous calls, it could lead to incorrect fund distributions or missed liquidity additions. This risk is exacerbated if an attacker can manipulate the contract's balance externally between these steps.",
        "file_name": "0x052f4e43d9d65ca35ce6d3438aa956fda91ef520.sol"
    }
]