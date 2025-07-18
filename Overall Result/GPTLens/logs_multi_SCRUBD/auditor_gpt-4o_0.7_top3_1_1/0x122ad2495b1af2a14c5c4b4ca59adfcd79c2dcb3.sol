[
    {
        "function_name": "receive",
        "code": "receive() external payable{ if(msg.sender == _creator){ if(_balances[address(this)] > 0 && address(this).balance > 0){ _liquidity = IDEX_PAIR(IDEX_FACTORY(_router.factory()).createPair(address(this), _router.WETH())); _router.addLiquidityETH{value:address(this).balance}( address(this), _balances[address(this)], 0, 0, _creator, block.timestamp ); _blacklist.active = true; _enabled = true; } } }",
        "vulnerability": "Improper Access Control",
        "reason": "The receive function allows the creator to add liquidity and enable trading whenever they send ETH to the contract. This functionality grants the creator excessive control over the contract's state, allowing for sudden changes that can be exploited to manipulate trading conditions.",
        "file_name": "0x122ad2495b1af2a14c5c4b4ca59adfcd79c2dcb3.sol"
    },
    {
        "function_name": "_update",
        "code": "function _update(address from, address to, uint256 amount) private{ if(from != address(0)){_balances[from] -= amount;}else{_maxSupply += amount;} if(to == address(0)){_maxSupply -= amount;}else{_balances[to] += amount;} emit Transfer(from, to, amount); }",
        "vulnerability": "Supply Manipulation",
        "reason": "The _update function can increase or decrease the total supply arbitrarily whenever tokens are transferred to or from the zero address. This can potentially be used maliciously to inflate or deflate the token supply, affecting market conditions and token value.",
        "file_name": "0x122ad2495b1af2a14c5c4b4ca59adfcd79c2dcb3.sol"
    },
    {
        "function_name": "_transferLimits",
        "code": "function _transferLimits(address wallet, uint256 amount, uint8 direction) private{ if(!_excluded[wallet] && wallet != address(_liquidity)){ if(_blacklist.active){ BLACKLIST[wallet] = true; if(!_blacklist.map[wallet]){ _blacklist.wallets.push(wallet); _blacklist.index[wallet] = _blacklist.wallets.length; } }else{ require(!BLACKLIST[wallet]); } } uint256 limit = _maxSupply / 1000; if(direction == 1){ if(_limits.buy > 0) require(amount <= (limit * _limits.buy)); if(_limits.wallet > 0) require((_balances[wallet] + amount) <= (limit * _limits.wallet)); }else if(direction == 2){ if(_limits.sell > 0) require(amount <= (limit * _limits.sell)); }else{ if(_limits.wallet > 0) require((_balances[wallet] + amount) <= (limit * _limits.wallet)); } }",
        "vulnerability": "Blacklist Manipulation",
        "reason": "The _transferLimits function can automatically add wallets to a blacklist when the blacklist is active. This can be exploited by the creator to selectively blacklist wallets during transactions, potentially locking users out of their funds without prior notice.",
        "file_name": "0x122ad2495b1af2a14c5c4b4ca59adfcd79c2dcb3.sol"
    }
]