[
    {
        "function_name": "getFunds",
        "code": "function getFunds(uint amount) public onlyAdmins { require(benefit != 0x0); require(amount <= this.balance); Raise(benefit, amount); benefit.send(amount); }",
        "vulnerability": "Unsafe use of send() function",
        "reason": "The use of the send() function can lead to reentrancy vulnerabilities because it only forwards 2300 gas, which may not be sufficient for the fallback function of the benefit address. If the fallback function fails, the transaction will not revert, potentially leading to loss of funds. Furthermore, this function is susceptible to reentrancy attacks if an attacker is able to manipulate the benefit address to point to a contract they control. When the send function is called, it could trigger a fallback function in the attacker's contract leading to a drain of funds.",
        "file_name": "0xe4e28bfd45969218a2af311ee10e80846f7b2fdc.sol"
    },
    {
        "function_name": "setAdmin",
        "code": "function setAdmin(address _adminAddress) onlyAdmins public { require(_adminAddress != admin1); require(_adminAddress != admin2); require(_adminAddress != admin3); if (admin1 == msg.sender) { admin1 = _adminAddress; } else if (admin2 == msg.sender) { admin2 = _adminAddress; } else if (admin3 == msg.sender) { admin3 = _adminAddress; } }",
        "vulnerability": "Admin replacement without verification",
        "reason": "This function allows any current admin to replace themselves with a new admin address without any additional verification or consensus from other admins. This could lead to a hostile takeover of the contract's administration if one admin's private key is compromised. An attacker who gains access to the private key of any admin can replace that admin with an address they control and potentially manipulate the contract's behavior.",
        "file_name": "0xe4e28bfd45969218a2af311ee10e80846f7b2fdc.sol"
    },
    {
        "function_name": "Presale",
        "code": "function() payable public goodDate belowHardCap { uint tokenAmountWithoutBonus = msg.value * tokensPerEther; uint tokenAmount = tokenAmountWithoutBonus + (tokenAmountWithoutBonus * bonus/100); token.transferPresale(msg.sender, tokenAmount); raised+=msg.value; balanceOf[msg.sender]+= msg.value; Investing(msg.sender, msg.value, tokenAmountWithoutBonus, tokenAmount); }",
        "vulnerability": "Lack of input validation and potential integer overflow",
        "reason": "The calculation of `tokenAmount` involves multiplying `msg.value` by `tokensPerEther` and then calculating bonuses, all without any checks for overflow. Although Solidity 0.4.16 does not support SafeMath, it is essential to manually check for potential overflows in arithmetic operations. If `msg.value` is large enough, it could cause an overflow that would result in incorrect token calculations, potentially allowing attackers to receive more tokens than intended.",
        "file_name": "0xe4e28bfd45969218a2af311ee10e80846f7b2fdc.sol"
    }
]