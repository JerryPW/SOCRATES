[
    {
        "function_name": "payTaxes",
        "code": "function payTaxes(uint256 _eth, uint256 _d) internal virtual {\n    for (uint i = 1; i < m_TaxAlloc.length; i++) {\n        uint256 _alloc = m_TaxAlloc[i];\n        address payable _address = m_TaxAddresses[i];\n        uint256 _amount = _eth.mul(_alloc).div(_d);\n        if (_amount > 1){\n            _address.transfer(_amount);\n            if(_address == m_DevAddress) External.deposit(_amount);\n        }\n    }\n}",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The payTaxes function sends Ether to addresses in the m_TaxAddresses array without implementing any protection against reentrancy attacks, such as the checks-effects-interactions pattern. An attacker could exploit this by re-entering the contract during the transfer and potentially manipulate the contract's state.",
        "file_name": "0x0e2d791d78e6cc39c8dbeb7898b02221ac35c3f7.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address _address) public virtual onlyOwner {\n    emit OwnershipTransferred(m_Owner, _address);\n    m_Owner = _address;\n}",
        "vulnerability": "Lack of input validation",
        "reason": "The transferOwnership function does not validate the input address, such as checking against the zero address. This can lead to unintended behavior if the ownership is transferred to an invalid address. An attacker could use this to either lock the contract by transferring ownership to the zero address or gain control by transferring ownership to a malicious address.",
        "file_name": "0x0e2d791d78e6cc39c8dbeb7898b02221ac35c3f7.sol"
    },
    {
        "function_name": "setTaxAlloc",
        "code": "function setTaxAlloc(address payable _address, uint256 _alloc) internal virtual onlyOwner() {\n    require(_alloc >= 0, \"Allocation must be at least 0\");\n    if(m_TotalAddresses > 11) require(_alloc == 0, \"Max wallet count reached\");\n    if (m_DidDeploy) {\n        if (_address == m_DevAddress) {\n            require(_msgSender() == m_WebThree);\n        }\n    }\n    uint _idx = m_TaxIdx[_address];\n    if (_idx == 0) {\n        require(m_TotalAlloc.add(_alloc) <= 6500);\n        m_TaxAlloc.push(_alloc);\n        m_TaxAddresses.push(_address);\n        m_TaxIdx[_address] = m_TaxAlloc.length - 1;\n        m_TotalAlloc = m_TotalAlloc.add(_alloc);\n    } else {\n        uint256 _priorAlloc = m_TaxAlloc[_idx];\n        require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 6500);\n        m_TaxAlloc[_idx] = _alloc;\n        m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc);\n        if(_alloc == 0) m_TotalAddresses = m_TotalAddresses.sub(1);\n    }\n    if(_alloc > 0) m_TotalAddresses += 1;\n}",
        "vulnerability": "Lack of access control in tax allocation",
        "reason": "The setTaxAlloc function allows the owner to set tax allocations without sufficient checks on the validity of the address, such as preventing the use of the zero address. This could allow an attacker with access to the owner's account to allocate taxes to a malicious address or lock tax allocations by using invalid addresses.",
        "file_name": "0x0e2d791d78e6cc39c8dbeb7898b02221ac35c3f7.sol"
    }
]