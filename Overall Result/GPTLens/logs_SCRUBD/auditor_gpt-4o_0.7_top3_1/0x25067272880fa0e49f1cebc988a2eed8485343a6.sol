[
    {
        "function_name": "sendTo",
        "code": "function sendTo(address dest, uint amount, address token) public admin returns(bool) { require(addressOk(dest) && sendable(token, amount)); if (token == address(0)) { if (!dest.call.gas(250000).value(amount)()) dest.transfer(amount); } else { if (!ERC20(token).transfer(dest, amount)) revert(); } emit Sent(dest, token, amount); return; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function uses `dest.call.gas(250000).value(amount)()` to send Ether, which is a low-level call that forwards all remaining gas and allows for reentrancy attacks. An attacker can re-enter the contract and execute further operations before the `sendTo` function completes, potentially leading to unauthorized access or depletion of funds.",
        "file_name": "0x25067272880fa0e49f1cebc988a2eed8485343a6.sol"
    },
    {
        "function_name": "changeOwner",
        "code": "function changeOwner(address newOwner) public admin returns(bool) { require(addressOk(newOwner)); owner = newOwner; return true; }",
        "vulnerability": "Improper ownership transfer",
        "reason": "The `changeOwner` function allows the current owner to transfer ownership to any address, including contracts or addresses not controlled by the owner. This could inadvertently lock the wallet or allow an attacker who gains temporary control of the owner account to permanently seize control of the contract.",
        "file_name": "0x25067272880fa0e49f1cebc988a2eed8485343a6.sol"
    },
    {
        "function_name": "sendable",
        "code": "function sendable(address token, uint amount) public view returns(bool) { uint bal = address(this).balance; if (token != address(0)) bal = ERC20(token).balanceOf(address(this)); if (amount > 0 && amount <= bal) return true; else return false; }",
        "vulnerability": "Incorrect balance check for ERC20 tokens",
        "reason": "The `sendable` function uses `ERC20(token).balanceOf(address(this))`, which assumes that the token follows the ERC20 standard correctly. However, some tokens might not adhere to this standard or might have non-standard behavior (e.g., fee-on-transfer tokens), leading to incorrect balance checks and potential transfer failures.",
        "file_name": "0x25067272880fa0e49f1cebc988a2eed8485343a6.sol"
    }
]