[
    {
        "function_name": "setTaxAlloc",
        "code": "function setTaxAlloc(address payable _address, uint256 _alloc) internal virtual onlyOwner() { require(_alloc >= 0, \"Allocation must be at least 0\"); if(m_TotalAddresses > 11) require(_alloc == 0, \"Max wallet count reached\"); if (m_DidDeploy) { if (_address == m_DevAddress) { require(_msgSender() == m_WebThree); } } uint _idx = m_TaxIdx[_address]; if (_idx == 0) { require(m_TotalAlloc.add(_alloc) <= 6500); m_TaxAlloc.push(_alloc); m_TaxAddresses.push(_address); m_TaxIdx[_address] = m_TaxAlloc.length - 1; m_TotalAlloc = m_TotalAlloc.add(_alloc); } else { uint256 _priorAlloc = m_TaxAlloc[_idx]; require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 6500); m_TaxAlloc[_idx] = _alloc; m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc); if(_alloc == 0) m_TotalAddresses = m_TotalAddresses.sub(1); } if(_alloc > 0) m_TotalAddresses += 1; }",
        "vulnerability": "Incorrect address management",
        "reason": "The function does not properly handle the case when _alloc is set to 0 for a new address, which could lead to inconsistent state or unintended behavior. Moreover, the function can be exploited to add multiple addresses with zero allocation, potentially reaching the max wallet count and blocking further additions.",
        "file_name": "0x0e2d791d78e6cc39c8dbeb7898b02221ac35c3f7.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer(address _sender, address _recipient, uint256 _amount) private { require(_sender != address(0), \"ERC20: transfer from the zero address\"); require(_amount > 0, \"Must transfer greater than 0\"); require(!m_Blacklist[_sender] && !m_Blacklist[_recipient] && !m_Blacklist[tx.origin]); if(_isExchangeTransfer(_sender, _recipient) && block.timestamp >= m_Launched) { require(!AntiBot.scanAddress(_recipient, m_UniswapV2Pair, tx.origin), \"Beep Beep Boop, You're a piece of poop\"); require(!AntiBot.scanAddress(_sender, m_UniswapV2Pair, tx.origin), \"Beep Beep Boop, You're a piece of poop\"); AntiBot.registerBlock(_sender, _recipient, tx.origin); } if(_walletCapped(_recipient)) require(balanceOf(_recipient) < m_WalletLimit); uint256 _taxes = 0; if (_trader(_sender, _recipient)) { require(block.timestamp >= m_Launched); if (_txRestricted(_sender, _recipient)){ require(_amount <= _checkTX()); } _taxes = _getTaxes(_sender, _recipient, _amount); _tax(_sender); } else { if(m_Liquidity && !_isBuy(_sender) && !_isTax(_sender)){ require(block.timestamp >= m_Launched.add(7 days), \"Dumping discouraged\"); } } _updateBalances(_sender, _recipient, _amount, _taxes); }",
        "vulnerability": "Potential denial of service via blacklisting",
        "reason": "The function enforces blacklisting checks that could be exploited to cause a denial of service. An attacker could blacklist critical addresses, such as liquidity pools or key participants, thereby disrupting the normal operation of the token transfer functionality.",
        "file_name": "0x0e2d791d78e6cc39c8dbeb7898b02221ac35c3f7.sol"
    },
    {
        "function_name": "_swapTokensForETH",
        "code": "function _swapTokensForETH(uint256 _amount) private lockTheSwap { address[] memory _path = new address[](2); _path[0] = address(this); _path[1] = m_UniswapV2Router.WETH(); _approve(address(this), address(m_UniswapV2Router), _amount); m_UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( _amount, 0, _path, address(this), block.timestamp ); }",
        "vulnerability": "Lack of slippage protection",
        "reason": "The function lacks slippage protection as the minimum amount of output tokens (amountOutMin) is set to 0. This can result in significant losses during token swaps if there is a large price fluctuation, as the function will accept any amount of ETH in return for the tokens.",
        "file_name": "0x0e2d791d78e6cc39c8dbeb7898b02221ac35c3f7.sol"
    }
]