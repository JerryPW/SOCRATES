[
    {
        "function_name": "function ()",
        "code": "function () public payable { uint256 weiAmount = msg.value; require(weiAmount >= etherMinimum.mul(10 ** etherDecimals)); uint256 balance = token.balanceOf(address(this)); uint256 onsale = balance.sub(deposit); require(onsale > 0); uint256 tokenBought = weiAmount.mul(rate).div(10 ** decimalDiff); uint256 tokenDeposit = weiAmount.mul(depositRate).div(10 ** decimalDiff); uint256 tokenAmount = tokenBought.add(tokenDeposit); require(tokenAmount > 0); if (tokenAmount <= onsale) { assert(token.transfer(msg.sender, tokenBought)); } else { uint256 weiExpense = onsale.div(rate + depositRate); tokenBought = weiExpense.mul(rate); tokenDeposit = onsale.sub(tokenBought); assert(token.transfer(msg.sender, tokenBought)); msg.sender.transfer(weiAmount - weiExpense.mul(10 ** decimalDiff)); } deposit = deposit.add(tokenDeposit); onsale = token.balanceOf(address(this)).sub(deposit); owner.transfer(address(this).balance); }",
        "vulnerability": "Re-entrancy via fallback",
        "reason": "The fallback function is vulnerable to re-entrancy due to the lack of re-entrancy guard and the call to msg.sender.transfer, which allows an attacker to repeatedly call the fallback function and drain the contract's Ether balance.",
        "file_name": "0x967719548b8385be3c21ee96bdc57b9409b501cb.sol"
    },
    {
        "function_name": "withdrawEther",
        "code": "function withdrawEther() external onlyOwner { owner.transfer(address(this).balance); }",
        "vulnerability": "Potential loss of Ether",
        "reason": "The withdrawEther function transfers the entire balance of the contract to the owner without checking for re-entrancy or whether the contract has sufficient Ether. An attacker could exploit this by manipulating the contract's balance or using re-entrancy.",
        "file_name": "0x967719548b8385be3c21ee96bdc57b9409b501cb.sol"
    },
    {
        "function_name": "sendToken",
        "code": "function sendToken(address _receiver, uint256 _amount) external { require(msg.sender == wallet); require(_amount <= deposit); assert(token.transfer(_receiver, _amount)); deposit = deposit.sub(_amount); }",
        "vulnerability": "Unrestricted access to token reserves",
        "reason": "The sendToken function allows the wallet address to transfer tokens from the contract's deposit without any restrictions on how many times it can be called, potentially draining the entire deposit if the wallet address is compromised or malicious.",
        "file_name": "0x967719548b8385be3c21ee96bdc57b9409b501cb.sol"
    }
]