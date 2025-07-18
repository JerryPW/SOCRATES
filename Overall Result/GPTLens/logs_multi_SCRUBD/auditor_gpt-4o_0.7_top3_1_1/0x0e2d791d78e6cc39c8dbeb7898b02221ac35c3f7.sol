[
    {
        "function_name": "payTaxes",
        "code": "function payTaxes(uint256 _eth, uint256 _d) internal virtual { for (uint i = 1; i < m_TaxAlloc.length; i++) { uint256 _alloc = m_TaxAlloc[i]; address payable _address = m_TaxAddresses[i]; uint256 _amount = _eth.mul(_alloc).div(_d); if (_amount > 1){ _address.transfer(_amount); if(_address == m_DevAddress) External.deposit(_amount); } } }",
        "vulnerability": "Reentrancy vulnerability in external calls",
        "reason": "The function makes an external call to `_address.transfer(_amount)`, which can potentially trigger a fallback function that re-enters the contract. Although the function uses `.transfer()` which limits gas, it should use a reentrancy guard or check-effects-interactions pattern to be more secure.",
        "file_name": "0x0e2d791d78e6cc39c8dbeb7898b02221ac35c3f7.sol"
    },
    {
        "function_name": "setTaxAlloc",
        "code": "function setTaxAlloc(address payable _address, uint256 _alloc) internal virtual onlyOwner() { require(_alloc >= 0, 'Allocation must be at least 0'); if(m_TotalAddresses > 11) require(_alloc == 0, 'Max wallet count reached'); if (m_DidDeploy) { if (_address == m_DevAddress) { require(_msgSender() == m_WebThree); } } uint _idx = m_TaxIdx[_address]; if (_idx == 0) { require(m_TotalAlloc.add(_alloc) <= 6500); m_TaxAlloc.push(_alloc); m_TaxAddresses.push(_address); m_TaxIdx[_address] = m_TaxAlloc.length - 1; m_TotalAlloc = m_TotalAlloc.add(_alloc); } else { uint256 _priorAlloc = m_TaxAlloc[_idx]; require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 6500); m_TaxAlloc[_idx] = _alloc; m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc); if(_alloc == 0) m_TotalAddresses = m_TotalAddresses.sub(1); } if(_alloc > 0) m_TotalAddresses += 1; }",
        "vulnerability": "Lack of input validation and potential overflow",
        "reason": "The function allows setting `_alloc` to any positive value, and the logic does not properly handle the possibility of an overflow when manipulating `m_TotalAlloc` and `m_TotalAddresses`. This could lead to incorrect tax allocations and potentially overflow the `m_TotalAlloc` value.",
        "file_name": "0x0e2d791d78e6cc39c8dbeb7898b02221ac35c3f7.sol"
    },
    {
        "function_name": "initTax",
        "code": "function initTax() internal virtual { External = FTPExternal(m_ExternalServiceAddress); m_DevAddress = payable(address(External)); m_TaxAlloc = new uint24[](0); m_TaxAddresses = new address payable[](0); m_TaxAlloc.push(0); m_TaxAddresses.push(payable(address(0))); setTaxAlloc(m_DevAddress, m_DevAlloc); setTaxAlloc(payable(0xa10D31D586FFFBb28184d501691aa40B33153292), 5000); m_DidDeploy = true; }",
        "vulnerability": "Improper initialization and fixed addresses",
        "reason": "The function initializes tax addresses with fixed values, which can be a security risk if the external addresses are not secure. Additionally, the `initTax` function sets `m_DevAddress` from an external source without checks, which can be manipulated if `m_ExternalServiceAddress` is compromised.",
        "file_name": "0x0e2d791d78e6cc39c8dbeb7898b02221ac35c3f7.sol"
    }
]