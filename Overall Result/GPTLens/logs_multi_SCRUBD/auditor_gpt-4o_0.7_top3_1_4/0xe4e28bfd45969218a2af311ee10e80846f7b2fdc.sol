[
    {
        "function_name": "setAdmin",
        "code": "function setAdmin(address _adminAddress) onlyAdmins public { require(_adminAddress != admin1); require(_adminAddress != admin2); require(_adminAddress != admin3); if (admin1 == msg.sender) { admin1 = _adminAddress; } else if (admin2 == msg.sender) { admin2 = _adminAddress; } else if (admin3 == msg.sender) { admin3 = _adminAddress; } }",
        "vulnerability": "Admin privilege escalation",
        "reason": "The `setAdmin` function allows any of the current admins to replace themselves with a new address. This does not require any consent from other admins, which means a compromised admin account or a malicious admin can add a new arbitrary address, potentially allowing an unauthorized party to gain admin privileges.",
        "file_name": "0xe4e28bfd45969218a2af311ee10e80846f7b2fdc.sol"
    },
    {
        "function_name": "getFunds",
        "code": "function getFunds(uint amount) public onlyAdmins { require(benefit != 0x0); require(amount <= this.balance); Raise(benefit, amount); benefit.send(amount); }",
        "vulnerability": "Unsafe external call",
        "reason": "The `getFunds` function uses the `.send()` method to transfer funds to the `benefit` address. The `.send()` method only forwards 2300 gas, which can cause the function to fail if the recipient requires more gas for execution. Furthermore, it does not handle the failure of the send operation appropriately, which could lead to loss of funds or stuck ether if the `send` fails.",
        "file_name": "0xe4e28bfd45969218a2af311ee10e80846f7b2fdc.sol"
    },
    {
        "function_name": "function() payable",
        "code": "function() payable public goodDate belowHardCap { uint tokenAmountWithoutBonus = msg.value * tokensPerEther; uint tokenAmount = tokenAmountWithoutBonus + (tokenAmountWithoutBonus * bonus/100); token.transferPresale(msg.sender, tokenAmount); raised+=msg.value; balanceOf[msg.sender]+= msg.value; Investing(msg.sender, msg.value, tokenAmountWithoutBonus, tokenAmount); }",
        "vulnerability": "Potential integer overflow",
        "reason": "The fallback function calculates `tokenAmount` using multiplication and addition, which could lead to integer overflow if `msg.value` is large enough. This can result in incorrect token amounts being calculated and transferred, potentially leading to the unauthorized minting of tokens.",
        "file_name": "0xe4e28bfd45969218a2af311ee10e80846f7b2fdc.sol"
    }
]