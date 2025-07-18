[
    {
        "function_name": "Crowdsale",
        "code": "function Crowdsale() { beneficiary = 0xD83A4537f917feFf68088eAB619dC6C529A55ad4; start_time = now; deadline = start_time + 2 * 1 days; dollar_exchange = 280; tokenReward = token(0x2ca8e1fbcde534c8c71d8f39864395c2ed76fb0e); }",
        "vulnerability": "Hardcoded Beneficiary Address",
        "reason": "The beneficiary address is hardcoded in the constructor, making it inflexible. If the address needs to be changed, the entire contract would need to be redeployed, which is inefficient and costly.",
        "file_name": "0x30919c5c5c7727eea89b110d7258cbb36d541377.sol"
    },
    {
        "function_name": "function () payable",
        "code": "function () payable beforeDeadline { tokenBalance = 4930089; uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; price = SafeMath.div(0.35 * 1 ether, dollar_exchange); if (amount >= 37.5 ether && amount < 83 ether) {price = SafeMath.div(SafeMath.mul(100, price), 110);} if (amount >= 87.5 ether && amount < 166 ether) {price = SafeMath.div(SafeMath.mul(100, price), 115);} if (amount >= 175 ether) {price = SafeMath.div(SafeMath.mul(100, price), 120);} tokenBalance = SafeMath.sub(tokenBalance, SafeMath.div(amount, price)); if (tokenBalance < 0 ) { revert(); } tokenReward.transfer(msg.sender, SafeMath.div(amount * 1 ether, price)); FundTransfer(msg.sender, amount, true); }",
        "vulnerability": "Token Balance Reset and Manipulation",
        "reason": "The tokenBalance is reset to a fixed number every time the fallback function is called, which allows an attacker to drain tokens by repeatedly calling the function. Moreover, this value is not being properly initialized in a secure manner, allowing the token balance to be manipulated.",
        "file_name": "0x30919c5c5c7727eea89b110d7258cbb36d541377.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline { if (beneficiary.send(amountRaised)) { FundTransfer(beneficiary, amountRaised, false); tokenReward.transfer(beneficiary, tokenReward.balanceOf(this)); tokenBalance = 0; } }",
        "vulnerability": "Unsafe Ether Transfer",
        "reason": "The use of beneficiary.send(amountRaised) transfers ether with a gas limit of 2300, which may fail if the beneficiary address is a contract with a fallback function that requires more gas. This could lead to a denial of service for the withdrawal function and can lock funds in the contract.",
        "file_name": "0x30919c5c5c7727eea89b110d7258cbb36d541377.sol"
    }
]