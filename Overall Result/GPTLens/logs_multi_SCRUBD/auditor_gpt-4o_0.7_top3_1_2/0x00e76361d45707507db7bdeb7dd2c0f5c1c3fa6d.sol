[
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Potential abuse of manual swap function",
        "reason": "The 'manualswap' function can only be called by the address '_feeAddrWallet1', allowing it to swap all tokens held by the contract for ETH. If '_feeAddrWallet1' is compromised or misused, it could drain all tokens in the contract, affecting token holders negatively.",
        "file_name": "0x00e76361d45707507db7bdeb7dd2c0f5c1c3fa6d.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _feeAddrWallet1); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Potential abuse of manual send function",
        "reason": "Similar to 'manualswap', the 'manualsend' function allows '_feeAddrWallet1' to transfer all ETH balance held by the contract to designated fee addresses. This could be exploited if the controlling address is compromised, leading to unauthorized withdrawal of funds.",
        "file_name": "0x00e76361d45707507db7bdeb7dd2c0f5c1c3fa6d.sol"
    },
    {
        "function_name": "removeStrictTxLimit",
        "code": "function removeStrictTxLimit() public onlyOwner { _maxTxAmount = 1e12 * 10**9; }",
        "vulnerability": "Unlimited transaction size by owner",
        "reason": "The 'removeStrictTxLimit' function allows the owner to set the maximum transaction amount to the total supply, effectively removing any transaction limit. This could be exploited by the owner to perform large transfers, potentially manipulating the market or executing large trades that could adversely affect the token's price.",
        "file_name": "0x00e76361d45707507db7bdeb7dd2c0f5c1c3fa6d.sol"
    }
]