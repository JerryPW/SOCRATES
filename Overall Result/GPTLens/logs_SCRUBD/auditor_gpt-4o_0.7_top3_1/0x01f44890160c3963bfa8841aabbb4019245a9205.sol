[
    {
        "function_name": "setBots",
        "code": "function setBots(address[] memory bots_) public onlyOwner { for (uint i = 0; i < bots_.length; i++) { bots[bots_[i]] = true; } }",
        "vulnerability": "Potential for abuse by the owner to manipulate trading",
        "reason": "The owner can arbitrarily mark any address as a bot, potentially blocking legitimate users from trading. This centralization of control can be exploited to manipulate the market or punish specific addresses.",
        "file_name": "0x01f44890160c3963bfa8841aabbb4019245a9205.sol"
    },
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Restricted manual swap that can be manipulated",
        "reason": "The manual swap function is restricted to _feeAddrWallet1, allowing the owner of this wallet to decide when to swap tokens for ETH. This can be used to manipulate the timing of token sales, affecting the market unpredictably.",
        "file_name": "0x01f44890160c3963bfa8841aabbb4019245a9205.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _feeAddrWallet1); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Centralized control over ETH distribution",
        "reason": "Like manualswap, this function is restricted to _feeAddrWallet1, allowing the owner of this wallet to control when and how the collected ETH is distributed. This centralization can be abused to delay or selectively distribute funds.",
        "file_name": "0x01f44890160c3963bfa8841aabbb4019245a9205.sol"
    }
]