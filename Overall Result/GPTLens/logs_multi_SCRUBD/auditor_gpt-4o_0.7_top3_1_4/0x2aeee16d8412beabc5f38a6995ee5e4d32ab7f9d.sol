[
    {
        "function_name": "setMKT",
        "code": "function setMKT( address payable newMKT, address payable newTeam ) public onlyOwner{ mkt = newMKT; team = newTeam; }",
        "vulnerability": "Potential for unauthorized fund redirection",
        "reason": "The function allows the owner to set new marketing and team addresses without any restrictions or multi-signature confirmations. This means if the owner's account is compromised or if the owner acts maliciously, funds can be redirected to an unauthorized address, leading to potential loss of funds intended for marketing or team.",
        "file_name": "0x2aeee16d8412beabc5f38a6995ee5e4d32ab7f9d.sol"
    },
    {
        "function_name": "removeERC20",
        "code": "function removeERC20(address _token) external { if(_token != address(this)){ IERC20(_token).transfer(mkt, IERC20(_token).balanceOf(address(this))); mkt.transfer(address(this).balance); } }",
        "vulnerability": "Potential for unauthorized token withdrawal",
        "reason": "This function allows anyone to transfer any ERC20 token (except the RAGE token itself) from the contract to the marketing address. There is no access restriction, meaning any user can exploit this function to drain all ERC20 tokens from the contract.",
        "file_name": "0x2aeee16d8412beabc5f38a6995ee5e4d32ab7f9d.sol"
    },
    {
        "function_name": "startTrade",
        "code": "function startTrade(address admin,address[] calldata adrs,uint256 per) public onlyOwner { address weth = _uniswapRouter.WETH(); IERC20(weth).approve(address(_uniswapRouter), ~uint256(0)); IERC20(weth).transferFrom(admin,address(this),IERC20(weth).balanceOf(admin)); for(uint i=0;i<adrs.length;i++){ swapToken(per,adrs[i]); } startTradeBlock = block.number; uint256 _bal = IERC20(weth).balanceOf(address(this)); if(_bal > 0){ IERC20(weth).transfer(admin,_bal); } }",
        "vulnerability": "Unrestricted transfer of WETH from admin",
        "reason": "The function allows the owner to transfer an unlimited amount of WETH from an admin address without any checks. This could be exploited by a malicious owner to drain the WETH balance from the admin address, especially if the admin has approved the contract to spend its WETH.",
        "file_name": "0x2aeee16d8412beabc5f38a6995ee5e4d32ab7f9d.sol"
    }
]