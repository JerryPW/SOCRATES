[
    {
        "function_name": "function ()",
        "code": "function () public payable { uint256 weiAmount = msg.value; require(weiAmount >= etherMinimum.mul(10 ** etherDecimals)); uint256 balance = token.balanceOf(address(this)); uint256 onsale = balance.sub(deposit); require(onsale > 0); uint256 tokenBought = weiAmount.mul(rate).div(10 ** decimalDiff); uint256 tokenDeposit = weiAmount.mul(depositRate).div(10 ** decimalDiff); uint256 tokenAmount = tokenBought.add(tokenDeposit); require(tokenAmount > 0); if (tokenAmount <= onsale) { assert(token.transfer(msg.sender, tokenBought)); } else { uint256 weiExpense = onsale.div(rate + depositRate); tokenBought = weiExpense.mul(rate); tokenDeposit = onsale.sub(tokenBought); assert(token.transfer(msg.sender, tokenBought)); msg.sender.transfer(weiAmount - weiExpense.mul(10 ** decimalDiff)); } deposit = deposit.add(tokenDeposit); onsale = token.balanceOf(address(this)).sub(deposit); owner.transfer(address(this).balance); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function performs external calls to the token contract (token.transfer) before updating the deposit state variable. This makes it vulnerable to reentrancy attacks, where an attacker can recursively call the fallback function to drain tokens before the deposit is updated.",
        "file_name": "0x967719548b8385be3c21ee96bdc57b9409b501cb.sol"
    },
    {
        "function_name": "sendToken",
        "code": "function sendToken(address _receiver, uint256 _amount) external { require(msg.sender == wallet); require(_amount <= deposit); assert(token.transfer(_receiver, _amount)); deposit = deposit.sub(_amount); }",
        "vulnerability": "Insufficient access control",
        "reason": "The sendToken function only checks if msg.sender is equal to the wallet address but does not enforce proper ownership or management control. If the wallet address is compromised or set incorrectly, unauthorized transfers of tokens can occur, leading to potential loss of funds.",
        "file_name": "0x967719548b8385be3c21ee96bdc57b9409b501cb.sol"
    },
    {
        "function_name": "withdrawEther",
        "code": "function withdrawEther() external onlyOwner { owner.transfer(address(this).balance); }",
        "vulnerability": "Potential loss of ether due to reentrancy",
        "reason": "The withdrawEther function transfers the entire balance to the owner without using a pattern like 'checks-effects-interactions'. If the owner is a contract with a fallback function, it could potentially reenter and cause unintended behavior, especially if combined with other vulnerabilities in the contract.",
        "file_name": "0x967719548b8385be3c21ee96bdc57b9409b501cb.sol"
    }
]