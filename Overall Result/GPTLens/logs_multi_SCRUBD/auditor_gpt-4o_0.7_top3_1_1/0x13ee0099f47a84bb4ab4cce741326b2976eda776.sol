[
    {
        "function_name": "setWithdrawAddress",
        "code": "function setWithdrawAddress(address newWithdrawAddress) external onlyWithdrawer { _withdrawAddress = newWithdrawAddress; }",
        "vulnerability": "Privilege Escalation",
        "reason": "The function allows the current withdrawer to change the withdraw address without any restriction, which can potentially lead to unauthorized changes if the withdrawer's credentials are compromised. This is a privilege escalation risk as it gives the current withdrawer unrestricted control to redirect funds.",
        "file_name": "0x13ee0099f47a84bb4ab4cce741326b2976eda776.sol"
    },
    {
        "function_name": "setShare",
        "code": "function setShare(uint256 thisSharePpm, uint256 stackingSharePpm) external onlyWithdrawer { thisShare = thisSharePpm; extraShare = stackingSharePpm; require(thisShare + extraShare <= 1000); }",
        "vulnerability": "Fee Manipulation",
        "reason": "The function allows the withdrawer to set arbitrary values for thisShare and extraShare, which can be manipulated to unfairly distribute or retain fees. This can enable the withdrawer to misappropriate funds by setting high shares for themselves or associated addresses, impacting token holders.",
        "file_name": "0x13ee0099f47a84bb4ab4cce741326b2976eda776.sol"
    },
    {
        "function_name": "createLiquidity",
        "code": "function createLiquidity() public onlyOwner { require(uniswapPair == address(0)); address pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair( address(this), _uniswapV2Router.WETH() ); uint256 initialLiquidity = getSupplyForMakeLiquidity(); _balances[address(this)] = initialLiquidity; emit Transfer(address(0), address(this), initialLiquidity); _balances[msg.sender] = 1e19; emit Transfer(address(0), msg.sender, initialLiquidity); _allowances[address(this)][ address(_uniswapV2Router) ] = INFINITY_ALLOWANCE; _isExcludedFromFee[pair] = true; _uniswapV2Router.addLiquidityETH{value: address(this).balance}( address(this), initialLiquidity, 0, 0, msg.sender, block.timestamp ); uniswapPair = pair; tradingStartTime = block.timestamp; }",
        "vulnerability": "Liquidity Initialization Vulnerability",
        "reason": "The function allows the contract owner to create liquidity and transfer initial liquidity tokens to themselves without any restrictions. This can lead to potential rug pull scenarios where the contract owner can withdraw liquidity immediately after creation, leaving other investors with worthless tokens.",
        "file_name": "0x13ee0099f47a84bb4ab4cce741326b2976eda776.sol"
    }
]