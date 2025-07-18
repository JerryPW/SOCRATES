[
    {
        "function_name": "changeMinBalance",
        "code": "function changeMinBalance(uint256 newMin) external { require(_msgSender() == _m510); minBalance = newMin; }",
        "vulnerability": "Centralization risk via privileged access",
        "reason": "The function allows the account `_m510` to change the `minBalance` value. This centralized control could be misused by the privileged account to manipulate the minimum balance requirement, potentially resulting in unexpected behavior or hindering the contract's operation for other users.",
        "file_name": "0x16f7767a800eabd16e334e88683d8d0489c8ddbf.sol"
    },
    {
        "function_name": "changeFeeDistribution",
        "code": "function changeFeeDistribution(uint256 _percent1, uint256 _percent2) external { require(_msgSender() == _m510); percentage1 = _percent1; percentage2 = _percent2; }",
        "vulnerability": "Centralization risk via fee manipulation",
        "reason": "This function allows the privileged `_m510` account to modify the fee distribution percentages between `_m510` and `_marketingWallet`. An attacker gaining control of `_m510` could redirect most or all fees to themselves, exploiting the contract for financial gain at the expense of other users.",
        "file_name": "0x16f7767a800eabd16e334e88683d8d0489c8ddbf.sol"
    },
    {
        "function_name": "recoverTokens",
        "code": "function recoverTokens(address tokenAddress) external { require(_msgSender() == _m510); IERC20 recoveryToken = IERC20(tokenAddress); recoveryToken.transfer(_m510,recoveryToken.balanceOf(address(this))); }",
        "vulnerability": "Token recovery by privileged account",
        "reason": "This function allows the `_m510` account to transfer any ERC20 tokens held by the contract to themselves. This presents a significant centralization risk as it could be exploited to drain tokens from the contract, especially if `_m510` is compromised or behaves maliciously.",
        "file_name": "0x16f7767a800eabd16e334e88683d8d0489c8ddbf.sol"
    }
]