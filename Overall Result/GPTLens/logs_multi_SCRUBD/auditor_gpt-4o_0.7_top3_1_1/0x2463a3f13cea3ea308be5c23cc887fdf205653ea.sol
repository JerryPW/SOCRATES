[
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal lockTheSwap { uint256 tokenBalance = _balances[address(this)]; uint256 _totalCollected = taxesCollected[0] + taxesCollected[1] + taxesCollected[2]; uint256 mktShare = taxesCollected[0]; uint256 lpShare = taxesCollected[1]; uint256 devShare = taxesCollected[2]; uint256 tokensForLiquidity = lpShare / 2; uint256 amountToSwap = tokenBalance - tokensForLiquidity; swapTokensForETH(amountToSwap); uint256 totalETHBalance = address(this).balance; uint256 ETHForMkt = totalETHBalance * mktShare / _totalCollected; uint256 ETHForLiquidity = totalETHBalance * lpShare / _totalCollected / 2; uint256 ETHForDev = totalETHBalance * devShare/ _totalCollected; if (totalETHBalance > 0) { payable(marketingWallet).transfer(ETHForMkt); } if (tokensForLiquidity > 0) { addLiquidity(tokensForLiquidity, ETHForLiquidity); } if (ETHForDev > 0) { payable(devWallet).transfer(ETHForDev); } delete taxesCollected; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The swapBack function transfers ETH to external addresses, which can potentially allow reentrancy attacks. Although the lockTheSwap modifier is used to prevent reentrancy within the same function, if any of the external calls (like transfer) to marketingWallet or devWallet lead to a fallback function that calls back into the contract, it might lead to unexpected behavior. It is generally safer to perform all state changes before making external calls.",
        "file_name": "0x2463a3f13cea3ea308be5c23cc887fdf205653ea.sol"
    },
    {
        "function_name": "massDistributeTokens",
        "code": "function massDistributeTokens(address[] calldata _airdropAddresses, uint amtPerAddress) external onlyOwner { for (uint i = 0; i < _airdropAddresses.length; i++) { IERC20(address(this)).transfer(_airdropAddresses[i], amtPerAddress); } }",
        "vulnerability": "Gas Limit Vulnerability",
        "reason": "The massDistributeTokens function can run out of gas if the length of _airdropAddresses is too large. This function does not implement any gas consumption checks or mechanisms to handle large arrays safely. An attacker could exploit this by calling the function with a very large array, causing it to run out of gas and revert.",
        "file_name": "0x2463a3f13cea3ea308be5c23cc887fdf205653ea.sol"
    },
    {
        "function_name": "distributeTokensByAmount",
        "code": "function distributeTokensByAmount(address[] calldata _airdropAddresses, uint[] calldata _airdropAmounts) external onlyOwner { for (uint i = 0; i < _airdropAddresses.length; i++) { IERC20(address(this)).transfer(_airdropAddresses[i], _airdropAmounts[i]); } }",
        "vulnerability": "Gas Limit Vulnerability",
        "reason": "Similar to the massDistributeTokens function, distributeTokensByAmount can also run out of gas if the length of _airdropAddresses or _airdropAmounts is too large. Without checks for gas consumption, this function is susceptible to failing when provided with excessively large input arrays, which can be exploited to cause denial of service for legitimate users.",
        "file_name": "0x2463a3f13cea3ea308be5c23cc887fdf205653ea.sol"
    }
]