[
    {
        "function_name": "enableTrading",
        "code": "function enableTrading() external onlyOwner { tradingLive = true; }",
        "vulnerability": "Trading control by owner",
        "reason": "The trading can only be enabled by the owner through the `enableTrading` function. This centralization means the owner could potentially lock or unlock trading at will, which could be exploited to manipulate market conditions or exit scam.",
        "file_name": "0x0654b7f747c9ee9f5fb5eba443e9fe64f1fa77ef.sol"
    },
    {
        "function_name": "transferETH",
        "code": "function transferETH() external onlyOwner { payable(msg.sender).call{value: address(this).balance}(\"\"); }",
        "vulnerability": "Owner can drain contract ETH balance",
        "reason": "This function allows the owner to transfer the entire ETH balance of the contract to themselves. This centralizes control and can be misused by a malicious owner to drain funds, leading to a potential rug pull.",
        "file_name": "0x0654b7f747c9ee9f5fb5eba443e9fe64f1fa77ef.sol"
    },
    {
        "function_name": "changeFees",
        "code": "function changeFees(uint256 _buyFeeTeam, uint256 _buyFeeInsurance, uint256 _buyFeeLiqExchange, uint256 _buyFeeLiqToken, uint256 _sellFeeTeam, uint256 _sellFeeInsurance, uint256 _sellFeeLiqExchange, uint256 _sellFeeLiqToken) external onlyOwner { buyFeeTeam = _buyFeeTeam; buyFeeInsurance = _buyFeeInsurance; buyFeeLiqExchange = _buyFeeLiqExchange; buyFeeLiqToken = _buyFeeLiqToken; buyFee = _buyFeeTeam + _buyFeeInsurance + _buyFeeLiqExchange + _buyFeeLiqToken; sellFeeTeam = _sellFeeTeam; sellFeeInsurance = _sellFeeInsurance; sellFeeLiqExchange = _sellFeeLiqExchange; sellFeeLiqToken = _sellFeeLiqToken; sellFee = _sellFeeTeam + _sellFeeInsurance + _sellFeeLiqExchange + _sellFeeLiqToken; }",
        "vulnerability": "Owner can arbitrarily change fees",
        "reason": "The owner has the ability to change all buy and sell fees at any time. By setting extremely high fees, the owner could effectively prevent users from selling tokens or diminish their holdings significantly upon transactions, which could be used maliciously to control trading dynamics or execute a financial attack.",
        "file_name": "0x0654b7f747c9ee9f5fb5eba443e9fe64f1fa77ef.sol"
    }
]