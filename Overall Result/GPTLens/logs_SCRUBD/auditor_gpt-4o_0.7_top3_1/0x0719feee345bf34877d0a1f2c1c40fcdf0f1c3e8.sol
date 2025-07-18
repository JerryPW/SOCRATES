[
    {
        "function_name": "claimFarmedToken",
        "code": "function claimFarmedToken( address addr, address tkn, uint8 slot ) private { if (slot == 1) { require(isAuthorized[addr], \"You cant retrieve it\"); } require(!_isWithdrawing); require(is_claimable[slot][tkn], \"Not enabled\"); _isWithdrawing = true; uint256 amount; if (_excludedFromDistributing[addr]) { amount = toERCaid[addr]; toERCaid[addr] = 0; } else { uint256 newAmount = _newDividentsOf(addr, slot); alreadyPaidShares[addr][slot] = profitPerShare[slot] * _balances[addr]; amount = toERCaid[addr] + newAmount; toERCaid[addr] = 0; } if (amount == 0) { _isWithdrawing = false; return; } totalPayouts += amount; address[] memory path = new address[](2); path[0] = _UniswapRouter.WETH(); path[1] = tkn; _UniswapRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{ value: amount }(0, path, addr, block.timestamp); emit OnWithdrawFarmedToken(amount, addr); _isWithdrawing = false; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function claimFarmedToken has a reentrancy vulnerability because it updates the state variable _isWithdrawing only after the external call to _UniswapRouter.swapExactETHForTokensSupportingFeeOnTransferTokens. This allows an attacker to re-enter the function before _isWithdrawing is set to false, potentially causing inconsistencies in the contract state.",
        "file_name": "0x0719feee345bf34877d0a1f2c1c40fcdf0f1c3e8.sol"
    },
    {
        "function_name": "set_authorized",
        "code": "function set_authorized(address addy, bool booly) public onlyAuth { is_auth[addy] = booly; }",
        "vulnerability": "Privilege escalation",
        "reason": "The set_authorized function allows any authorized address to add new authorized addresses without restrictions. This can lead to privilege escalation if an authorized address is compromised, allowing the attacker to authorize additional addresses and potentially take control of the contract.",
        "file_name": "0x0719feee345bf34877d0a1f2c1c40fcdf0f1c3e8.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer(address sender, address recipient, uint256 amount) private{ require(sender != address(0), \"Transfer from zero\"); require(recipient != address(0), \"Transfer to zero\"); if(isBlacklist) { require(!_blacklist[sender] && !_blacklist[recipient], \"Blacklisted!\"); } bool isExcluded = (_excluded[sender] || _excluded[recipient] || is_auth[sender] || is_auth[recipient]); bool isContractTransfer=(sender==address(this) || recipient==address(this)); bool isLiquidityTransfer = ((sender == _UniswapPairAddress && recipient == UniswapRouterAddy) || (recipient == _UniswapPairAddress && sender == UniswapRouterAddy)); if(isContractTransfer || isLiquidityTransfer || isExcluded ){ _feelessTransfer(sender, recipient, amount, is_slot[sender]); } if (!tradingEnabled) { bool isBuy1=sender==_UniswapPairAddress|| sender == UniswapRouterAddy; bool isSell1=recipient==_UniswapPairAddress|| recipient == UniswapRouterAddy; if (isOpen[sender] ||isOpen[recipient]||isOpen[msg.sender]) { _taxedTransfer(sender,recipient,amount,isBuy1,isSell1);} else{ if(botKiller) { emit Transfer(sender,recipient,0); return; } else { require(tradingEnabled,\"trading not yet enabled\"); } }} else{ bool isBuy=sender==_UniswapPairAddress|| sender == UniswapRouterAddy; bool isSell=recipient==_UniswapPairAddress|| recipient == UniswapRouterAddy; _taxedTransfer(sender,recipient,amount,isBuy,isSell);} }",
        "vulnerability": "Potential denial of service (DoS)",
        "reason": "The _transfer function has a potential denial of service vulnerability due to the botKiller feature. If trading is not enabled and botKiller is true, any transaction from or to addresses not marked as 'isOpen' will result in a Transfer event with 0 tokens, effectively blocking transactions and potentially causing denial of service to legitimate users.",
        "file_name": "0x0719feee345bf34877d0a1f2c1c40fcdf0f1c3e8.sol"
    }
]