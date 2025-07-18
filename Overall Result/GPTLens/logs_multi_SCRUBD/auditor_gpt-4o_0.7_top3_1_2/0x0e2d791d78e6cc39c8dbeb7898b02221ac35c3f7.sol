[
    {
        "function_name": "setTaxAlloc",
        "code": "function setTaxAlloc(address payable _address, uint256 _alloc) internal virtual onlyOwner() { require(_alloc >= 0, \"Allocation must be at least 0\"); if(m_TotalAddresses > 11) require(_alloc == 0, \"Max wallet count reached\"); if (m_DidDeploy) { if (_address == m_DevAddress) { require(_msgSender() == m_WebThree); } } uint _idx = m_TaxIdx[_address]; if (_idx == 0) { require(m_TotalAlloc.add(_alloc) <= 6500); m_TaxAlloc.push(_alloc); m_TaxAddresses.push(_address); m_TaxIdx[_address] = m_TaxAlloc.length - 1; m_TotalAlloc = m_TotalAlloc.add(_alloc); } else { uint256 _priorAlloc = m_TaxAlloc[_idx]; require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 6500); m_TaxAlloc[_idx] = _alloc; m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc); if(_alloc == 0) m_TotalAddresses = m_TotalAddresses.sub(1); } if(_alloc > 0) m_TotalAddresses += 1; }",
        "vulnerability": "Max wallet count bypass",
        "reason": "There's a potential bypass of the max wallet count limit. The condition `if(m_TotalAddresses > 11) require(_alloc == 0, \"Max wallet count reached\");` is only checked when adding a new wallet, but it's not checked if an existing wallet is updated with a non-zero allocation. This could allow the owner to bypass the intended limit of tax wallets by first setting allocations to zero and then updating them back to non-zero without hitting the max wallet count check again.",
        "file_name": "0x0e2d791d78e6cc39c8dbeb7898b02221ac35c3f7.sol"
    },
    {
        "function_name": "_swapTokensForETH",
        "code": "function _swapTokensForETH(uint256 _amount) private lockTheSwap { address[] memory _path = new address[](2); _path[0] = address(this); _path[1] = m_UniswapV2Router.WETH(); _approve(address(this), address(m_UniswapV2Router), _amount); m_UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( _amount, 0, _path, address(this), block.timestamp ); }",
        "vulnerability": "Potential frontrunning",
        "reason": "The `_swapTokensForETH` function is vulnerable to frontrunning attacks because it executes a token swap without any slippage protection. An attacker could observe the transaction and manipulate the price on the exchange, profiting from the difference. This can cause the contract to receive significantly less ETH than expected.",
        "file_name": "0x0e2d791d78e6cc39c8dbeb7898b02221ac35c3f7.sol"
    },
    {
        "function_name": "launch",
        "code": "function launch(uint256 _timer) external onlyOwner() { m_Launched = block.timestamp.add(_timer); }",
        "vulnerability": "Launch delay manipulation",
        "reason": "The `launch` function allows the owner to set a future launch time using the `_timer` parameter. This could be manipulated to delay the launch indefinitely or to schedule a launch at a very inconvenient time for users. It doesn't enforce any reasonable bounds on the `_timer`, which could be potentially used to manipulate the launch conditions.",
        "file_name": "0x0e2d791d78e6cc39c8dbeb7898b02221ac35c3f7.sol"
    }
]