[
    {
        "function_name": "payTaxes",
        "code": "function payTaxes(uint256 _eth, uint256 _d) internal virtual { for (uint i = 1; i < m_TaxAlloc.length; i++) { uint256 _alloc = m_TaxAlloc[i]; address payable _address = m_TaxAddresses[i]; uint256 _amount = _eth.mul(_alloc).div(_d); if (_amount > 1){ _address.transfer(_amount); if(_address == m_DevAddress) External.deposit(_amount); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function `payTaxes` includes a call to an external contract via the `transfer` method, followed by another external call to `External.deposit` without using a reentrancy guard. This makes it susceptible to reentrancy attacks, where the external contract could call back into the `payTaxes` function before the first call completes, potentially causing unintended behavior or draining of funds.",
        "file_name": "0x0d2508ff66a445116029b153f5ca261145717cc1.sol"
    },
    {
        "function_name": "setTaxAlloc",
        "code": "function setTaxAlloc(address payable _address, uint256 _alloc) internal virtual onlyOwner() { if (m_DidDeploy) { if (_address == m_DevAddress) { require(_msgSender() == m_WebThree); } } uint _idx = m_TaxIdx[_address]; if (_idx == 0) { require(m_TotalAlloc.add(_alloc) <= 10500); m_TaxAlloc.push(_alloc); m_TaxAddresses.push(_address); m_TaxIdx[_address] = m_TaxAlloc.length - 1; m_TotalAlloc = m_TotalAlloc.add(_alloc); } else { uint256 _priorAlloc = m_TaxAlloc[_idx]; require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 10500); m_TaxAlloc[_idx] = _alloc; m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc); } }",
        "vulnerability": "Privilege escalation vulnerability",
        "reason": "The function `setTaxAlloc` checks if the `_address` is the `m_DevAddress` and requires the caller to be `m_WebThree`. This check is only performed if `m_DidDeploy` is true. The conditional check allows a potential privilege escalation if the condition is not met, allowing any owner to change critical settings without verifying the caller's identity in other scenarios.",
        "file_name": "0x0d2508ff66a445116029b153f5ca261145717cc1.sol"
    },
    {
        "function_name": "_swapTokensForETH",
        "code": "function _swapTokensForETH(uint256 _amount) private lockTheSwap { address[] memory _path = new address[](2); _path[0] = address(this); _path[1] = m_UniswapV2Router.WETH(); _approve(address(this), address(m_UniswapV2Router), _amount); m_UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( _amount, 0, _path, address(this), block.timestamp ); }",
        "vulnerability": "Lack of slippage protection",
        "reason": "The function `_swapTokensForETH` uses `swapExactTokensForETHSupportingFeeOnTransferTokens` with a minimum amount of output tokens set to zero. This lack of slippage protection can lead to significant token losses during a swap, as it doesn't guarantee a minimum amount of ETH received, potentially allowing an attacker or a market fluctuation to drain more tokens for less ETH.",
        "file_name": "0x0d2508ff66a445116029b153f5ca261145717cc1.sol"
    }
]