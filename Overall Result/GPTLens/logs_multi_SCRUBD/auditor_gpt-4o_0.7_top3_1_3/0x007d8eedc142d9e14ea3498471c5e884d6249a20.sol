[
    {
        "function_name": "editPercentages",
        "code": "function editPercentages(uint256 _pc1, uint256 _pc2, uint256 _pc3) external { require(_msgSender() == _deployer); require(_pc1 + _pc2 + _pc3 == 100,\"math faggot\"); pc1 = _pc1; pc2 = _pc2; pc3 = _pc3; }",
        "vulnerability": "Inappropriate error message",
        "reason": "The error message 'math faggot' is inappropriate and offensive. While not technically a vulnerability that can be exploited, it reflects poorly on the professionalism and inclusivity of the project.",
        "file_name": "0x007d8eedc142d9e14ea3498471c5e884d6249a20.sol"
    },
    {
        "function_name": "removeLimits",
        "code": "function removeLimits() external { require(_msgSender() == _deployer); _maxTxAmount = _tTotal; _maxWalletAmount = _tTotal; }",
        "vulnerability": "Potentially unlimited transaction and wallet amounts",
        "reason": "The function allows the deployer to remove the limits on the maximum transaction amount and wallet amount, which could be exploited to conduct large transfers and potentially manipulate token price or liquidity.",
        "file_name": "0x007d8eedc142d9e14ea3498471c5e884d6249a20.sol"
    },
    {
        "function_name": "manualswap",
        "code": "function manualswap(address target) external { require(_msgSender() == _deployer); _isExcludedFromFee[target] = true; uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Deployer can exclude target from fees and manipulate swaps",
        "reason": "The deployer can use this function to exclude any address from fees and trigger token swaps manually, potentially leading to market manipulation or unfair advantages for certain addresses.",
        "file_name": "0x007d8eedc142d9e14ea3498471c5e884d6249a20.sol"
    }
]