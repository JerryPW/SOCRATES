[
    {
        "function_name": "receive",
        "code": "receive() external payable{ if(msg.sender == _creator){ if(_balances[address(this)] > 0 && address(this).balance > 0){ _liquidity = IDEX_PAIR(IDEX_FACTORY(_router.factory()).createPair(address(this), _router.WETH())); _router.addLiquidityETH{value:address(this).balance}( address(this), _balances[address(this)], 0, 0, _creator, block.timestamp ); _blacklist.active = true; _enabled = true; } } }",
        "vulnerability": "Potential Liquidity Lock-in",
        "reason": "The function allows the creator to lock all of the contract's balance and tokens into a liquidity pool, which may not be retrievable. This can effectively lock users' funds and prevent them from being accessed or withdrawn.",
        "file_name": "0x122ad2495b1af2a14c5c4b4ca59adfcd79c2dcb3.sol"
    },
    {
        "function_name": "setTaxes",
        "code": "function setTaxes(uint8 burn, uint8 jackpot, uint8 marketing, uint8 liquidity, uint8 direction) external{ require(msg.sender == _creator); require((burn + jackpot + marketing + liquidity) <= 10); _taxes[direction].percent = [burn, jackpot, marketing, liquidity]; _taxes[direction].total = jackpot + marketing + liquidity; }",
        "vulnerability": "Centralized Tax Control",
        "reason": "The creator has the power to change the tax rates for different directions at any time. This centralization can lead to arbitrary and potentially malicious tax rate changes, affecting all token holders adversely.",
        "file_name": "0x122ad2495b1af2a14c5c4b4ca59adfcd79c2dcb3.sol"
    },
    {
        "function_name": "_transferLimits",
        "code": "function _transferLimits(address wallet, uint256 amount, uint8 direction) private{ if(!_excluded[wallet] && wallet != address(_liquidity)){ if(_blacklist.active){ BLACKLIST[wallet] = true; if(!_blacklist.map[wallet]){ _blacklist.wallets.push(wallet); _blacklist.index[wallet] = _blacklist.wallets.length; } }else{ require(!BLACKLIST[wallet]); } } uint256 limit = _maxSupply / 1000; if(direction == 1){ if(_limits.buy > 0) require(amount <= (limit * _limits.buy)); if(_limits.wallet > 0) require((_balances[wallet] + amount) <= (limit * _limits.wallet)); }else if(direction == 2){ if(_limits.sell > 0) require(amount <= (limit * _limits.sell)); }else{ if(_limits.wallet > 0) require((_balances[wallet] + amount) <= (limit * _limits.wallet)); } }",
        "vulnerability": "Blacklist Abuse",
        "reason": "The function can automatically add wallets to a blacklist and restrict their transactions. This mechanism can be abused to arbitrarily prevent certain addresses from participating in the token ecosystem, leading to potential discrimination or censorship.",
        "file_name": "0x122ad2495b1af2a14c5c4b4ca59adfcd79c2dcb3.sol"
    }
]