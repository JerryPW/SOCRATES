[
    {
        "function_name": "setTaxAlloc",
        "code": "function setTaxAlloc(address payable _address, uint256 _alloc) internal virtual onlyOwner() { require(_alloc >= 0, \"Allocation must be at least 0\"); if(m_TotalAddresses > 11) require(_alloc == 0, \"Max wallet count reached\"); if (m_DidDeploy) { if (_address == m_DevAddress) { require(_msgSender() == m_WebThree); } } uint _idx = m_TaxIdx[_address]; if (_idx == 0) { require(m_TotalAlloc.add(_alloc) <= 6500); m_TaxAlloc.push(_alloc); m_TaxAddresses.push(_address); m_TaxIdx[_address] = m_TaxAlloc.length - 1; m_TotalAlloc = m_TotalAlloc.add(_alloc); } else { uint256 _priorAlloc = m_TaxAlloc[_idx]; require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 6500); m_TaxAlloc[_idx] = _alloc; m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc); if(_alloc == 0) m_TotalAddresses = m_TotalAddresses.sub(1); } if(_alloc > 0) m_TotalAddresses += 1; }",
        "vulnerability": "Improper Access Control",
        "reason": "The function allows the owner to set tax allocations for any address, including the developer address, without adequate checks. This could be exploited if the owner account is compromised, allowing an attacker to redirect tax allocations.",
        "file_name": "0x193c4c0bdf474efe82a56e530f70af58810cf74d.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer(address _sender, address _recipient, uint256 _amount) private { require(_sender != address(0), \"ERC20: transfer from the zero address\"); require(_amount > 0, \"Must transfer greater than 0\"); require(!m_Blacklist[_sender] && !m_Blacklist[_recipient] && !m_Blacklist[tx.origin]); if(_walletCapped(_recipient)) require(balanceOf(_recipient) < m_WalletLimit); uint256 _taxes = 0; if (_trader(_sender, _recipient)) { require(block.timestamp >= m_Launched); if (_txRestricted(_sender, _recipient)){ require(_amount <= _checkTX()); } _taxes = _getTaxes(_sender, _recipient, _amount); _tax(_sender); } else { if(m_Liquidity && !_isBuy(_sender) && !_isTax(_sender)){ require(block.timestamp >= m_Launched.add(7 days), \"Dumping discouraged\"); } } _updateBalances(_sender, _recipient, _amount, _taxes); }",
        "vulnerability": "Blacklist Bypass",
        "reason": "The blacklist check can be bypassed by using a smart contract, which would allow an attacker to transfer tokens despite being blacklisted, as the check uses tx.origin which can be circumvented by contract calls.",
        "file_name": "0x193c4c0bdf474efe82a56e530f70af58810cf74d.sol"
    },
    {
        "function_name": "_swapTokensForETH",
        "code": "function _swapTokensForETH(uint256 _amount) private lockTheSwap { address[] memory _path = new address[](2); _path[0] = address(this); _path[1] = m_UniswapV2Router.WETH(); _approve(address(this), address(m_UniswapV2Router), _amount); m_UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( _amount, 0, _path, address(this), block.timestamp ); }",
        "vulnerability": "Price Manipulation",
        "reason": "The function does not set a minimum amount of ETH to be received during the token swap, which can lead to price manipulation. An attacker can manipulate the price of the token on Uniswap to receive more ETH than intended during the swap process.",
        "file_name": "0x193c4c0bdf474efe82a56e530f70af58810cf74d.sol"
    }
]