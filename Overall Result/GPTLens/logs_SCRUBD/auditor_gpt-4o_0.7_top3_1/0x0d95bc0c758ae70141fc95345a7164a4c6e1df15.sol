[
    {
        "function_name": "forceSwap",
        "code": "function forceSwap() external onlyOwner { _swapTokensForEth(balanceOf(address(this))); (bool success,) = address(feeWallet).call{value : address(this).balance}(\"\"); success = false; }",
        "vulnerability": "Potential loss of funds due to unchecked call",
        "reason": "The forceSwap function performs a call to transfer ETH to the feeWallet without checking the success of the transaction. Although it sets the success variable, it is immediately set to false, disregarding the actual result of the call. This could result in loss of funds if the call fails, as the contract would not revert and the owner wouldn't be notified of the failed transfer.",
        "file_name": "0x0d95bc0c758ae70141fc95345a7164a4c6e1df15.sol"
    },
    {
        "function_name": "forceSend",
        "code": "function forceSend() external onlyOwner { (bool success,) = address(feeWallet).call{value : address(this).balance}(\"\"); success = false; }",
        "vulnerability": "Potential loss of funds due to unchecked call",
        "reason": "Similar to the forceSwap function, forceSend performs a call to transfer ETH to the feeWallet without checking the success of the transaction. The success variable is set but immediately reset to false, ignoring whether the transfer was successful. This could lead to loss of funds or failed transactions going unnoticed.",
        "file_name": "0x0d95bc0c758ae70141fc95345a7164a4c6e1df15.sol"
    },
    {
        "function_name": "establishTrading",
        "code": "function establishTrading(uint256 _percent) external onlyOwner payable { require(_percent <= 100, 'must be between 0-100%'); require(_launchTime == 0, 'already launched'); require(_percent == 0 || msg.value > 0, 'need ETH for initial LP'); deadBlocks = 0; uint256 _lpSupply = (totalSupply() * _percent) / 100; uint256 _leftover = totalSupply() - _lpSupply; if (_lpSupply > 0) { _addLp(_lpSupply, msg.value); } if (_leftover > 0) { _transfer(address(this), owner(), _leftover); } tradingActive = true; _launchTime = block.timestamp; _launchBlock = block.number; }",
        "vulnerability": "Lack of validation on initial liquidity percentage",
        "reason": "The establishTrading function allows the owner to set any percentage of the total supply for initial liquidity provision, without sufficient validation. If the owner mistakenly or maliciously sets a very low percentage, it could lead to insufficient liquidity, high slippage, and manipulation of token prices during the initial trading phase.",
        "file_name": "0x0d95bc0c758ae70141fc95345a7164a4c6e1df15.sol"
    }
]