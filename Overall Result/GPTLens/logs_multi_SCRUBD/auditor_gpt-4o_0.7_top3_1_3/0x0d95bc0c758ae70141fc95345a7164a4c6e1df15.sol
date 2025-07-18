[
    {
        "function_name": "forceSwap",
        "code": "function forceSwap() external onlyOwner { _swapTokensForEth(balanceOf(address(this))); (bool success,) = address(feeWallet).call{value : address(this).balance}(\"\"); success = false; }",
        "vulnerability": "Potential loss of Ether",
        "reason": "The function calls `_swapTokensForEth` to swap tokens for Ether, and then attempts to transfer all Ether in the contract to `feeWallet`. However, the `success` variable is set to `false` after the transfer attempt, regardless of whether the transfer was successful or not, making it impossible to handle failed transfers properly. This could result in loss of Ether if the transfer fails and is not retried.",
        "file_name": "0x0d95bc0c758ae70141fc95345a7164a4c6e1df15.sol"
    },
    {
        "function_name": "forceSend",
        "code": "function forceSend() external onlyOwner { (bool success,) = address(feeWallet).call{value : address(this).balance}(\"\"); success = false; }",
        "vulnerability": "Potential loss of Ether",
        "reason": "Similar to `forceSwap`, this function attempts to transfer all Ether in the contract to `feeWallet`. The `success` variable is set to `false` after the transfer attempt, regardless of the actual success or failure of the transfer, preventing any error handling. This could lead to loss of Ether if the transfer fails, as the contract owner may believe the transfer was successful.",
        "file_name": "0x0d95bc0c758ae70141fc95345a7164a4c6e1df15.sol"
    },
    {
        "function_name": "teamMessage",
        "code": "function teamMessage(string memory input) external onlyOwner { }",
        "vulnerability": "Unused function",
        "reason": "The `teamMessage` function is empty and does not perform any actions. It could be intended for logging or other purposes, but as currently implemented, it serves no purpose. If there is an intention to log or communicate a message, the absence of implementation might lead to confusion or missed functionality. Additionally, being an `onlyOwner` function, it is a potential point of access that could be exploited in the future if modified carelessly.",
        "file_name": "0x0d95bc0c758ae70141fc95345a7164a4c6e1df15.sol"
    }
]