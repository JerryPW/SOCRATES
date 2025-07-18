[
    {
        "function_name": "Crowdsale",
        "code": "function Crowdsale() { beneficiary = 0xD83A4537f917feFf68088eAB619dC6C529A55ad4; start_time = now; deadline = start_time + 2 * 1 days; dollar_exchange = 280; tokenReward = token(0x2ca8e1fbcde534c8c71d8f39864395c2ed76fb0e); }",
        "vulnerability": "Fixed beneficiary address",
        "reason": "The beneficiary address is hardcoded, which poses a risk if this address is compromised or incorrect. It also lacks flexibility for future changes or upgrades.",
        "file_name": "0x30919c5c5c7727eea89b110d7258cbb36d541377.sol"
    },
    {
        "function_name": "function ()",
        "code": "function () payable beforeDeadline { tokenBalance = 4930089; uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; price = SafeMath.div(0.35 * 1 ether, dollar_exchange); if (amount >= 37.5 ether && amount < 83 ether) {price = SafeMath.div(SafeMath.mul(100, price), 110);} if (amount >= 87.5 ether && amount < 166 ether) {price = SafeMath.div(SafeMath.mul(100, price), 115);} if (amount >= 175 ether) {price = SafeMath.div(SafeMath.mul(100, price), 120);} tokenBalance = SafeMath.sub(tokenBalance, SafeMath.div(amount, price)); if (tokenBalance < 0 ) { revert(); } tokenReward.transfer(msg.sender, SafeMath.div(amount * 1 ether, price)); FundTransfer(msg.sender, amount, true); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The contract does not use the checks-effects-interactions pattern, which leaves it susceptible to reentrancy attacks. An attacker could exploit this by recursively calling the fallback function to drain funds.",
        "file_name": "0x30919c5c5c7727eea89b110d7258cbb36d541377.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline { if (beneficiary.send(amountRaised)) { FundTransfer(beneficiary, amountRaised, false); tokenReward.transfer(beneficiary, tokenReward.balanceOf(this)); tokenBalance = 0; } }",
        "vulnerability": "Unsafe use of send()",
        "reason": "The use of send() is unsafe because it forwards only 2300 gas, which can cause the transaction to fail if the recipient requires more gas. This can result in funds being stuck in the contract.",
        "file_name": "0x30919c5c5c7727eea89b110d7258cbb36d541377.sol"
    }
]