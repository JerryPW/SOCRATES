[
    {
        "function_name": "payTaxes",
        "code": "function payTaxes(uint256 _eth, uint256 _d) internal virtual {\n    for (uint i = 1; i < m_TaxAlloc.length; i++) {\n        uint256 _alloc = m_TaxAlloc[i];\n        address payable _address = m_TaxAddresses[i];\n        uint256 _amount = _eth.mul(_alloc).div(_d);\n        if (_amount > 1){\n            _address.transfer(_amount);\n            if(_address == m_DevAddress) External.deposit(_amount);\n        }\n    }\n}",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The payTaxes function transfers ETH to external addresses without using a reentrancy guard. An attacker could exploit this by using a contract to reenter the payTaxes function during the transfer, potentially manipulating the state or draining funds.",
        "file_name": "0x193c4c0bdf474efe82a56e530f70af58810cf74d.sol"
    },
    {
        "function_name": "addLiquidity",
        "code": "function addLiquidity() external onlyOwner() {\n    require(!m_Liquidity,\"Liquidity already added.\");\n    uint256 _ethBalance = address(this).balance;\n    _approve(address(this), address(m_UniswapV2Router), TOTAL_SUPPLY);\n    m_UniswapV2Pair = IUniswapV2Factory(m_UniswapV2Router.factory()).createPair(address(this), m_UniswapV2Router.WETH());\n    m_UniswapV2Router.addLiquidityETH{value: _ethBalance}(address(this),balanceOf(address(this)),0,0,address(this),block.timestamp);\n    IERC20(m_UniswapV2Pair).approve(m_LiqLockSvcAddress, type(uint).max);\n    FTPLiqLock(m_LiqLockSvcAddress).lockTokens(m_UniswapV2Pair, block.timestamp.add(4 days), msg.sender);\n    WETH.approve(address(this), type(uint).max);\n    m_Liquidity = true;\n}",
        "vulnerability": "Potential denial of service",
        "reason": "The addLiquidity function can only be called once due to the m_Liquidity flag. If an error occurs during the liquidity addition or if liquidity is not properly added, the contract owner will not have another opportunity to add liquidity, potentially leaving the contract funds locked and unusable.",
        "file_name": "0x193c4c0bdf474efe82a56e530f70af58810cf74d.sol"
    },
    {
        "function_name": "setTaxAlloc",
        "code": "function setTaxAlloc(address payable _address, uint256 _alloc) internal virtual onlyOwner() {\n    require(_alloc >= 0, \"Allocation must be at least 0\");\n    if(m_TotalAddresses > 11) require(_alloc == 0, \"Max wallet count reached\");\n    if (m_DidDeploy) {\n        if (_address == m_DevAddress) {\n            require(_msgSender() == m_WebThree);\n        }\n    }\n    uint _idx = m_TaxIdx[_address];\n    if (_idx == 0) {\n        require(m_TotalAlloc.add(_alloc) <= 6500);\n        m_TaxAlloc.push(_alloc);\n        m_TaxAddresses.push(_address);\n        m_TaxIdx[_address] = m_TaxAlloc.length - 1;\n        m_TotalAlloc = m_TotalAlloc.add(_alloc);\n    } else {\n        uint256 _priorAlloc = m_TaxAlloc[_idx];\n        require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 6500);\n        m_TaxAlloc[_idx] = _alloc;\n        m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc);\n        if(_alloc == 0) m_TotalAddresses = m_TotalAddresses.sub(1);\n    }\n    if(_alloc > 0) m_TotalAddresses += 1;\n}",
        "vulnerability": "Tax allocation manipulation",
        "reason": "The setTaxAlloc function allows the contract owner to manipulate tax allocations, potentially diverting funds to arbitrary addresses. This can be exploited by a malicious owner to reroute funds away from their intended recipients, causing financial losses.",
        "file_name": "0x193c4c0bdf474efe82a56e530f70af58810cf74d.sol"
    }
]