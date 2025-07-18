[
    {
        "function_name": "sendTo",
        "code": "function sendTo(address dest, uint amount, address token) public admin returns(bool) { require(addressOk(dest) && sendable(token, amount)); if (token == address(0)) { if (!dest.call.gas(250000).value(amount)()) dest.transfer(amount); } else { if (!ERC20(token).transfer(dest, amount)) revert(); } emit Sent(dest, token, amount); return; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function uses low-level call to send Ether without proper checks-effects-interactions pattern, allowing a reentrancy attack. An attacker can recursively call back into the contract before the state changes are finalized, potentially draining funds.",
        "file_name": "0x25067272880fa0e49f1cebc988a2eed8485343a6.sol"
    },
    {
        "function_name": "changeOwner",
        "code": "function changeOwner(address newOwner) public admin returns(bool) { require(addressOk(newOwner)); owner = newOwner; return true; }",
        "vulnerability": "Improper access control",
        "reason": "There is no mechanism to log or restrict ownership change requests. If the private key of the current owner is compromised, an attacker can easily change the ownership without any possibility of intervention, making the contract permanently insecure.",
        "file_name": "0x25067272880fa0e49f1cebc988a2eed8485343a6.sol"
    },
    {
        "function_name": "sendTo",
        "code": "function sendTo(address dest, uint amount, address token) public admin returns(bool) { require(addressOk(dest) && sendable(token, amount)); if (token == address(0)) { if (!dest.call.gas(250000).value(amount)()) dest.transfer(amount); } else { if (!ERC20(token).transfer(dest, amount)) revert(); } emit Sent(dest, token, amount); return; }",
        "vulnerability": "Potential gas limit issues",
        "reason": "The fixed gas stipend of 250,000 used in the call can be insufficient for complex fallback functions, leading to failed transactions. This can be exploited by attackers to block certain Ether transfers, potentially causing denial of service.",
        "file_name": "0x25067272880fa0e49f1cebc988a2eed8485343a6.sol"
    }
]