[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address _address) public virtual onlyOwner { emit OwnershipTransferred(m_Owner, _address); m_Owner = _address; }",
        "vulnerability": "Missing zero address check",
        "reason": "The transferOwnership function does not check if the new owner address is the zero address, which could lead to the contract being locked with no owner.",
        "file_name": "0x0d2508ff66a445116029b153f5ca261145717cc1.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer(address _sender, address _recipient, uint256 _amount) private { require(_sender != address(0), \"ERC20: transfer from the zero address\"); require(_recipient != address(0), \"ERC20: transfer to the zero address\"); require(_amount > 0, \"Transfer amount must be greater than zero\"); require(!m_Blacklist[_sender] && !m_Blacklist[_recipient] && !m_Blacklist[tx.origin]); if(_isExchangeTransfer(_sender, _recipient) && block.timestamp >= m_Launched) { require(!AntiBot.scanAddress(_recipient, m_UniswapV2Pair, tx.origin), \"Beep Beep Boop, You're a piece of poop\"); require(!AntiBot.scanAddress(_sender, m_UniswapV2Pair, tx.origin), \"Beep Beep Boop, You're a piece of poop\"); AntiBot.registerBlock(_sender, _recipient, tx.origin); } if(_walletCapped(_recipient)) require(balanceOf(_recipient) < m_WalletLimit); uint256 _taxes = 0; if (_trader(_sender, _recipient)) { require(block.timestamp >= m_Launched); if (_txRestricted(_sender, _recipient)) require(_amount <= _checkTX()); _taxes = _getTaxes(_sender, _recipient, _amount); _tax(_sender); } _updateBalances(_sender, _recipient, _amount, _taxes); _trackEthReflection(_sender, _recipient); }",
        "vulnerability": "Potential denial of service via blacklist",
        "reason": "The function checks if the sender or recipient is blacklisted, but relies on an external AntiBot contract which could potentially blacklist arbitrary users, causing them to be unable to transfer tokens.",
        "file_name": "0x0d2508ff66a445116029b153f5ca261145717cc1.sol"
    },
    {
        "function_name": "setTaxAlloc",
        "code": "function setTaxAlloc(address payable _address, uint256 _alloc) internal virtual onlyOwner() { if (m_DidDeploy) { if (_address == m_DevAddress) { require(_msgSender() == m_WebThree); } } uint _idx = m_TaxIdx[_address]; if (_idx == 0) { require(m_TotalAlloc.add(_alloc) <= 10500); m_TaxAlloc.push(_alloc); m_TaxAddresses.push(_address); m_TaxIdx[_address] = m_TaxAlloc.length - 1; m_TotalAlloc = m_TotalAlloc.add(_alloc); } else { uint256 _priorAlloc = m_TaxAlloc[_idx]; require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 10500); m_TaxAlloc[_idx] = _alloc; m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc); } }",
        "vulnerability": "Incorrect check for developer address",
        "reason": "The function fails to properly check and restrict updates to the developer address allocation after deployment, which could be exploited to redirect funds to arbitrary addresses.",
        "file_name": "0x0d2508ff66a445116029b153f5ca261145717cc1.sol"
    }
]