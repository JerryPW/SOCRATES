[
    {
        "function_name": "getFunds",
        "code": "function getFunds(uint amount) public onlyAdmins { require(benefit != 0x0); require(amount <= this.balance); Raise(benefit, amount); benefit.send(amount); }",
        "vulnerability": "Unsafe Ether Transfer",
        "reason": "The use of 'benefit.send(amount)' for transferring Ether is unsafe due to its fixed gas stipend of 2300 gas, which may not be sufficient if the receiver is a contract with a fallback function requiring more gas. It also does not handle potential failures properly, potentially locking funds if the transfer fails.",
        "file_name": "0xe4e28bfd45969218a2af311ee10e80846f7b2fdc.sol"
    },
    {
        "function_name": "setAdmin",
        "code": "function setAdmin(address _adminAddress) onlyAdmins public { require(_adminAddress != admin1); require(_adminAddress != admin2); require(_adminAddress != admin3); if (admin1 == msg.sender) { admin1 = _adminAddress; } else if (admin2 == msg.sender) { admin2 = _adminAddress; } else if (admin3 == msg.sender) { admin3 = _adminAddress; } }",
        "vulnerability": "Single Admin Authorization",
        "reason": "The 'setAdmin' function allows a single admin to unilaterally change their address to another one without requiring consent from other admins. This could allow an admin who has been compromised or has malicious intent to replace themselves with an attacker-controlled address.",
        "file_name": "0xe4e28bfd45969218a2af311ee10e80846f7b2fdc.sol"
    },
    {
        "function_name": "Presale",
        "code": "function() payable public goodDate belowHardCap { uint tokenAmountWithoutBonus = msg.value * tokensPerEther; uint tokenAmount = tokenAmountWithoutBonus + (tokenAmountWithoutBonus * bonus/100); token.transferPresale(msg.sender, tokenAmount); raised+=msg.value; balanceOf[msg.sender]+= msg.value; Investing(msg.sender, msg.value, tokenAmountWithoutBonus, tokenAmount); }",
        "vulnerability": "Lack of Input Validation",
        "reason": "The fallback function does not validate the input 'msg.value' or check for reasonable Ether contributions. Attackers could potentially manipulate this to affect the 'raised' and 'balanceOf' state variables, possibly causing integer overflows or bypassing intended limits.",
        "file_name": "0xe4e28bfd45969218a2af311ee10e80846f7b2fdc.sol"
    }
]