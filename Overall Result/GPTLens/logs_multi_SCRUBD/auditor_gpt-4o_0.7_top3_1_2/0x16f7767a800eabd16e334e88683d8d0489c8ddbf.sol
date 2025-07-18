[
    {
        "function_name": "changeMinBalance",
        "code": "function changeMinBalance(uint256 newMin) external { require(_msgSender() == _m510); minBalance = newMin; }",
        "vulnerability": "Lack of Access Control",
        "reason": "The `changeMinBalance` function allows the `_m510` address to change the `minBalance` variable. If the `_m510` private key is compromised, an attacker could set `minBalance` to an arbitrary value, potentially causing unwanted behavior in functions relying on this variable.",
        "file_name": "0x16f7767a800eabd16e334e88683d8d0489c8ddbf.sol"
    },
    {
        "function_name": "changeFeeDistribution",
        "code": "function changeFeeDistribution(uint256 _percent1, uint256 _percent2) external { require(_msgSender() == _m510); percentage1 = _percent1; percentage2 = _percent2; }",
        "vulnerability": "Unrestricted Fee Modification",
        "reason": "The `changeFeeDistribution` function allows the `_m510` address to arbitrarily change the fee distribution percentages between `percentage1` and `percentage2`. If the `_m510` private key is compromised or misused, it could lead to unfair distribution of collected fees, potentially diverting all fees to one address.",
        "file_name": "0x16f7767a800eabd16e334e88683d8d0489c8ddbf.sol"
    },
    {
        "function_name": "recoverTokens",
        "code": "function recoverTokens(address tokenAddress) external { require(_msgSender() == _m510); IERC20 recoveryToken = IERC20(tokenAddress); recoveryToken.transfer(_m510,recoveryToken.balanceOf(address(this))); }",
        "vulnerability": "Token Recovery Exploit",
        "reason": "The `recoverTokens` function allows the `_m510` address to transfer all tokens of any ERC20 contract held by this contract to the `_m510` address. If the `_m510` private key is compromised, an attacker could drain all tokens from the contract, causing a significant loss of assets.",
        "file_name": "0x16f7767a800eabd16e334e88683d8d0489c8ddbf.sol"
    }
]