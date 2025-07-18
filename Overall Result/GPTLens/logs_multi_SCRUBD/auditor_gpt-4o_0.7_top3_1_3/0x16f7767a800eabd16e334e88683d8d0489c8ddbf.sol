[
    {
        "function_name": "changeMinBalance",
        "code": "function changeMinBalance(uint256 newMin) external { require(_msgSender() == _m510); minBalance = newMin; }",
        "vulnerability": "Centralized control over minBalance",
        "reason": "The `changeMinBalance` function allows the `_m510` address to change the `minBalance`, which determines when the contract attempts to swap tokens for ETH. This means that the `_m510` address has significant control over when swaps occur, potentially allowing them to manipulate token prices or cause unexpected behavior in token transfers.",
        "file_name": "0x16f7767a800eabd16e334e88683d8d0489c8ddbf.sol"
    },
    {
        "function_name": "changeFeeDistribution",
        "code": "function changeFeeDistribution(uint256 _percent1, uint256 _percent2) external { require(_msgSender() == _m510); percentage1 = _percent1; percentage2 = _percent2; }",
        "vulnerability": "Centralized fee distribution control",
        "reason": "The `changeFeeDistribution` function enables the `_m510` address to adjust the fee distribution percentages, `percentage1` and `percentage2`, at any time. This could be exploited for financial gain by redirecting fees to addresses controlled by the attacker or altering the fee structure without the consent of token holders.",
        "file_name": "0x16f7767a800eabd16e334e88683d8d0489c8ddbf.sol"
    },
    {
        "function_name": "recoverTokens",
        "code": "function recoverTokens(address tokenAddress) external { require(_msgSender() == _m510); IERC20 recoveryToken = IERC20(tokenAddress); recoveryToken.transfer(_m510,recoveryToken.balanceOf(address(this))); }",
        "vulnerability": "Token recovery by owner",
        "reason": "The `recoverTokens` function allows the `_m510` address to transfer any tokens held by the contract to themselves. This poses a risk of loss to the holders if the contract holds tokens intended for other purposes, as it allows the owner to drain these tokens arbitrarily.",
        "file_name": "0x16f7767a800eabd16e334e88683d8d0489c8ddbf.sol"
    }
]