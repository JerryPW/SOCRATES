[
    {
        "function_name": "function () payable beforeDeadline",
        "code": "function () payable beforeDeadline { tokenBalance = 4930089; uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; price = SafeMath.div(0.35 * 1 ether, dollar_exchange); if (amount >= 37.5 ether && amount < 83 ether) {price = SafeMath.div(SafeMath.mul(100, price), 110);} if (amount >= 87.5 ether && amount < 166 ether) {price = SafeMath.div(SafeMath.mul(100, price), 115);} if (amount >= 175 ether) {price = SafeMath.div(SafeMath.mul(100, price), 120);} tokenBalance = SafeMath.sub(tokenBalance, SafeMath.div(amount, price)); if (tokenBalance < 0 ) { revert(); } tokenReward.transfer(msg.sender, SafeMath.div(amount * 1 ether, price)); FundTransfer(msg.sender, amount, true); }",
        "vulnerability": "Token Balance Reset Vulnerability",
        "reason": "The function resets the tokenBalance to a fixed value of 4930089 every time the fallback function is called, which allows any user to repeatedly call the function and drain the contract of tokens. This is because tokenBalance does not properly track the remaining tokens after transfers, leading to potential inconsistencies and allowing an attacker to exploit this for profit.",
        "file_name": "0x30919c5c5c7727eea89b110d7258cbb36d541377.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline { if (beneficiary.send(amountRaised)) { FundTransfer(beneficiary, amountRaised, false); tokenReward.transfer(beneficiary, tokenReward.balanceOf(this)); tokenBalance = 0; } }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The use of `beneficiary.send(amountRaised)` can lead to a reentrancy attack. Since `send` only forwards a limited amount of gas, it may fail if not enough gas is available, and the control of execution could be transferred back to the sender. If the fallback function of the beneficiary address is able to re-enter the `safeWithdrawal` function before the `tokenBalance` is set to 0, it could lead to multiple withdrawals.",
        "file_name": "0x30919c5c5c7727eea89b110d7258cbb36d541377.sol"
    },
    {
        "function_name": "function () payable beforeDeadline",
        "code": "function () payable beforeDeadline { tokenBalance = 4930089; uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; price = SafeMath.div(0.35 * 1 ether, dollar_exchange); if (amount >= 37.5 ether && amount < 83 ether) {price = SafeMath.div(SafeMath.mul(100, price), 110);} if (amount >= 87.5 ether && amount < 166 ether) {price = SafeMath.div(SafeMath.mul(100, price), 115);} if (amount >= 175 ether) {price = SafeMath.div(SafeMath.mul(100, price), 120);} tokenBalance = SafeMath.sub(tokenBalance, SafeMath.div(amount, price)); if (tokenBalance < 0 ) { revert(); } tokenReward.transfer(msg.sender, SafeMath.div(amount * 1 ether, price)); FundTransfer(msg.sender, amount, true); }",
        "vulnerability": "Integer Overflow Vulnerability",
        "reason": "The function does not adequately handle potential overflows due to the arithmetic operations involving ether values and token price calculations. Specifically, `SafeMath.div(amount * 1 ether, price)` could result in an overflow if the `price` is set incorrectly or manipulated, leading to an incorrect number of tokens being transferred to the sender. Although SafeMath is used, the logic around price and amount calculations requires careful scrutiny to avoid overflows.",
        "file_name": "0x30919c5c5c7727eea89b110d7258cbb36d541377.sol"
    }
]