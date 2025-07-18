[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom( address sender, address recipient, uint256 amount ) external override returns (bool) { _transfer(sender, recipient, amount); uint256 currentAllowance = _allowances[sender][msg.sender]; require(currentAllowance >= amount); if (currentAllowance == INFINITY_ALLOWANCE) return true; unchecked { _approve(sender, msg.sender, currentAllowance - amount); } return true; }",
        "vulnerability": "Allowance bypass with INFINITY_ALLOWANCE.",
        "reason": "The function allows transferring tokens without reducing allowance if it's set to INFINITY_ALLOWANCE (2**256 - 1). While this seems to be an optimization, it effectively provides a bypass that can be exploited if the allowance is not intended to be infinite.",
        "file_name": "0x13ee0099f47a84bb4ab4cce741326b2976eda776.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer( address from, address to, uint256 amount ) internal virtual { uint256 senderBalance = _balances[from]; require(senderBalance >= amount); unchecked { _balances[from] = senderBalance - amount; } _balances[to] += amount; emit Transfer(from, to, amount); }",
        "vulnerability": "Lack of input validation and unchecked arithmetic.",
        "reason": "The function doesn't check for zero address for 'to', which could lead to tokens being locked if accidentally sent to the zero address. Additionally, while underflow is prevented by the require statement, overflow in '_balances[to] += amount' is not checked, potentially causing integer overflow in older versions of Solidity.",
        "file_name": "0x13ee0099f47a84bb4ab4cce741326b2976eda776.sol"
    },
    {
        "function_name": "_swapTokensForEthOnTransfer",
        "code": "function _swapTokensForEthOnTransfer( uint256 transferAmount, uint256 swapCount, IUniswapV2Router02 _uniswapV2Router ) internal { if (swapCount == 0) return; uint256 maxSwapCount = 2 * transferAmount; if (swapCount > maxSwapCount) swapCount = maxSwapCount; _swapTokensForEth(swapCount, _uniswapV2Router); }",
        "vulnerability": "Potential excessive swapping leading to price manipulation.",
        "reason": "The function allows swapping up to twice the transfer amount without clear indication of the necessity, which could be exploited to manipulate token prices on DEX platforms by creating artificial buy/sell pressure.",
        "file_name": "0x13ee0099f47a84bb4ab4cce741326b2976eda776.sol"
    }
]