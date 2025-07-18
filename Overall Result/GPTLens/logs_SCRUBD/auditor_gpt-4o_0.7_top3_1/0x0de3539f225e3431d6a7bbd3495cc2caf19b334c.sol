[
    {
        "function_name": "cooldown",
        "code": "mapping (address => uint) private cooldown;",
        "vulnerability": "Ineffective cooldown mechanism",
        "reason": "The cooldown mechanism is supposed to prevent rapid consecutive transactions by the same address. However, it is only checked when buying tokens from the Uniswap pair and does not affect transfers or sells. This means that users can bypass this restriction by transferring tokens to another account or directly interacting with the contract, reducing its effectiveness in preventing bot transactions.",
        "file_name": "0x0de3539f225e3431d6a7bbd3495cc2caf19b334c.sol"
    },
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Centralized control over swaps",
        "reason": "The `manualswap` function allows the `_feeAddrWallet1` address to convert the contract's token balance to ETH at will. This centralized control poses a risk as it allows a single address to potentially exploit or disrupt the normal functioning of the token swaps, leading to trust issues among token holders.",
        "file_name": "0x0de3539f225e3431d6a7bbd3495cc2caf19b334c.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _feeAddrWallet1); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Centralized control over ETH distribution",
        "reason": "Similar to the `manualswap` function, the `manualsend` function enables the `_feeAddrWallet1` address to send the entire ETH balance of the contract to predefined wallets. This centralization can be exploited if the controlling address is compromised, resulting in the loss of funds or misuse of collected fees, again leading to trust issues and potential financial losses for other token holders.",
        "file_name": "0x0de3539f225e3431d6a7bbd3495cc2caf19b334c.sol"
    }
]