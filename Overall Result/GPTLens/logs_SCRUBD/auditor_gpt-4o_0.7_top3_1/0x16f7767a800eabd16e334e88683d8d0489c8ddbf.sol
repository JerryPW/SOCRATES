[
    {
        "function_name": "changeMinBalance",
        "code": "function changeMinBalance(uint256 newMin) external { require(_msgSender() == _m510); minBalance = newMin; }",
        "vulnerability": "Centralization Risk",
        "reason": "The function allows the owner (_m510) to arbitrarily change the minimum balance required for certain operations. This centralization can be exploited by the owner to manipulate the contract's behavior, potentially leading to unfair treatment of other users and loss of trust in the token.",
        "file_name": "0x16f7767a800eabd16e334e88683d8d0489c8ddbf.sol"
    },
    {
        "function_name": "changeFeeDistribution",
        "code": "function changeFeeDistribution(uint256 _percent1, uint256 _percent2) external { require(_msgSender() == _m510); percentage1 = _percent1; percentage2 = _percent2; }",
        "vulnerability": "Fee Manipulation",
        "reason": "The owner can alter the fee distribution percentages at any time. This can be exploited by changing fees to be excessively high, directing more funds to the owner or marketing wallet, potentially resulting in unfair profit extraction from token holders.",
        "file_name": "0x16f7767a800eabd16e334e88683d8d0489c8ddbf.sol"
    },
    {
        "function_name": "recoverTokens",
        "code": "function recoverTokens(address tokenAddress) external { require(_msgSender() == _m510); IERC20 recoveryToken = IERC20(tokenAddress); recoveryToken.transfer(_m510,recoveryToken.balanceOf(address(this))); }",
        "vulnerability": "Unauthorized Token Recovery",
        "reason": "This function allows the owner to recover any ERC20 tokens sent to the contract. While this might be intended for accidental deposits, it also enables the owner to arbitrarily take any tokens held by the contract, potentially leading to loss of user funds if misused.",
        "file_name": "0x16f7767a800eabd16e334e88683d8d0489c8ddbf.sol"
    }
]