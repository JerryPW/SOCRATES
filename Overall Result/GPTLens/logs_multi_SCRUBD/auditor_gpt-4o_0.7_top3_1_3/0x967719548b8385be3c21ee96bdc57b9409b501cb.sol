[
    {
        "function_name": "function ()",
        "code": "function () public payable { uint256 weiAmount = msg.value; require(weiAmount >= etherMinimum.mul(10 ** etherDecimals)); uint256 balance = token.balanceOf(address(this)); uint256 onsale = balance.sub(deposit); require(onsale > 0); uint256 tokenBought = weiAmount.mul(rate).div(10 ** decimalDiff); uint256 tokenDeposit = weiAmount.mul(depositRate).div(10 ** decimalDiff); uint256 tokenAmount = tokenBought.add(tokenDeposit); require(tokenAmount > 0); if (tokenAmount <= onsale) { assert(token.transfer(msg.sender, tokenBought)); } else { uint256 weiExpense = onsale.div(rate + depositRate); tokenBought = weiExpense.mul(rate); tokenDeposit = onsale.sub(tokenBought); assert(token.transfer(msg.sender, tokenBought)); msg.sender.transfer(weiAmount - weiExpense.mul(10 ** decimalDiff)); } deposit = deposit.add(tokenDeposit); onsale = token.balanceOf(address(this)).sub(deposit); owner.transfer(address(this).balance); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function includes a call to `msg.sender.transfer`, which is a potential reentrancy risk. If `token.transfer` fails or is exploited, an attacker can re-enter this function, leading to inconsistent state changes or draining of funds.",
        "file_name": "0x967719548b8385be3c21ee96bdc57b9409b501cb.sol"
    },
    {
        "function_name": "withdrawEther",
        "code": "function withdrawEther() external onlyOwner { owner.transfer(address(this).balance); }",
        "vulnerability": "Lack of zero-address check",
        "reason": "The `withdrawEther` function transfers the entire balance to the owner without checking if the owner address is a legitimate address. If the owner is set to address zero, funds could be irretrievably lost.",
        "file_name": "0x967719548b8385be3c21ee96bdc57b9409b501cb.sol"
    },
    {
        "function_name": "sendToken",
        "code": "function sendToken(address _receiver, uint256 _amount) external { require(msg.sender == wallet); require(_amount <= deposit); assert(token.transfer(_receiver, _amount)); deposit = deposit.sub(_amount); }",
        "vulnerability": "Improper access control",
        "reason": "The `sendToken` function relies on the `wallet` address for access control, which can be changed by the owner. If the `wallet` address is compromised or set incorrectly, an unauthorized entity could call this function and transfer tokens, leading to a loss of funds.",
        "file_name": "0x967719548b8385be3c21ee96bdc57b9409b501cb.sol"
    }
]