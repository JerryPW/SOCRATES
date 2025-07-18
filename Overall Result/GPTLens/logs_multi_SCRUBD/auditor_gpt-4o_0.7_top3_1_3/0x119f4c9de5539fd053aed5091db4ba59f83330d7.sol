[
    {
        "function_name": "swapTokensForEth",
        "code": "function swapTokensForEth(uint256 tokenAmount) private {\n    address[] memory path = new address[](2);\n    path[0] = address(this);\n    path[1] = uniswapV2Router.WETH();\n    _approve(address(this), address(uniswapV2Router), tokenAmount);\n    uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n        tokenAmount,\n        0,\n        path,\n        address(this),\n        block.timestamp\n    );\n}",
        "vulnerability": "Lack of slippage tolerance",
        "reason": "The function swaps tokens for ETH without specifying a minimum amount of ETH to receive. This could lead to significant loss of funds if the price changes unfavorably during the transaction execution, allowing an attacker to manipulate the price and cause the contract to receive far less ETH than expected.",
        "file_name": "0x119f4c9de5539fd053aed5091db4ba59f83330d7.sol"
    },
    {
        "function_name": "updateGasForTransfer",
        "code": "function updateGasForTransfer(uint256 newGasForTransfer) external onlyOwner {\n    require(newGasForTransfer != gasForTransfer, \"PENGU_Dividend_Tracker: Cannot update gasForTransfer to same value\");\n    emit GasForTransferUpdated(newGasForTransfer, gasForTransfer);\n    gasForTransfer = newGasForTransfer;\n}",
        "vulnerability": "Gas limit manipulation",
        "reason": "The owner can change the gas limit arbitrarily, which could potentially be set to a very low value, causing the dividend distribution process to fail. This manipulation could lead to denial of service for dividend payouts, affecting all token holders expecting dividends.",
        "file_name": "0x119f4c9de5539fd053aed5091db4ba59f83330d7.sol"
    },
    {
        "function_name": "sendEthToDev",
        "code": "function sendEthToDev(uint256 amount) private {\n    address payable _buyBackAddress = payable(0x72C935abeB07a955F9d9B881A784cECbcC3997Fb);\n    address payable _marketingAddress = payable(0x87AC09056fd909DDB7E1398Bb4DcF0b0B7d473C0);\n    address payable _oppAddress = payable(0x76bC307F0B562C417025E0A3290b3496Dc6Bae1F);\n    address payable _teamFeeAddress = payable(0xB701e71805cEeEBD5caFF976945AFa855Dc56a3A);\n    _buyBackAddress.transfer(amount.div(3));\n    _marketingAddress.transfer(amount.div(3));\n    uint256 oppFeeAndTeamFee = amount.div(3);\n    uint256 teamFee = oppFeeAndTeamFee.div(4);\n    uint256 oppFee = oppFeeAndTeamFee.sub(teamFee);\n    _oppAddress.transfer(oppFee);\n    _teamFeeAddress.transfer(teamFee);\n}",
        "vulnerability": "Hardcoded addresses for fund distribution",
        "reason": "The function uses hardcoded addresses for distribution of funds. If any of these addresses become compromised or need to be changed (e.g., due to a team restructure or change in marketing strategy), there is no flexibility to do so without redeploying the contract. This can lead to loss of funds if the addresses are no longer under control of the intended recipients.",
        "file_name": "0x119f4c9de5539fd053aed5091db4ba59f83330d7.sol"
    }
]