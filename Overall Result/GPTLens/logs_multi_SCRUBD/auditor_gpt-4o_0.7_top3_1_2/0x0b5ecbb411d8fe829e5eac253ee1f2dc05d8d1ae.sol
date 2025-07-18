[
    {
        "function_name": "enableTrading",
        "code": "function enableTrading() internal onlyOwner {\n    tradingActive = true;\n    swapAndLiquifyEnabled = true;\n    tradingActiveBlock = block.number;\n    earlyBuyPenaltyEnd = block.timestamp + 30 days;\n}",
        "vulnerability": "Trading Activation Control",
        "reason": "The function `enableTrading` is marked as `internal`, which means it can only be called within the contract or by derived contracts. While this seems like a minor issue, the actual implementation of trading activation is controlled only by the owner, which centralizes control. If the owner's account is compromised, an attacker could enable trading prematurely or inappropriately, causing disruption or facilitating other exploits.",
        "file_name": "0x0b5ecbb411d8fe829e5eac253ee1f2dc05d8d1ae.sol"
    },
    {
        "function_name": "forceSwapBack",
        "code": "function forceSwapBack() external onlyOwner {\n    uint256 contractBalance = balanceOf(address(this));\n    require(contractBalance >= _tTotal / 100, \"Can only swap back if more than 1% of tokens stuck on contract\");\n    swapBack();\n    emit OwnerForcedSwapBack(block.timestamp);\n}",
        "vulnerability": "Forced Swap Back Control",
        "reason": "The function `forceSwapBack` allows the owner to forcibly perform a token swap back when the contract holds more than 1% of the total token supply. This function could be abused by a malicious owner to manipulate token price or liquidity, especially if they can repeatedly call this function in a short period.",
        "file_name": "0x0b5ecbb411d8fe829e5eac253ee1f2dc05d8d1ae.sol"
    },
    {
        "function_name": "withdrawStuckETH",
        "code": "function withdrawStuckETH() external onlyOwner {\n    require(!tradingActive, \"Can only withdraw if trading hasn't started\");\n    bool success;\n    (success,) = address(msg.sender).call{value: address(this).balance}(\"\");\n}",
        "vulnerability": "ETH Withdrawal Before Trading",
        "reason": "The `withdrawStuckETH` function allows the contract owner to withdraw all ETH from the contract before trading is activated. This could be exploited by the owner to drain any ETH held by the contract under the pretense of 'stuck' funds, potentially defrauding early investors or those who have contributed ETH to the contract's liquidity.",
        "file_name": "0x0b5ecbb411d8fe829e5eac253ee1f2dc05d8d1ae.sol"
    }
]