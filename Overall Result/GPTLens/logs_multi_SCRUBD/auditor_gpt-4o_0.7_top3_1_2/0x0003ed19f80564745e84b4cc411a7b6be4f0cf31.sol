[
    {
        "function_name": "setSwapEnabled",
        "code": "function setSwapEnabled(bool enabled) external { require(_msgSender() == _Dev); swapEnabled = enabled; }",
        "vulnerability": "Centralization Risk",
        "reason": "The function setSwapEnabled can only be called by the address set as _Dev. This centralization could allow the _Dev to enable or disable swapping at their will, potentially disrupting the market or manipulating token prices.",
        "file_name": "0x0003ed19f80564745e84b4cc411a7b6be4f0cf31.sol"
    },
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _Dev); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Centralized Control Over Token Swapping",
        "reason": "The manualswap function allows the _Dev to swap all tokens held by the contract for ETH at any time. This presents a risk if the _Dev acts maliciously or if their private key is compromised, allowing for the potential draining of tokens from the contract.",
        "file_name": "0x0003ed19f80564745e84b4cc411a7b6be4f0cf31.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _Dev); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Centralized Control Over ETH Withdrawal",
        "reason": "The manualsend function allows the _Dev to transfer all ETH held by the contract to the specified fee addresses. This centralization presents a risk if the _Dev acts maliciously or if their private key is compromised, allowing for the potential draining of ETH from the contract.",
        "file_name": "0x0003ed19f80564745e84b4cc411a7b6be4f0cf31.sol"
    }
]