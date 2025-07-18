[
    {
        "function_name": "setWithdrawAddress",
        "code": "function setWithdrawAddress(address newWithdrawAddress) external onlyWithdrawer { _withdrawAddress = newWithdrawAddress; }",
        "vulnerability": "Unauthorized address change",
        "reason": "The `setWithdrawAddress` function allows the current withdrawer to change the withdraw address to any arbitrary address. If the current withdrawer address is compromised, the attacker can redirect all future withdrawals to an address they control.",
        "file_name": "0x13ee0099f47a84bb4ab4cce741326b2976eda776.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer( address from, address to, uint256 amount ) internal override { require(_balances[from] >= amount, \"not enough token for transfer\"); require(to != address(0), \"incorrect address\"); if (from == uniswapPair && !_isExcludedFromFee[to]) { require(buyEnable, \"trading disabled\"); amount = _getFeeBuy(from, to, amount); require( _balances[to] + amount <= maxWallet(), \"max wallet constraint\" ); } else if ( !_inSwap && uniswapPair != address(0) && to == uniswapPair && !_isExcludedFromFee[from] ) { amount = _getFeeSell(from, amount); _swapTokensForEthOnTransfer( amount, _balances[address(this)], _uniswapV2Router ); } super._transfer(from, to, amount); }",
        "vulnerability": "Reentrancy Risk",
        "reason": "The `_transfer` function calls `_swapTokensForEthOnTransfer`, which can invoke external calls (via the Uniswap router) without reentrancy protection. This can potentially allow reentrancy attacks if an attacker can manipulate the transfer function to re-enter during a swap operation.",
        "file_name": "0x13ee0099f47a84bb4ab4cce741326b2976eda776.sol"
    },
    {
        "function_name": "setExcludeFromFee",
        "code": "function setExcludeFromFee(address[] memory accounts, bool value) external onlyWithdrawer { for (uint256 i = 0; i < accounts.length; ++i) { _isExcludedFromFee[accounts[i]] = value; } }",
        "vulnerability": "Fee exclusion manipulation",
        "reason": "The `setExcludeFromFee` function allows the withdrawer to exclude any accounts from fee calculations. This can be abused if the withdrawer adds their own or an attacker\u2019s address, allowing transactions to bypass fees entirely, potentially draining liquidity by avoiding transaction costs.",
        "file_name": "0x13ee0099f47a84bb4ab4cce741326b2976eda776.sol"
    }
]