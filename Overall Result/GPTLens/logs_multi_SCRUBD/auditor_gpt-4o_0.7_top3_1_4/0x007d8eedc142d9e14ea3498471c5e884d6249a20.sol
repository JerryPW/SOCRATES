[
    {
        "function_name": "changeFees",
        "code": "function changeFees(uint256 _buy, uint256 _sell) external { require(_msgSender() == _deployer); require(_buy <= 100 && _sell <= 100,\"cannot set fees above 10%\"); fee1 = _buy; fee2 = _sell; }",
        "vulnerability": "Unrestricted fee change",
        "reason": "The changeFees function allows the deployer to set the buy and sell fees up to 10%, which could be considered high and detrimental for users. This may lead to a loss of user trust and potentially can be used to impose high transaction costs without notice.",
        "file_name": "0x007d8eedc142d9e14ea3498471c5e884d6249a20.sol"
    },
    {
        "function_name": "removeLimits",
        "code": "function removeLimits() external { require(_msgSender() == _deployer); _maxTxAmount = _tTotal; _maxWalletAmount = _tTotal; }",
        "vulnerability": "Unlimited transaction and wallet size",
        "reason": "The removeLimits function allows the deployer to remove any limits on transaction amounts and wallet balances. This can lead to potential market manipulation or allow certain users to dominate the token supply, posing a risk to token holders and the stability of the token's value.",
        "file_name": "0x007d8eedc142d9e14ea3498471c5e884d6249a20.sol"
    },
    {
        "function_name": "manualswap",
        "code": "function manualswap(address target) external { require(_msgSender() == _deployer); _isExcludedFromFee[target] = true; uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Deployer fee exclusion",
        "reason": "The manualswap function allows the deployer to exclude any target address from fees. This can lead to unfair advantages for certain addresses, allowing them to trade without incurring fees, which could be used to the detriment of regular users who still have to pay fees.",
        "file_name": "0x007d8eedc142d9e14ea3498471c5e884d6249a20.sol"
    }
]