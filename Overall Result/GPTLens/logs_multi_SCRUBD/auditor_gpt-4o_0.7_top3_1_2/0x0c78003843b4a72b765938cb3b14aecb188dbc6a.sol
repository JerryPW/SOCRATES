[
    {
        "function_name": "oraclize_setNetwork",
        "code": "function oraclize_setNetwork(uint8 networkID) internal returns(bool){ return oraclize_setNetwork(); networkID; }",
        "vulnerability": "unused parameter",
        "reason": "The function oraclize_setNetwork takes networkID as a parameter but does not use it, which can lead to logical errors if the function is expected to use this parameter.",
        "file_name": "0x0c78003843b4a72b765938cb3b14aecb188dbc6a.sol"
    },
    {
        "function_name": "manualSale",
        "code": "function manualSale(address _beneficiary, uint256 _tokens) onlyOwner external { require(_beneficiary != address(0)); require(tokensSold.add(_tokens) <= cap); uint256 weiAmount = _tokens.mul(tokenPriceInWei); _processPurchase(_beneficiary, _tokens); emit TokenPurchase(msg.sender, _beneficiary, weiAmount, _tokens, 0); _updateState(weiAmount, _tokens); }",
        "vulnerability": "lack of KYC check",
        "reason": "The function manualSale allows the owner to distribute tokens manually without checking if the beneficiary has passed KYC. This could lead to regulatory issues or distribution to unauthorized users.",
        "file_name": "0x0c78003843b4a72b765938cb3b14aecb188dbc6a.sol"
    },
    {
        "function_name": "withdrawBalance",
        "code": "function withdrawBalance(address _to) onlyOwner external { require(_to != address(0)); require(address(this).balance > 0); oraclizeBalance = 0; _to.transfer(address(this).balance); }",
        "vulnerability": "incorrect reset of oraclizeBalance",
        "reason": "The oraclizeBalance is reset to 0 before transferring the balance, which can lead to inconsistencies if the transfer fails. The reset should happen after the transfer to ensure the balance reflects the actual state.",
        "file_name": "0x0c78003843b4a72b765938cb3b14aecb188dbc6a.sol"
    }
]