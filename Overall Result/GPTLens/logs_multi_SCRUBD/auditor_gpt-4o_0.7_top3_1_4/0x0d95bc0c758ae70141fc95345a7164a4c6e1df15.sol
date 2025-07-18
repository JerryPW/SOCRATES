[
    {
        "function_name": "establishTrading",
        "code": "function establishTrading(uint256 _percent) external onlyOwner payable { require(_percent <= 100, 'must be between 0-100%'); require(_launchTime == 0, 'already launched'); require(_percent == 0 || msg.value > 0, 'need ETH for initial LP'); deadBlocks = 0; uint256 _lpSupply = (totalSupply() * _percent) / 100; uint256 _leftover = totalSupply() - _lpSupply; if (_lpSupply > 0) { _addLp(_lpSupply, msg.value); } if (_leftover > 0) { _transfer(address(this), owner(), _leftover); } tradingActive = true; _launchTime = block.timestamp; _launchBlock = block.number; }",
        "vulnerability": "Centralized control over trading activation",
        "reason": "The function allows the contract owner to activate trading by providing a percentage of the total supply to be used for liquidity. This centralized control can be misused by the owner to manipulate trading conditions, such as withholding trading or setting unfavorable initial conditions.",
        "file_name": "0x0d95bc0c758ae70141fc95345a7164a4c6e1df15.sol"
    },
    {
        "function_name": "removeRestrictions",
        "code": "function removeRestrictions() external onlyOwner returns (bool) { limitsInEffect = false; return true; }",
        "vulnerability": "Centralized control over restrictions",
        "reason": "This function allows the contract owner to remove trading restrictions entirely. This could be exploited by the owner to bypass anti-bot measures and limits, potentially resulting in unfair advantage or market manipulation.",
        "file_name": "0x0d95bc0c758ae70141fc95345a7164a4c6e1df15.sol"
    },
    {
        "function_name": "forceSwap",
        "code": "function forceSwap() external onlyOwner { _swapTokensForEth(balanceOf(address(this))); (bool success,) = address(feeWallet).call{value : address(this).balance}(\"\"); success = false; }",
        "vulnerability": "Misleading failure handling",
        "reason": "The function attempts to swap tokens for ETH and send ETH to the fee wallet. However, the boolean 'success' is always set to false after the call, regardless of the actual transaction success. This could mislead developers into thinking the operation failed when it might have succeeded, leading to potential logic errors and fund mismanagement.",
        "file_name": "0x0d95bc0c758ae70141fc95345a7164a4c6e1df15.sol"
    }
]