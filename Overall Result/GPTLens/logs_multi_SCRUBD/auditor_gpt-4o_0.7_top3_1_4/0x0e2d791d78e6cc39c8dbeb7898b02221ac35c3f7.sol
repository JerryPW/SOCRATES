[
    {
        "function_name": "payTaxes",
        "code": "function payTaxes(uint256 _eth, uint256 _d) internal virtual { for (uint i = 1; i < m_TaxAlloc.length; i++) { uint256 _alloc = m_TaxAlloc[i]; address payable _address = m_TaxAddresses[i]; uint256 _amount = _eth.mul(_alloc).div(_d); if (_amount > 1){ _address.transfer(_amount); if(_address == m_DevAddress) External.deposit(_amount); } } }",
        "vulnerability": "Potential for unchecked transfer of funds",
        "reason": "The function `payTaxes` transfers ETH to a series of addresses without properly checking the success of these transfers. In Solidity, using `.transfer()` has a gas limit and can fail for certain recipient contracts. If any transfer fails, it may not revert the entire transaction, leading to potential loss of funds or incomplete execution. Additionally, the logic assumes that `External.deposit(_amount)` is always safe and does not check for reentrancy or other issues.",
        "file_name": "0x0e2d791d78e6cc39c8dbeb7898b02221ac35c3f7.sol"
    },
    {
        "function_name": "setTaxAlloc",
        "code": "function setTaxAlloc(address payable _address, uint256 _alloc) internal virtual onlyOwner() { require(_alloc >= 0, \"Allocation must be at least 0\"); if(m_TotalAddresses > 11) require(_alloc == 0, \"Max wallet count reached\"); if (m_DidDeploy) { if (_address == m_DevAddress) { require(_msgSender() == m_WebThree); } } uint _idx = m_TaxIdx[_address]; if (_idx == 0) { require(m_TotalAlloc.add(_alloc) <= 6500); m_TaxAlloc.push(_alloc); m_TaxAddresses.push(_address); m_TaxIdx[_address] = m_TaxAlloc.length - 1; m_TotalAlloc = m_TotalAlloc.add(_alloc); } else { uint256 _priorAlloc = m_TaxAlloc[_idx]; require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 6500); m_TaxAlloc[_idx] = _alloc; m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc); if(_alloc == 0) m_TotalAddresses = m_TotalAddresses.sub(1); } if(_alloc > 0) m_TotalAddresses += 1; }",
        "vulnerability": "Insufficient checks for tax allocation",
        "reason": "The function `setTaxAlloc` does not enforce strict checks on address uniqueness in `m_TaxAddresses` and can allow repeated entries for the same address. This may lead to unexpected behavior when paying taxes and affect calculations in other parts of the contract. Moreover, it does not handle the scenario properly if an address changes its allocation to zero, potentially causing logical errors.",
        "file_name": "0x0e2d791d78e6cc39c8dbeb7898b02221ac35c3f7.sol"
    },
    {
        "function_name": "blacklist",
        "code": "function blacklist(address _address) external onlyOwner() { require(_address != m_UniswapV2Pair, \"Can't blacklist Uniswap\"); require(_address != address(this), \"Can't blacklist contract\"); m_Blacklist[_address] = true; }",
        "vulnerability": "Centralized control over blacklisting",
        "reason": "The `blacklist` function allows the contract owner to blacklist any address arbitrarily, except for the Uniswap pair and the contract itself. This introduces a central point of failure and potential abuse, where the owner could block users from transferring tokens, undermining the token's decentralization and trust. There's no mechanism provided for affected addresses to appeal or remove themselves from the blacklist, which could harm the ecosystem and user trust.",
        "file_name": "0x0e2d791d78e6cc39c8dbeb7898b02221ac35c3f7.sol"
    }
]