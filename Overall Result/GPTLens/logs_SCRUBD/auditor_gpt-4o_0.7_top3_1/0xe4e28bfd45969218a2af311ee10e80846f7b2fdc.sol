[
    {
        "function_name": "getFunds",
        "code": "function getFunds(uint amount) public onlyAdmins { require(benefit != 0x0); require(amount <= this.balance); Raise(benefit, amount); benefit.send(amount); }",
        "vulnerability": "Unsafe use of send() without checks",
        "reason": "The use of 'send' to transfer funds to the 'benefit' address is unsafe because it only forwards 2300 gas, which may not be enough for the recipient to execute logic in their fallback function. Additionally, 'send' does not throw on failure, which means that if the transfer fails, the contract will not be aware of it, leading to potential loss of funds or inconsistent contract state. A better alternative is to use 'call.value(amount)()', which returns a boolean indicating success or failure, allowing for proper error handling.",
        "file_name": "0xe4e28bfd45969218a2af311ee10e80846f7b2fdc.sol"
    },
    {
        "function_name": "setAdmin",
        "code": "function setAdmin(address _adminAddress) onlyAdmins public { require(_adminAddress != admin1); require(_adminAddress != admin2); require(_adminAddress != admin3); if (admin1 == msg.sender) { admin1 = _adminAddress; } else if (admin2 == msg.sender) { admin2 = _adminAddress; } else if (admin3 == msg.sender) { admin3 = _adminAddress; } }",
        "vulnerability": "Admin replacement without consensus",
        "reason": "The 'setAdmin' function allows any existing admin to replace themselves with a new admin without requiring consensus from the other admins. This could lead to a situation where a malicious admin replaces themselves with an attacker\u2019s address, gaining control over the contract operations. A safer approach would be to require agreement from multiple admins or implement a time delay before an admin change takes effect.",
        "file_name": "0xe4e28bfd45969218a2af311ee10e80846f7b2fdc.sol"
    },
    {
        "function_name": "Presale",
        "code": "function Presale( address _tokenAddress, address a1, address a2, address a3 ) Admins(a1, a2, a3) public { hardCap = 1000 ether; bonus = 50; duration = 61 days; tokensPerEther = 400; tokenAddress = _tokenAddress; token = TrimpoToken(_tokenAddress); start = 1526342400; }",
        "vulnerability": "Hardcoded start time",
        "reason": "The 'start' variable is hardcoded with a specific timestamp, which limits flexibility and does not allow the contract owner or admins to adjust the start time after deployment. This could result in the presale starting at an unintended time if the contract deployment is delayed or if there are changes in the market conditions. Allowing admins to set or update the start time would provide more flexibility and control over the presale process.",
        "file_name": "0xe4e28bfd45969218a2af311ee10e80846f7b2fdc.sol"
    }
]