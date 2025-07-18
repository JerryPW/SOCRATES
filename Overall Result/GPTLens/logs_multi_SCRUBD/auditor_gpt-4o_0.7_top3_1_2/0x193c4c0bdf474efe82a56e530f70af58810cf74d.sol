[
    {
        "function_name": "setTaxAlloc",
        "code": "function setTaxAlloc(address payable _address, uint256 _alloc) internal virtual onlyOwner() { require(_alloc >= 0, \"Allocation must be at least 0\"); if(m_TotalAddresses > 11) require(_alloc == 0, \"Max wallet count reached\"); if (m_DidDeploy) { if (_address == m_DevAddress) { require(_msgSender() == m_WebThree); } } uint _idx = m_TaxIdx[_address]; if (_idx == 0) { require(m_TotalAlloc.add(_alloc) <= 6500); m_TaxAlloc.push(_alloc); m_TaxAddresses.push(_address); m_TaxIdx[_address] = m_TaxAlloc.length - 1; m_TotalAlloc = m_TotalAlloc.add(_alloc); } else { uint256 _priorAlloc = m_TaxAlloc[_idx]; require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 6500); m_TaxAlloc[_idx] = _alloc; m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc); if(_alloc == 0) m_TotalAddresses = m_TotalAddresses.sub(1); } if(_alloc > 0) m_TotalAddresses += 1; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function allows for modification of tax allocation indices and total allocation, which can be manipulated during a reentrant call if the payable address is a contract that executes code upon receiving Ether. Though the function uses `onlyOwner`, if the owner is a contract, and it can call back into `setTaxAlloc`, the state variables can be manipulated unexpectedly.",
        "file_name": "0x193c4c0bdf474efe82a56e530f70af58810cf74d.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address _address) public virtual onlyOwner { emit OwnershipTransferred(m_Owner, _address); m_Owner = _address; }",
        "vulnerability": "Ownership transfer to arbitrary address",
        "reason": "The `transferOwnership` function does not validate the new owner address, allowing the contract owner to transfer ownership to an arbitrary address, including the zero address, which could result in loss of control over the contract if the new owner is a non-functional address.",
        "file_name": "0x193c4c0bdf474efe82a56e530f70af58810cf74d.sol"
    },
    {
        "function_name": "payTaxes",
        "code": "function payTaxes(uint256 _eth, uint256 _d) internal virtual { for (uint i = 1; i < m_TaxAlloc.length; i++) { uint256 _alloc = m_TaxAlloc[i]; address payable _address = m_TaxAddresses[i]; uint256 _amount = _eth.mul(_alloc).div(_d); if (_amount > 1){ _address.transfer(_amount); if(_address == m_DevAddress) External.deposit(_amount); } } }",
        "vulnerability": "Unrestricted Ether transfer",
        "reason": "The `payTaxes` function transfers Ether to addresses stored in `m_TaxAddresses` without checking if these addresses are externally owned accounts (EOAs) or contracts. If a contract with malicious code is included in `m_TaxAddresses`, it can execute arbitrary logic upon receiving Ether, potentially causing reentrancy issues or other unexpected behaviors.",
        "file_name": "0x193c4c0bdf474efe82a56e530f70af58810cf74d.sol"
    }
]