[
    {
        "function_name": "setTaxAlloc",
        "code": "function setTaxAlloc(address payable _address, uint256 _alloc) internal virtual onlyOwner() { if (m_DidDeploy) { if (_address == m_DevAddress) { require(_msgSender() == m_WebThree); } } uint _idx = m_TaxIdx[_address]; if (_idx == 0) { require(m_TotalAlloc.add(_alloc) <= 10500); m_TaxAlloc.push(_alloc); m_TaxAddresses.push(_address); m_TaxIdx[_address] = m_TaxAlloc.length - 1; m_TotalAlloc = m_TotalAlloc.add(_alloc); } else { uint256 _priorAlloc = m_TaxAlloc[_idx]; require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 10500); m_TaxAlloc[_idx] = _alloc; m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc); } }",
        "vulnerability": "Deployment Time Check Bypass",
        "reason": "The function allows for modifications to the tax allocation even if the contract is not fully deployed (m_DidDeploy == false). This can lead to unauthorized allocation changes without proper checks, especially for the m_DevAddress, which requires the caller to be m_WebThree only when m_DidDeploy is true.",
        "file_name": "0x12bafa32c73c6b7f0c00b36b3ba6d9416b163c59.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer(address _sender, address _recipient, uint256 _amount) private { require(_sender != address(0), \"ERC20: transfer from the zero address\"); require(_recipient != address(0), \"ERC20: transfer to the zero address\"); require(_amount > 0, \"Transfer amount must be greater than zero\"); require(!m_Blacklist[_sender] && !m_Blacklist[_recipient] && !m_Blacklist[tx.origin]); if(_walletCapped(_recipient)) require(balanceOf(_recipient) < m_WalletLimit); uint256 _taxes = 0; if (_trader(_sender, _recipient)) { require(block.timestamp >= m_Launched); if (_txRestricted(_sender, _recipient)) require(_amount <= _checkTX()); _taxes = _getTaxes(_sender, _recipient, _amount); _tax(_sender); } _updateBalances(_sender, _recipient, _amount, _taxes); _trackEthReflection(_sender, _recipient); }",
        "vulnerability": "Lack of Transfer Restrictions Post-Launch",
        "reason": "The function checks for several conditions before allowing transfers, including launch time. However, once m_Launched is set, the time restriction is bypassed, allowing unrestricted transfers post-launch. This could allow attackers to exploit timing to execute large transfers without restrictions if the launch parameters are improperly managed.",
        "file_name": "0x12bafa32c73c6b7f0c00b36b3ba6d9416b163c59.sol"
    },
    {
        "function_name": "updateTaxAlloc",
        "code": "function updateTaxAlloc(address payable _address, uint _alloc) external onlyOwner() { setTaxAlloc(_address, _alloc); if (_alloc > 0) { m_ExcludedAddresses[_address] = true; } }",
        "vulnerability": "Automatic Whitelisting Upon Allocation",
        "reason": "The function automatically adds any address with a non-zero tax allocation to the m_ExcludedAddresses list. This can be exploited by the owner to exclude arbitrary addresses from tax calculations simply by assigning them a tax allocation, potentially leading to selective tax evasion.",
        "file_name": "0x12bafa32c73c6b7f0c00b36b3ba6d9416b163c59.sol"
    }
]