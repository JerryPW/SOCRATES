[
    {
        "function_name": "swapTokensForETH",
        "code": "function swapTokensForETH(uint256 tokenAmount) private lockTheSwap { address[] memory path = new address[](2); path[0] = address(this); path[1] = router.WETH(); _approve(address(this), address(router), tokenAmount); router.swapExactTokensForETHSupportingFeeOnTransferTokens( tokenAmount, 0, path, address(this), block.timestamp ); (bool success, ) = treasuryAddress.call{value: (ETHAmount.treasury * address(this).balance)/tokenAmount}(\"\"); require(success, 'ETH_TRANSFER_FAILED'); ETHAmount.treasury = 0; (success, ) = developmentAddress.call{value: (ETHAmount.development * address(this).balance)/tokenAmount}(\"\"); require(success, 'ETH_TRANSFER_FAILED'); ETHAmount.development = 0; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function uses low-level call to transfer ETH to external addresses without checks-effects-interactions pattern. This could potentially allow for reentrancy attacks where an attacker can re-enter the contract during the execution of the call and manipulate state variables, leading to possible theft of funds.",
        "file_name": "0x081d8a340d384cffca0c2dafbf45020d760d7576.sol"
    },
    {
        "function_name": "_tokenTransfer",
        "code": "function _tokenTransfer(address sender, address recipient, uint256 tAmount, uint8 takeFee) private { valuesFromGetValues memory s = _getValues(tAmount, takeFee); if (_isExcluded[sender] ) { _tOwned[sender] = _tOwned[sender] - tAmount; } if (_isExcluded[recipient]) { _tOwned[recipient] = _tOwned[recipient] + s.tTransferAmount; } _rOwned[sender] = _rOwned[sender]-s.rAmount; _rOwned[recipient] = _rOwned[recipient]+s.rTransferAmount; if(s.rRfi > 0 || s.tRfi > 0) _reflectRfi(s.rRfi, s.tRfi); if(s.rTreasury > 0 || s.tTreasury > 0){ _takeTreasury(s.rTreasury, s.tTreasury); emit Transfer(sender, treasuryAddress, s.tDevelopment); } if(s.rDevelopment > 0 || s.tDevelopment > 0){ _takeDevelopment(s.rDevelopment, s.tDevelopment); emit Transfer(sender, developmentAddress, s.tDevelopment); } if(s.rBurn > 0 || s.tBurn > 0){ _takeBurn(s.rBurn, s.tBurn); emit Transfer(sender, burnAddress, s.tBurn); } emit Transfer(sender, recipient, s.tTransferAmount); }",
        "vulnerability": "Incorrect event emission",
        "reason": "The function emits a Transfer event with a potentially incorrect value for the treasuryAddress when transferring treasury fees. Instead of emitting s.tTreasury, it emits s.tDevelopment, which could cause discrepancies in tracking transfers and auditing the contract.",
        "file_name": "0x081d8a340d384cffca0c2dafbf45020d760d7576.sol"
    },
    {
        "function_name": "rescueAnyERC20Tokens",
        "code": "function rescueAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner { IERC20(_tokenAddr).transfer(_to, _amount); }",
        "vulnerability": "Potential misuse by owner",
        "reason": "This function allows the owner to transfer any ERC20 tokens from the contract to any address. There are no checks to ensure that the tokens being transferred are not the contract's own tokens, which could be drained by the owner, leading to a loss of funds for token holders.",
        "file_name": "0x081d8a340d384cffca0c2dafbf45020d760d7576.sol"
    }
]