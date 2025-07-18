[
    {
        "function_name": "function() payable",
        "code": "function () payable beforeDeadline { tokenBalance = 4930089; uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; price = SafeMath.div(0.35 * 1 ether, dollar_exchange); if (amount >= 37.5 ether && amount < 83 ether) {price = SafeMath.div(SafeMath.mul(100, price), 110);} if (amount >= 87.5 ether && amount < 166 ether) {price = SafeMath.div(SafeMath.mul(100, price), 115);} if (amount >= 175 ether) {price = SafeMath.div(SafeMath.mul(100, price), 120);} tokenBalance = SafeMath.sub(tokenBalance, SafeMath.div(amount, price)); if (tokenBalance < 0 ) { revert(); } tokenReward.transfer(msg.sender, SafeMath.div(amount * 1 ether, price)); FundTransfer(msg.sender, amount, true); }",
        "vulnerability": "Hardcoded Token Balance",
        "reason": "The token balance is hardcoded at the beginning of the function, which means it is reset every time the fallback function is called. This allows an attacker to drain tokens repeatedly by exploiting the reset balance, which can lead to a loss of funds for the project.",
        "file_name": "0x30919c5c5c7727eea89b110d7258cbb36d541377.sol"
    },
    {
        "function_name": "function safeWithdrawal()",
        "code": "function safeWithdrawal() afterDeadline { if (beneficiary.send(amountRaised)) { FundTransfer(beneficiary, amountRaised, false); tokenReward.transfer(beneficiary, tokenReward.balanceOf(this)); tokenBalance = 0; } }",
        "vulnerability": "Unsafe Ether Transfer",
        "reason": "The use of 'send' for transferring Ether is unsafe as it only forwards 2300 gas, which might not be sufficient for the beneficiary's fallback function, potentially causing the transfer to fail. If the transfer fails, the contract does not handle this failure properly, which can lead to funds being trapped in the contract.",
        "file_name": "0x30919c5c5c7727eea89b110d7258cbb36d541377.sol"
    },
    {
        "function_name": "function safeWithdrawal()",
        "code": "function safeWithdrawal() afterDeadline { if (beneficiary.send(amountRaised)) { FundTransfer(beneficiary, amountRaised, false); tokenReward.transfer(beneficiary, tokenReward.balanceOf(this)); tokenBalance = 0; } }",
        "vulnerability": "Lack of Access Control",
        "reason": "The 'safeWithdrawal' function can be called by anyone after the deadline, allowing any user to trigger the transfer of all raised funds and remaining tokens to the beneficiary. This could be exploited by an attacker to block the withdrawal process or cause denial-of-service by repeatedly calling it.",
        "file_name": "0x30919c5c5c7727eea89b110d7258cbb36d541377.sol"
    }
]