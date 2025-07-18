[
    {
        "function_name": "claimETH",
        "code": "function claimETH(address addr) private{ require(!_isWithdrawing); _isWithdrawing=true; uint256 amount; if(isExcludedFromStaking(addr)){ amount=toBePaid[addr]; toBePaid[addr]=0; } else{ uint256 newAmount=_newDividentsOf(addr); alreadyPaidShares[addr] = profitPerShare * _balances[addr]; amount=toBePaid[addr]+newAmount; toBePaid[addr]=0; } if(amount==0){ _isWithdrawing=false; return; } totalPayouts+=amount; address[] memory path = new address[](2); path[0] = _uniswapv2Router.WETH(); path[1] = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; _uniswapv2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}( 0, path, addr, block.timestamp); emit OnWithdrawETH(amount, addr); _isWithdrawing=false; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function claimETH does not use a reentrancy guard pattern effectively. The _isWithdrawing flag is set before the external call to _uniswapv2Router, which can potentially allow a reentrant call before the flag is reset, enabling an attacker to re-enter the function and manipulate state variables like toBePaid.",
        "file_name": "0x2638a23a9118d5786b6a6529bf3c09c922d3cdad.sol"
    },
    {
        "function_name": "TeamCollectRemainingETH",
        "code": "function TeamCollectRemainingETH() public onlyOwner{ require(block.timestamp >= _liquidityUnlockTime, \"Not yet unlocked\"); _liquidityUnlockTime=block.timestamp+DefaultLiquidityLockTime; (bool sent,) =Development.call{value: (address(this).balance)}(\"\"); require(sent); }",
        "vulnerability": "Lack of proper balance checks",
        "reason": "The function TeamCollectRemainingETH sends the full balance of the contract to the Development address without checking if the balance is greater than zero. If the call fails due to lack of balance or other reasons, the function does not handle the failure gracefully, potentially causing ether loss.",
        "file_name": "0x2638a23a9118d5786b6a6529bf3c09c922d3cdad.sol"
    },
    {
        "function_name": "TeamSetTaxes",
        "code": "function TeamSetTaxes(uint8 burnTaxes, uint8 liquidityTaxes, uint8 stakingTaxes,uint8 buyTax, uint8 sellTax, uint8 transferTax) public onlyOwner{ uint8 totalTax=burnTaxes+liquidityTaxes+stakingTaxes; require(totalTax==100, \"burn+liq+marketing needs to equal 100%\"); _burnTax=burnTaxes; _liquidityTax=liquidityTaxes; _stakingTax=stakingTaxes; _buyTax=buyTax; _sellTax=sellTax; _transferTax=transferTax; }",
        "vulnerability": "High centralized control",
        "reason": "The function TeamSetTaxes allows the owner to set arbitrary tax rates on transactions. Although the totalTax is checked to be 100, the owner can set very high values for buyTax, sellTax, or transferTax, making transactions prohibitively expensive for users, effectively freezing their assets.",
        "file_name": "0x2638a23a9118d5786b6a6529bf3c09c922d3cdad.sol"
    }
]