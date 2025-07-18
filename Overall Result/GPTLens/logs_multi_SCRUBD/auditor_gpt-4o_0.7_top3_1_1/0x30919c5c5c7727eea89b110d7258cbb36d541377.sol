[
    {
        "function_name": "Crowdsale",
        "code": "function Crowdsale() { beneficiary = 0xD83A4537f917feFf68088eAB619dC6C529A55ad4; start_time = now; deadline = start_time + 2 * 1 days; dollar_exchange = 280; tokenReward = token(0x2ca8e1fbcde534c8c71d8f39864395c2ed76fb0e); }",
        "vulnerability": "Hardcoded Beneficiary Address",
        "reason": "The beneficiary address is hardcoded in the constructor. This presents a risk as it cannot be changed once the contract is deployed. If the private key to this address is compromised or if the address is incorrect, the funds could be lost or stolen. It also limits the flexibility to change the beneficiary if needed.",
        "file_name": "0x30919c5c5c7727eea89b110d7258cbb36d541377.sol"
    },
    {
        "function_name": "function() payable",
        "code": "function () payable beforeDeadline { tokenBalance = 4930089; uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; price = SafeMath.div(0.35 * 1 ether, dollar_exchange); if (amount >= 37.5 ether && amount < 83 ether) {price = SafeMath.div(SafeMath.mul(100, price), 110);} if (amount >= 87.5 ether && amount < 166 ether) {price = SafeMath.div(SafeMath.mul(100, price), 115);} if (amount >= 175 ether) {price = SafeMath.div(SafeMath.mul(100, price), 120);} tokenBalance = SafeMath.sub(tokenBalance, SafeMath.div(amount, price)); if (tokenBalance < 0 ) { revert(); } tokenReward.transfer(msg.sender, SafeMath.div(amount * 1 ether, price)); FundTransfer(msg.sender, amount, true); }",
        "vulnerability": "Reentrant attack vulnerability",
        "reason": "The fallback function is vulnerable to reentrancy attacks since it first updates the state variables and then performs an external call to transfer tokens. An attacker could exploit this by recursively calling this function, potentially draining the contract of its tokens before the state is properly updated.",
        "file_name": "0x30919c5c5c7727eea89b110d7258cbb36d541377.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline { if (beneficiary.send(amountRaised)) { FundTransfer(beneficiary, amountRaised, false); tokenReward.transfer(beneficiary, tokenReward.balanceOf(this)); tokenBalance = 0; } }",
        "vulnerability": "Unsafe Ether Transfer",
        "reason": "The use of the 'send' function is unsafe as it only forwards 2300 gas and doesn't throw an error if the transfer fails. This could lead to loss of funds if the transfer fails for any reason. It is safer to use 'transfer' or 'call' with proper error handling mechanisms.",
        "file_name": "0x30919c5c5c7727eea89b110d7258cbb36d541377.sol"
    }
]