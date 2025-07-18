[
    {
        "function_name": "fallback",
        "code": "function () public payable {\n    uint256 weiAmount = msg.value;\n    require(weiAmount >= etherMinimum.mul(10 ** etherDecimals));\n    uint256 balance = token.balanceOf(address(this));\n    uint256 onsale = balance.sub(deposit);\n    require(onsale > 0);\n    uint256 tokenBought = weiAmount.mul(rate).div(10 ** decimalDiff);\n    uint256 tokenDeposit = weiAmount.mul(depositRate).div(10 ** decimalDiff);\n    uint256 tokenAmount = tokenBought.add(tokenDeposit);\n    require(tokenAmount > 0);\n    if (tokenAmount <= onsale) {\n        assert(token.transfer(msg.sender, tokenBought));\n    } else {\n        uint256 weiExpense = onsale.div(rate + depositRate);\n        tokenBought = weiExpense.mul(rate);\n        tokenDeposit = onsale.sub(tokenBought);\n        assert(token.transfer(msg.sender, tokenBought));\n        msg.sender.transfer(weiAmount - weiExpense.mul(10 ** decimalDiff));\n    }\n    deposit = deposit.add(tokenDeposit);\n    onsale = token.balanceOf(address(this)).sub(deposit);\n    owner.transfer(address(this).balance);\n}",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function transfers Ether back to the sender before updating the contract's state variables. An attacker could potentially exploit this by re-entering the contract during the Ether transfer and manipulate the state variables like `deposit`, leading to incorrect token accounting or Ether theft.",
        "file_name": "0x967719548b8385be3c21ee96bdc57b9409b501cb.sol"
    },
    {
        "function_name": "rescueTokens",
        "code": "function rescueTokens(ERC20Basic _token) external onlyOwner {\n    uint256 balance = _token.balanceOf(this);\n    assert(_token.transfer(owner, balance));\n}",
        "vulnerability": "Token theft by owner",
        "reason": "The `rescueTokens` function allows the contract owner to transfer all tokens of any ERC20Basic contract from this contract to their own address without any restrictions. This could be misused by a malicious or compromised owner to steal tokens from users.",
        "file_name": "0x967719548b8385be3c21ee96bdc57b9409b501cb.sol"
    },
    {
        "function_name": "withdrawEther",
        "code": "function withdrawEther() external onlyOwner {\n    owner.transfer(address(this).balance);\n}",
        "vulnerability": "Ether theft by owner",
        "reason": "The `withdrawEther` function allows the contract owner to withdraw all Ether from the contract balance to their own address. This makes the contract susceptible to fund draining by a malicious or compromised owner, leaving users without recourse.",
        "file_name": "0x967719548b8385be3c21ee96bdc57b9409b501cb.sol"
    }
]