[
    {
        "function_name": "sendETHToFee",
        "code": "function sendETHToFee(uint256 amount) private { _feeAddrWallet1.transfer(amount.div(2)); _feeAddrWallet2.transfer(amount.div(2)); }",
        "vulnerability": "Potential Reentrancy",
        "reason": "The `sendETHToFee` function uses the `transfer` method to send Ether to two wallet addresses. This method forwards a fixed amount of gas (2300 gas), which is generally considered safe against reentrancy attacks. However, if the recipient contracts are malicious and designed to revert transactions or consume more than the allowed gas, this can still introduce potential issues in the contract, especially if logic is added after the transfer in future updates. This is not a severe vulnerability in itself but something to be aware of.",
        "file_name": "0x0de3539f225e3431d6a7bbd3495cc2caf19b334c.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer(address from, address to, uint256 amount) private { require(from != address(0), \"ERC20: transfer from the zero address\"); require(to != address(0), \"ERC20: transfer to the zero address\"); require(amount > 0, \"Transfer amount must be greater than zero\"); _feeAddr1 = 12; _feeAddr2 = 8; if (from != owner() && to != owner()) { require(!bots[from] && !bots[to]); if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) { require(amount <= _maxTxAmount); require(cooldown[to] < block.timestamp); cooldown[to] = block.timestamp + (30 seconds); } if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) { _feeAddr1 = 12; _feeAddr2 = 8; } uint256 contractTokenBalance = balanceOf(address(this)); if (!inSwap && from != uniswapV2Pair && swapEnabled) { swapTokensForEth(contractTokenBalance); uint256 contractETHBalance = address(this).balance; if(contractETHBalance > 0) { sendETHToFee(address(this).balance); } } } _tokenTransfer(from,to,amount); }",
        "vulnerability": "front-running attack vulnerability",
        "reason": "The `_transfer` function, particularly the sections involving fees and cooldown settings, may be vulnerable to front-running attacks. Attackers can observe transactions in the mempool and attempt to manipulate or exploit the timing of fee settings and cooldowns to gain an advantage or disrupt transactions. This is a common vulnerability in DeFi contracts that don't have sufficient checks or randomness to mitigate such risks.",
        "file_name": "0x0de3539f225e3431d6a7bbd3495cc2caf19b334c.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _feeAddrWallet1); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "centralized control",
        "reason": "The `manualsend` function allows the `_feeAddrWallet1` address to withdraw the entire balance of Ether stored in the contract. This introduces a significant risk of centralized control, where if the private key of `_feeAddrWallet1` is compromised, an attacker could drain all Ether from the contract. This is a serious concern for decentralized systems that aim to minimize single points of failure.",
        "file_name": "0x0de3539f225e3431d6a7bbd3495cc2caf19b334c.sol"
    }
]