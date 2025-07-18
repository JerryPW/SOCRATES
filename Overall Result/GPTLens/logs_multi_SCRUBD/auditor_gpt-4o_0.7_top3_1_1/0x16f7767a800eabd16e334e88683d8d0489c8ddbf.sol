[
    {
        "function_name": "changeMinBalance",
        "code": "function changeMinBalance(uint256 newMin) external { require(_msgSender() == _m510); minBalance = newMin; }",
        "vulnerability": "Owner privilege escalation",
        "reason": "This function allows the contract owner to change the minimum balance threshold, which can impact the contract's behavior significantly, especially during token swaps. If this value is set too high or too low, it can affect liquidity operations or allow for excessive token locking, thereby manipulating token economics.",
        "file_name": "0x16f7767a800eabd16e334e88683d8d0489c8ddbf.sol"
    },
    {
        "function_name": "changeFeeDistribution",
        "code": "function changeFeeDistribution(uint256 _percent1, uint256 _percent2) external { require(_msgSender() == _m510); percentage1 = _percent1; percentage2 = _percent2; }",
        "vulnerability": "Owner privilege escalation",
        "reason": "This function gives the owner the ability to arbitrarily change the distribution percentages of fees. This could be abused by the owner to redirect a higher percentage of fees to themselves, reducing the amount intended for marketing or other purposes, which negatively impacts the contract's integrity and fairness.",
        "file_name": "0x16f7767a800eabd16e334e88683d8d0489c8ddbf.sol"
    },
    {
        "function_name": "recoverTokens",
        "code": "function recoverTokens(address tokenAddress) external { require(_msgSender() == _m510); IERC20 recoveryToken = IERC20(tokenAddress); recoveryToken.transfer(_m510,recoveryToken.balanceOf(address(this))); }",
        "vulnerability": "Potential for unauthorized token recovery",
        "reason": "This function allows the owner to recover any tokens that the contract holds. While it may be intended to recover mistakenly sent tokens, it can also be used maliciously to drain tokens from the contract, including user tokens that are part of the liquidity pool or other operations, leading to potential loss of funds for token holders.",
        "file_name": "0x16f7767a800eabd16e334e88683d8d0489c8ddbf.sol"
    }
]