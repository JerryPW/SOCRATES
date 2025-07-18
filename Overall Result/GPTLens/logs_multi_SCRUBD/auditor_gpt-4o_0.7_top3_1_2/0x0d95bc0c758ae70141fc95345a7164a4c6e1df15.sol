[
    {
        "function_name": "forceSwap",
        "code": "function forceSwap() external onlyOwner { _swapTokensForEth(balanceOf(address(this))); (bool success,) = address(feeWallet).call{value : address(this).balance}(\"\"); success = false; }",
        "vulnerability": "Potential loss of funds due to unchecked return value in ETH transfer",
        "reason": "The function attempts to transfer the contract's ETH balance to the feeWallet using a low-level call, but it does not handle the case where the transfer fails. The `success` variable is set to false right after the call, indicating that the actual success of the transfer is not being checked or used, which could lead to a loss of funds if the transfer fails.",
        "file_name": "0x0d95bc0c758ae70141fc95345a7164a4c6e1df15.sol"
    },
    {
        "function_name": "forceSend",
        "code": "function forceSend() external onlyOwner { (bool success,) = address(feeWallet).call{value : address(this).balance}(\"\"); success = false; }",
        "vulnerability": "Potential loss of funds due to unchecked return value in ETH transfer",
        "reason": "Similar to `forceSwap`, this function attempts to transfer the contract's ETH balance to the feeWallet using a low-level call without checking if the transfer was successful. The `success` variable is set to false immediately after the call without any condition, meaning the result of the transfer is ignored, which can lead to a loss of funds if the transfer fails.",
        "file_name": "0x0d95bc0c758ae70141fc95345a7164a4c6e1df15.sol"
    },
    {
        "function_name": "establishTrading",
        "code": "function establishTrading(uint256 _percent) external onlyOwner payable { require(_percent <= 100, 'must be between 0-100%'); require(_launchTime == 0, 'already launched'); require(_percent == 0 || msg.value > 0, 'need ETH for initial LP'); deadBlocks = 0; uint256 _lpSupply = (totalSupply() * _percent) / 100; uint256 _leftover = totalSupply() - _lpSupply; if (_lpSupply > 0) { _addLp(_lpSupply, msg.value); } if (_leftover > 0) { _transfer(address(this), owner(), _leftover); } tradingActive = true; _launchTime = block.timestamp; _launchBlock = block.number; }",
        "vulnerability": "Potential for incorrect initial liquidity setup",
        "reason": "The function does not properly check whether an appropriate amount of tokens and ETH have been provided for initial liquidity. If `_percent` is set to 0, no ETH is required, but the function can still proceed, potentially leading to an incorrect initial liquidity setup. Additionally, if the owner accidentally provides insufficient ETH, the liquidity pool might not be set up correctly, leading to unexpected trading behavior.",
        "file_name": "0x0d95bc0c758ae70141fc95345a7164a4c6e1df15.sol"
    }
]