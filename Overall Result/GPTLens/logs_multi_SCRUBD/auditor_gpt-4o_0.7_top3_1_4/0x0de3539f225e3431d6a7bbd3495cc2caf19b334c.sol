[
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Privilege Escalation",
        "reason": "The `manualswap` function allows the address `_feeAddrWallet1` to swap any amount of tokens stored in the contract for ETH. This is a potential source of abuse if `_feeAddrWallet1` is compromised or if the owner misuses this function, leading to all held tokens being swapped for ETH without any restrictions.",
        "file_name": "0x0de3539f225e3431d6a7bbd3495cc2caf19b334c.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _feeAddrWallet1); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Privilege Escalation",
        "reason": "Similar to `manualswap`, the `manualsend` function allows `_feeAddrWallet1` to send all the ETH held by the contract to the fee addresses. This could be exploited if the fee address is compromised, allowing an attacker to drain all ETH in the contract.",
        "file_name": "0x0de3539f225e3431d6a7bbd3495cc2caf19b334c.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer(address from, address to, uint256 amount) private { require(from != address(0), \"ERC20: transfer from the zero address\"); require(to != address(0), \"ERC20: transfer to the zero address\"); require(amount > 0, \"Transfer amount must be greater than zero\"); _feeAddr1 = 12; _feeAddr2 = 8; if (from != owner() && to != owner()) { require(!bots[from] && !bots[to]); if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) { require(amount <= _maxTxAmount); require(cooldown[to] < block.timestamp); cooldown[to] = block.timestamp + (30 seconds); } if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) { _feeAddr1 = 12; _feeAddr2 = 8; } uint256 contractTokenBalance = balanceOf(address(this)); if (!inSwap && from != uniswapV2Pair && swapEnabled) { swapTokensForEth(contractTokenBalance); uint256 contractETHBalance = address(this).balance; if(contractETHBalance > 0) { sendETHToFee(address(this).balance); } } } _tokenTransfer(from,to,amount); }",
        "vulnerability": "Reentrancy",
        "reason": "The `_transfer` function, when calling `swapTokensForEth` and `sendETHToFee`, does not correctly handle reentrancy. If `swapEnabled` is true, and a malicious contract is able to transfer tokens to this contract, it could potentially reenter during the swap operation, causing unexpected behavior or draining of funds.",
        "file_name": "0x0de3539f225e3431d6a7bbd3495cc2caf19b334c.sol"
    }
]