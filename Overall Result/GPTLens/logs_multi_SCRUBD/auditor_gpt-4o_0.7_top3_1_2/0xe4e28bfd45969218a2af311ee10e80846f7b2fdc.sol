[
    {
        "function_name": "setAdmin",
        "code": "function setAdmin(address _adminAddress) onlyAdmins public { require(_adminAddress != admin1); require(_adminAddress != admin2); require(_adminAddress != admin3); if (admin1 == msg.sender) { admin1 = _adminAddress; } else if (admin2 == msg.sender) { admin2 = _adminAddress; } else if (admin3 == msg.sender) { admin3 = _adminAddress; } }",
        "vulnerability": "Lack of multi-signature requirement for admin change",
        "reason": "The setAdmin function allows any single admin to unilaterally replace their address with a new one without the consent of the other admins. This could lead to a scenario where an admin is compromised or acts maliciously, changing their address to one controlled by an attacker, thereby gaining control over the contract's administrative functions.",
        "file_name": "0xe4e28bfd45969218a2af311ee10e80846f7b2fdc.sol"
    },
    {
        "function_name": "getFunds",
        "code": "function getFunds(uint amount) public onlyAdmins { require(benefit != 0x0); require(amount <= this.balance); Raise(benefit, amount); benefit.send(amount); }",
        "vulnerability": "Use of send function for fund transfer",
        "reason": "The getFunds function uses the send method to transfer funds to the benefit address. The send method only forwards 2300 gas, which can cause the transfer to fail if the recipient address requires more gas to execute its fallback function. This vulnerability can potentially lock funds in the contract if the benefit address cannot accept the transfer, thereby causing a denial of service.",
        "file_name": "0xe4e28bfd45969218a2af311ee10e80846f7b2fdc.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function() payable public goodDate belowHardCap { uint tokenAmountWithoutBonus = msg.value * tokensPerEther; uint tokenAmount = tokenAmountWithoutBonus + (tokenAmountWithoutBonus * bonus/100); token.transferPresale(msg.sender, tokenAmount); raised+=msg.value; balanceOf[msg.sender]+= msg.value; Investing(msg.sender, msg.value, tokenAmountWithoutBonus, tokenAmount); }",
        "vulnerability": "Potential overflow in token calculation",
        "reason": "In the fallback function, the calculation of tokenAmountWithoutBonus and tokenAmount could lead to an overflow, especially when dealing with large values of msg.value. Although Solidity 0.4.16 does not have built-in overflow checks, this can lead to incorrect token transfer amounts, allowing attackers to receive more tokens than intended.",
        "file_name": "0xe4e28bfd45969218a2af311ee10e80846f7b2fdc.sol"
    }
]