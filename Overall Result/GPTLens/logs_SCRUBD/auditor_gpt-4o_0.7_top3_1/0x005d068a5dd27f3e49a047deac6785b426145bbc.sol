[
    {
        "function_name": "setBots",
        "code": "function setBots(address[] memory bots_) public onlyOwner { for (uint i = 0; i < bots_.length; i++) { bots[bots_[i]] = true; } }",
        "vulnerability": "Bot Blocking Manipulation",
        "reason": "This function allows the owner to arbitrarily mark any address as a bot, effectively blocking it from trading. This centralization can be abused by the owner to block legitimate users without any recourse or transparency.",
        "file_name": "0x005d068a5dd27f3e49a047deac6785b426145bbc.sol"
    },
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Potential Fund Drain by Fee Wallet",
        "reason": "The function allows the fee address wallet (_feeAddrWallet1) to swap all tokens in the contract for ETH. If this wallet is compromised or malicious, it could drain the contract's token balance by continuously calling this function.",
        "file_name": "0x005d068a5dd27f3e49a047deac6785b426145bbc.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _feeAddrWallet1); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Unrestricted ETH Transfer",
        "reason": "This function allows the fee address wallet (_feeAddrWallet1) to transfer all ETH from the contract to itself and another wallet. If the fee address is compromised, it could empty the contract's ETH balance at will.",
        "file_name": "0x005d068a5dd27f3e49a047deac6785b426145bbc.sol"
    }
]