[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable _ownerNew) external onlyOwner { owner = _ownerNew; emit OwnershipTransferred(_ownerNew); }",
        "vulnerability": "Lack of input validation",
        "reason": "The function does not validate the new owner's address. If the owner mistakenly or maliciously sets the new owner to an incorrect or zero address, it could lead to a loss of contract control.",
        "file_name": "0x0654b7f747c9ee9f5fb5eba443e9fe64f1fa77ef.sol"
    },
    {
        "function_name": "_sellTaxedTokens",
        "code": "function _sellTaxedTokens() private swapping { uint256 _tokens = _tokensTeam + _tokensInsurance + _tokensLiqExchange + _tokensLiqToken; uint256 _liquidityTokensToSwapHalf = _tokensLiqToken / 2; uint256 _swapInput = balanceOf(address(this)) - _liquidityTokensToSwapHalf; uint256 _balanceSnapshot = address(this).balance; address[] memory path = new address[](2); path[0] = address(this); path[1] = WETH; router.swapExactTokensForETHSupportingFeeOnTransferTokens(_swapInput, 0, path, address(this), block.timestamp); uint256 _tax = address(this).balance - _balanceSnapshot; uint256 _taxTeam = _tax * _tokensTeam / _tokens / 2; uint256 _taxInsurance = _tax * _tokensInsurance / _tokens; uint256 _taxLiqExchange = _tax * _tokensLiqExchange / _tokens; uint256 _taxLiqToken = _tax * _tokensLiqToken / _tokens; _tokensTeam = 0; _tokensInsurance = 0; _tokensLiqExchange = 0; _tokensLiqToken = 0; if (_taxTeam > 0) payable(walletTeam).call{value: _taxTeam}(\"\"); if (_taxInsurance > 0) payable(walletInsurance).call{value: _taxInsurance}(\"\"); if (_taxLiqExchange > 0) payable(walletLiqExchange).call{value: _taxLiqExchange}(\"\"); if (_taxLiqToken > 0) router.addLiquidityETH{value: _taxLiqToken}(address(this), _liquidityTokensToSwapHalf, 0, 0, walletLiqToken, block.timestamp); }",
        "vulnerability": "Reentrancy attack via call",
        "reason": "The use of 'call' to send ether in the function can lead to reentrancy attacks. Although the function is marked with a swapping modifier, which might prevent reentrancy in this scenario, the logic is still potentially unsafe if the swapping modifier logic changes or if other vulnerabilities are introduced.",
        "file_name": "0x0654b7f747c9ee9f5fb5eba443e9fe64f1fa77ef.sol"
    },
    {
        "function_name": "transferETH",
        "code": "function transferETH() external onlyOwner { payable(msg.sender).call{value: address(this).balance}(\"\"); }",
        "vulnerability": "Improper use of call",
        "reason": "The use of 'call' without checking for success can lead to ether getting stuck in the contract if the call fails. Moreover, using 'call' without a gas limit can open the door to reentrancy attacks under different circumstances.",
        "file_name": "0x0654b7f747c9ee9f5fb5eba443e9fe64f1fa77ef.sol"
    }
]