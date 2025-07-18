[
    {
        "function_name": "transferETH",
        "code": "function transferETH() external onlyOwner { payable(msg.sender).call{value: address(this).balance}(\"\"); }",
        "vulnerability": "Owner can drain all ETH balance",
        "reason": "This function allows the contract owner to transfer all ETH held by the contract to their own address, potentially draining funds that are meant to be used for other purposes such as liquidity or fees. If the contract unexpectedly accumulates significant ETH, this function could be misused by a malicious owner to withdraw all ETH, leaving the contract unable to fulfill its expected operations.",
        "file_name": "0x0654b7f747c9ee9f5fb5eba443e9fe64f1fa77ef.sol"
    },
    {
        "function_name": "transferERC",
        "code": "function transferERC(address _erc20Address) external onlyOwner { require(_erc20Address != address(this), \"Can't withdraw SAFX\"); IERC20 _erc20 = IERC20(_erc20Address); _erc20.transfer(msg.sender, _erc20.balanceOf(address(this))); }",
        "vulnerability": "Owner can withdraw any ERC20 token",
        "reason": "This function provides the contract owner with the ability to transfer any ERC20 tokens (except the SAFX token itself) from the contract to the owner's address. This could lead to exploitation, especially if the contract holds valuable tokens as part of its operations. An attacker who gains control of the owner account could drain all ERC20 tokens, disrupting the contract's intended functionality.",
        "file_name": "0x0654b7f747c9ee9f5fb5eba443e9fe64f1fa77ef.sol"
    },
    {
        "function_name": "changeFees",
        "code": "function changeFees(uint256 _buyFeeTeam, uint256 _buyFeeInsurance, uint256 _buyFeeLiqExchange, uint256 _buyFeeLiqToken, uint256 _sellFeeTeam, uint256 _sellFeeInsurance, uint256 _sellFeeLiqExchange, uint256 _sellFeeLiqToken) external onlyOwner { buyFeeTeam = _buyFeeTeam; buyFeeInsurance = _buyFeeInsurance; buyFeeLiqExchange = _buyFeeLiqExchange; buyFeeLiqToken = _buyFeeLiqToken; buyFee = _buyFeeTeam + _buyFeeInsurance + _buyFeeLiqExchange + _buyFeeLiqToken; sellFeeTeam = _sellFeeTeam; sellFeeInsurance = _sellFeeInsurance; sellFeeLiqExchange = _sellFeeLiqExchange; sellFeeLiqToken = _sellFeeLiqToken; sellFee = _sellFeeTeam + _sellFeeInsurance + _sellFeeLiqExchange + _sellFeeLiqToken; }",
        "vulnerability": "Owner can set excessively high fees",
        "reason": "This function allows the contract owner to change the fee percentages for buying and selling. An owner with malicious intent could set these fees to extremely high values, effectively blocking users from trading or unfairly taxing them. This not only poses a risk to user funds but also undermines trust in the token's economic stability.",
        "file_name": "0x0654b7f747c9ee9f5fb5eba443e9fe64f1fa77ef.sol"
    }
]