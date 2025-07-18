[
    {
        "function_name": "_transfer",
        "code": "function _transfer(address from, address to, uint256 amount) private { require(from != address(0), \"ERC20: transfer from the zero address\"); require(to != address(0), \"ERC20: transfer to the zero address\"); require(amount > 0, \"Transfer amount must be greater than zero\"); require(amount <= balanceOf(from),\"You are trying to transfer more than your balance\"); require(!_isBot[from] && !_isBot[to], \"Fuck you Bots\"); if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){ require(tradingEnabled, \"Trading is not enabled yet\"); } if( from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFee[to] && !_isExcludedFromFee[from] && from == pair){ require(amount <= maxBuyAmount, \"you are exceeding maxBuyAmount\"); uint256 walletCurrentBalance = balanceOf(to); require(walletCurrentBalance + amount <= _maxWalletSize, \"Exceeds maximum wallet token amount\"); } if( from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFee[to] && !_isExcludedFromFee[from] && from == pair){ require(amount <= maxSellAmount, \"Amount is exceeding maxSellAmount\"); } uint256 contractTokenBalance = balanceOf(address(this)); bool canSwap = contractTokenBalance >= swapTokensAtAmount; if(!swapping && swapEnabled && canSwap && from != pair){ uint256 balance = address(this).balance; if (buyBackEnabled && balance > uint256(1 * 10**18) && to == pair) { if (balance > buyBackUpperLimit) balance = buyBackUpperLimit; buyBackTokens(balance.div(100)); } swapAndLiquify(swapTokensAtAmount); } bool isSale; if(to == pair) isSale = true; _tokenTransfer(from, to, amount, !(_isExcludedFromFee[from] || _isExcludedFromFee[to]), isSale); }",
        "vulnerability": "Max sell amount check is incorrect",
        "reason": "The condition for checking if the amount exceeds maxSellAmount is incorrect. The condition should check whether 'from == pair' to determine if it is a sale, but it checks 'from == pair' both for buy and sell checks. It should be 'to == pair' for sell checks, making it possible for an attacker to bypass max sell restrictions by transferring tokens directly from another address.",
        "file_name": "0x0e50763fbbd9a2474c429041b338624bb2a8b7bd.sol"
    },
    {
        "function_name": "swapAndLiquify",
        "code": "function swapAndLiquify(uint256 tokens) private lockTheSwap{ uint256 denominator= (feeRates.liquidity + feeRates.buyback + feeRates.marketing ) * 2; uint256 tokensToAddLiquidityWith = tokens * feeRates.liquidity / denominator; uint256 toSwap = tokens - tokensToAddLiquidityWith; uint256 initialBalance = address(this).balance; swapTokensForBNB(toSwap); uint256 deltaBalance = address(this).balance - initialBalance; uint256 unitBalance= deltaBalance / (denominator - feeRates.liquidity); uint256 bnbToAddLiquidityWith = unitBalance * feeRates.liquidity; if(bnbToAddLiquidityWith > 0){ addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith); } uint256 marketingAmt = unitBalance * 2 * feeRates.marketing; if(marketingAmt > 0){ payable(marketingAddress).transfer(marketingAmt); } }",
        "vulnerability": "Incorrect handling of BNB balance for marketing",
        "reason": "The contract calculates marketing amount using 'unitBalance * 2 * feeRates.marketing', which can lead to excessive withdrawal of BNB if the denominator calculation or balance changes incorrectly. This can be exploited if the attacker manipulates the BNB balance or token amounts transferred, allowing them to drain funds intended for marketing.",
        "file_name": "0x0e50763fbbd9a2474c429041b338624bb2a8b7bd.sol"
    },
    {
        "function_name": "buyBackTokens",
        "code": "function buyBackTokens(uint256 amount) private lockTheSwap{ if (amount > 0) { swapETHForTokens(amount); } }",
        "vulnerability": "Buyback mechanism can be manipulated",
        "reason": "The function 'buyBackTokens' allows the contract to buy back tokens using BNB. However, there are no restrictions or cooldowns on how often this can occur, which could lead to market manipulation. An attacker could influence the token price by triggering buybacks at strategic times, causing price volatility and potential token value manipulation.",
        "file_name": "0x0e50763fbbd9a2474c429041b338624bb2a8b7bd.sol"
    }
]