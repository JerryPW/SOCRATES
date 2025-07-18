[
    {
        "function_name": "payTaxes",
        "code": "function payTaxes(uint256 _eth, uint256 _d) internal virtual { for (uint i = 1; i < m_TaxAlloc.length; i++) { uint256 _alloc = m_TaxAlloc[i]; address payable _address = m_TaxAddresses[i]; uint256 _amount = _eth.mul(_alloc).div(_d); if (_amount > 1){ _address.transfer(_amount); if(_address == m_DevAddress) External.deposit(_amount); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function `payTaxes` transfers Ether to addresses stored in `m_TaxAddresses`. If any of these addresses is a contract, it could potentially reenter the contract by calling functions in its fallback function. This can lead to unexpected behaviors, such as draining funds from the contract. The correct approach would be to use a reentrancy guard or follow the checks-effects-interactions pattern.",
        "file_name": "0x193c4c0bdf474efe82a56e530f70af58810cf74d.sol"
    },
    {
        "function_name": "_swapTokensForETH",
        "code": "function _swapTokensForETH(uint256 _amount) private lockTheSwap { address[] memory _path = new address[](2); _path[0] = address(this); _path[1] = m_UniswapV2Router.WETH(); _approve(address(this), address(m_UniswapV2Router), _amount); m_UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( _amount, 0, _path, address(this), block.timestamp ); }",
        "vulnerability": "Potential sandwich attack",
        "reason": "The function `_swapTokensForETH` swaps tokens for ETH on the open market without slippage protection (amountOutMin is set to 0). This can be exploited by a sandwich attack, where an attacker can front-run and back-run transactions to manipulate the token price, leading to significant losses for the contract.",
        "file_name": "0x193c4c0bdf474efe82a56e530f70af58810cf74d.sol"
    },
    {
        "function_name": "setTaxAlloc",
        "code": "function setTaxAlloc(address payable _address, uint256 _alloc) internal virtual onlyOwner() { require(_alloc >= 0, \"Allocation must be at least 0\"); if(m_TotalAddresses > 11) require(_alloc == 0, \"Max wallet count reached\"); if (m_DidDeploy) { if (_address == m_DevAddress) { require(_msgSender() == m_WebThree); } } uint _idx = m_TaxIdx[_address]; if (_idx == 0) { require(m_TotalAlloc.add(_alloc) <= 6500); m_TaxAlloc.push(_alloc); m_TaxAddresses.push(_address); m_TaxIdx[_address] = m_TaxAlloc.length - 1; m_TotalAlloc = m_TotalAlloc.add(_alloc); } else { uint256 _priorAlloc = m_TaxAlloc[_idx]; require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 6500); m_TaxAlloc[_idx] = _alloc; m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc); if(_alloc == 0) m_TotalAddresses = m_TotalAddresses.sub(1); } if(_alloc > 0) m_TotalAddresses += 1; }",
        "vulnerability": "Improper access control",
        "reason": "The function `setTaxAlloc` allows the owner to set allocation for tax addresses, which can potentially be misused to drain funds by setting high allocation percentages to addresses controlled by the owner. Although it is protected by an `onlyOwner` modifier, if the owner's private key is compromised, an attacker can exploit this function to redirect funds.",
        "file_name": "0x193c4c0bdf474efe82a56e530f70af58810cf74d.sol"
    }
]