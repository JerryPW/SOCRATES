[
    {
        "function_name": "function ()",
        "code": "function () public payable { uint256 weiAmount = msg.value; require(weiAmount >= etherMinimum.mul(10 ** etherDecimals)); uint256 balance = token.balanceOf(address(this)); uint256 onsale = balance.sub(deposit); require(onsale > 0); uint256 tokenBought = weiAmount.mul(rate).div(10 ** decimalDiff); uint256 tokenDeposit = weiAmount.mul(depositRate).div(10 ** decimalDiff); uint256 tokenAmount = tokenBought.add(tokenDeposit); require(tokenAmount > 0); if (tokenAmount <= onsale) { assert(token.transfer(msg.sender, tokenBought)); } else { uint256 weiExpense = onsale.div(rate + depositRate); tokenBought = weiExpense.mul(rate); tokenDeposit = onsale.sub(tokenBought); assert(token.transfer(msg.sender, tokenBought)); msg.sender.transfer(weiAmount - weiExpense.mul(10 ** decimalDiff)); } deposit = deposit.add(tokenDeposit); onsale = token.balanceOf(address(this)).sub(deposit); owner.transfer(address(this).balance); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function directly transfers ether to msg.sender without using a withdrawal pattern. This can lead to a reentrancy attack where the fallback function of msg.sender calls back into the contract before the state changes are finalized, allowing the attacker to drain funds or manipulate the contract state.",
        "file_name": "0x967719548b8385be3c21ee96bdc57b9409b501cb.sol"
    },
    {
        "function_name": "rescueTokens",
        "code": "function rescueTokens(ERC20Basic _token) external onlyOwner { uint256 balance = _token.balanceOf(this); assert(_token.transfer(owner, balance)); }",
        "vulnerability": "Token stealing by owner",
        "reason": "The function allows the contract owner to transfer any ERC20 tokens held by the contract to themselves. This could be exploited if the owner is malicious or if the contract is compromised, leading to a loss of tokens for users who expect those tokens to be secure within the contract.",
        "file_name": "0x967719548b8385be3c21ee96bdc57b9409b501cb.sol"
    },
    {
        "function_name": "withdrawEther",
        "code": "function withdrawEther() external onlyOwner { owner.transfer(address(this).balance); }",
        "vulnerability": "Ether stealing by owner",
        "reason": "This function enables the contract owner to transfer all ether held in the contract to themselves. While this could be intended for maintenance purposes, it provides a straightforward way for a malicious or compromised owner to steal all ether from the contract, which may include user funds.",
        "file_name": "0x967719548b8385be3c21ee96bdc57b9409b501cb.sol"
    }
]