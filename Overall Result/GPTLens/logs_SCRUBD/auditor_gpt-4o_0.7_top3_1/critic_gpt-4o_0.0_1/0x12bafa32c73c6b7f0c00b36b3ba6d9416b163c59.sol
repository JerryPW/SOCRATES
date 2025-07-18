[
    {
        "function_name": "payTaxes",
        "vulnerability": "Uncontrolled External Call",
        "criticism": "The reasoning is correct in identifying the risk of uncontrolled external calls. The function transfers Ether to addresses stored in m_TaxAddresses, which could be contracts with fallback functions that execute arbitrary code. This indeed poses a risk of reentrancy attacks or other unintended behaviors. The severity is moderate to high because if a reentrancy attack is possible, it could drain funds. The profitability is moderate because an attacker could potentially exploit this to steal Ether.",
        "correctness": 8,
        "severity": 6,
        "profitability": 5,
        "reason": "The `payTaxes` function involves transferring Ether to addresses that are stored in `m_TaxAddresses`. There is no control over these addresses, and if any of these addresses are contracts, they can implement a fallback function that could execute arbitrary code. This can lead to reentrancy attacks or other unintended behaviors.",
        "code": "function payTaxes(uint256 _eth, uint256 _d) internal virtual { for (uint i = 1; i < m_TaxAlloc.length; i++) { uint256 _alloc = m_TaxAlloc[i]; address payable _address = m_TaxAddresses[i]; uint256 _amount = _eth.mul(_alloc).div(_d); if (_amount > 1){ _address.transfer(_amount); if(_address == m_DevAddress) External.deposit(_amount); } } }",
        "file_name": "0x12bafa32c73c6b7f0c00b36b3ba6d9416b163c59.sol"
    },
    {
        "function_name": "addLiquidity",
        "vulnerability": "Potential for Locked Ether",
        "criticism": "The reasoning is correct in identifying the risk of Ether being locked if the liquidity addition fails. However, the severity is somewhat overstated. While the Ether could be locked, this scenario is contingent on the liquidity addition failing, which is not a common occurrence if the contract is correctly implemented. The profitability is low because an external attacker cannot directly profit from this situation.",
        "correctness": 8,
        "severity": 4,
        "profitability": 1,
        "reason": "The `addLiquidity` function transfers the entire contract's Ether balance to provide liquidity on Uniswap. If the liquidity addition fails for any reason, the Ether will remain locked in the contract since there is no mechanism to retrieve it. This can result in permanent loss of the contract's Ether balance.",
        "code": "function addLiquidity() external onlyOwner() { require(!m_Liquidity,\"Liquidity already added.\"); uint256 _ethBalance = address(this).balance; IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); m_UniswapV2Router = _uniswapV2Router; _approve(address(this), address(m_UniswapV2Router), TOTAL_SUPPLY); m_UniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH()); m_UniswapV2Router.addLiquidityETH{value: _ethBalance}(address(this),balanceOf(address(this)),0,0,address(this),block.timestamp); IERC20(m_UniswapV2Pair).approve(m_LiqLockSvcAddress, type(uint).max); FTPLiqLock(m_LiqLockSvcAddress).lockTokens(m_UniswapV2Pair, block.timestamp.add(3 days), msg.sender); EthReflect.init(address(this), 1000, m_UniswapV2Pair, _uniswapV2Router.WETH(), _ethBalance, TOTAL_SUPPLY); m_Liquidity = true; }",
        "file_name": "0x12bafa32c73c6b7f0c00b36b3ba6d9416b163c59.sol"
    },
    {
        "function_name": "setTaxAlloc",
        "vulnerability": "Improper Access Control",
        "criticism": "The reasoning is correct in identifying the lack of access control for setting tax allocations to arbitrary addresses. This could allow the owner to divert funds, leading to potential misuse or theft. The severity is high because it allows for significant misuse of funds by the owner. The profitability is high for the owner, but not for an external attacker, as this is an internal control issue.",
        "correctness": 9,
        "severity": 7,
        "profitability": 2,
        "reason": "The `setTaxAlloc` function allows the owner to set tax allocations to arbitrary addresses. Although there is a check for `m_WebThree` when setting the developer address, there is no such control for other addresses. This can allow the owner to divert funds to any address, potentially leading to misuse or theft of funds.",
        "code": "function setTaxAlloc(address payable _address, uint256 _alloc) internal virtual onlyOwner() { if (m_DidDeploy) { if (_address == m_DevAddress) { require(_msgSender() == m_WebThree); } } uint _idx = m_TaxIdx[_address]; if (_idx == 0) { require(m_TotalAlloc.add(_alloc) <= 10500); m_TaxAlloc.push(_alloc); m_TaxAddresses.push(_address); m_TaxIdx[_address] = m_TaxAlloc.length - 1; m_TotalAlloc = m_TotalAlloc.add(_alloc); } else { uint256 _priorAlloc = m_TaxAlloc[_idx]; require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 10500); m_TaxAlloc[_idx] = _alloc; m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc); } }",
        "file_name": "0x12bafa32c73c6b7f0c00b36b3ba6d9416b163c59.sol"
    }
]