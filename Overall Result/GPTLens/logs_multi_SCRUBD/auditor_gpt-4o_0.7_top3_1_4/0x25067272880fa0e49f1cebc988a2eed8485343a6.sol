[
    {
        "function_name": "sendTo",
        "code": "function sendTo(address dest, uint amount, address token) public admin returns(bool) { require(addressOk(dest) && sendable(token, amount)); if (token == address(0)) { if (!dest.call.gas(250000).value(amount)()) dest.transfer(amount); } else { if (!ERC20(token).transfer(dest, amount)) revert(); } emit Sent(dest, token, amount); return; }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function uses low-level call to send Ether, which makes it susceptible to reentrancy attacks. If the destination contract has a fallback function that calls back into the Wallet contract, an attacker could exploit this to drain funds by recursively calling the sendTo function before the first call completes.",
        "file_name": "0x25067272880fa0e49f1cebc988a2eed8485343a6.sol"
    },
    {
        "function_name": "sendTo",
        "code": "function sendTo(address dest, uint amount, address token) public admin returns(bool) { require(addressOk(dest) && sendable(token, amount)); if (token == address(0)) { if (!dest.call.gas(250000).value(amount)()) dest.transfer(amount); } else { if (!ERC20(token).transfer(dest, amount)) revert(); } emit Sent(dest, token, amount); return; }",
        "vulnerability": "Gas Limit and Fallback Function Issue",
        "reason": "The use of dest.call.gas(250000).value(amount)() is unreliable because it sets a fixed gas limit, which may not be sufficient for the destination contract's execution requirements. If the gas limit is too low, the Ether transfer may fail, and the fallback mechanism using dest.transfer(amount) won't be executed, potentially causing a loss of funds or locking them in the contract.",
        "file_name": "0x25067272880fa0e49f1cebc988a2eed8485343a6.sol"
    },
    {
        "function_name": "changeOwner",
        "code": "function changeOwner(address newOwner) public admin returns(bool) { require(addressOk(newOwner)); owner = newOwner; return true; }",
        "vulnerability": "Lack of Event Emission",
        "reason": "The changeOwner function updates the contract owner but does not emit an event to log this critical change. This lack of transparency can make it difficult to track ownership changes, and an attacker changing ownership could go unnoticed until it's too late.",
        "file_name": "0x25067272880fa0e49f1cebc988a2eed8485343a6.sol"
    }
]