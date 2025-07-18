[
    {
        "function_name": "setAdmin",
        "vulnerability": "Lack of multi-signature requirement for admin change",
        "criticism": "The reasoning is correct in identifying that any single admin can unilaterally change their address without the consent of other admins. This could indeed lead to a scenario where an admin is compromised or acts maliciously, potentially allowing an attacker to gain control over the contract's administrative functions. The severity is moderate to high because it affects the governance of the contract, which could have significant implications. The profitability is moderate because an attacker could gain control over the contract, but it requires compromising an admin first.",
        "correctness": 8,
        "severity": 6,
        "profitability": 5,
        "reason": "The setAdmin function allows any single admin to unilaterally replace their address with a new one without the consent of the other admins. This could lead to a scenario where an admin is compromised or acts maliciously, changing their address to one controlled by an attacker, thereby gaining control over the contract's administrative functions.",
        "code": "function setAdmin(address _adminAddress) onlyAdmins public { require(_adminAddress != admin1); require(_adminAddress != admin2); require(_adminAddress != admin3); if (admin1 == msg.sender) { admin1 = _adminAddress; } else if (admin2 == msg.sender) { admin2 = _adminAddress; } else if (admin3 == msg.sender) { admin3 = _adminAddress; } }",
        "file_name": "0xe4e28bfd45969218a2af311ee10e80846f7b2fdc.sol"
    },
    {
        "function_name": "getFunds",
        "vulnerability": "Use of send function for fund transfer",
        "criticism": "The reasoning is correct in identifying the use of the send method, which forwards only 2300 gas. This can indeed cause the transfer to fail if the recipient address requires more gas, potentially locking funds in the contract. The severity is moderate because it can lead to a denial of service for fund transfers. The profitability is low because it does not directly benefit an attacker, but it can cause operational issues.",
        "correctness": 9,
        "severity": 5,
        "profitability": 1,
        "reason": "The getFunds function uses the send method to transfer funds to the benefit address. The send method only forwards 2300 gas, which can cause the transfer to fail if the recipient address requires more gas to execute its fallback function. This vulnerability can potentially lock funds in the contract if the benefit address cannot accept the transfer, thereby causing a denial of service.",
        "code": "function getFunds(uint amount) public onlyAdmins { require(benefit != 0x0); require(amount <= this.balance); Raise(benefit, amount); benefit.send(amount); }",
        "file_name": "0xe4e28bfd45969218a2af311ee10e80846f7b2fdc.sol"
    },
    {
        "function_name": "fallback function",
        "vulnerability": "Potential overflow in token calculation",
        "criticism": "The reasoning is correct in identifying the potential for overflow in the token calculation, especially with large values of msg.value. However, the severity is somewhat mitigated by the fact that modern Solidity versions include overflow checks, and developers are encouraged to use SafeMath libraries. The severity is moderate because it can lead to incorrect token transfers, and the profitability is high because an attacker could potentially receive more tokens than intended.",
        "correctness": 8,
        "severity": 5,
        "profitability": 7,
        "reason": "In the fallback function, the calculation of tokenAmountWithoutBonus and tokenAmount could lead to an overflow, especially when dealing with large values of msg.value. Although Solidity 0.4.16 does not have built-in overflow checks, this can lead to incorrect token transfer amounts, allowing attackers to receive more tokens than intended.",
        "code": "function() payable public goodDate belowHardCap { uint tokenAmountWithoutBonus = msg.value * tokensPerEther; uint tokenAmount = tokenAmountWithoutBonus + (tokenAmountWithoutBonus * bonus/100); token.transferPresale(msg.sender, tokenAmount); raised+=msg.value; balanceOf[msg.sender]+= msg.value; Investing(msg.sender, msg.value, tokenAmountWithoutBonus, tokenAmount); }",
        "file_name": "0xe4e28bfd45969218a2af311ee10e80846f7b2fdc.sol"
    }
]