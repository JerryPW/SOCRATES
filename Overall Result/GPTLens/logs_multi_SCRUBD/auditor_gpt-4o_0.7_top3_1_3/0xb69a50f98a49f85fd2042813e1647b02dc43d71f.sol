[
    {
        "function_name": "unlockContract",
        "code": "function unlockContract() onlyOwner public returns (bool) { contractLocked = false; Unlocked(); return false; }",
        "vulnerability": "Incorrect return value can cause confusion",
        "reason": "The function `unlockContract` returns `false` even though the contract is successfully unlocked. This can lead to misinterpretation by external systems and developers who may rely on the return value to confirm the success of the operation. This inconsistency can be exploited by attackers to create confusion about the contract's state.",
        "file_name": "0xb69a50f98a49f85fd2042813e1647b02dc43d71f.sol"
    },
    {
        "function_name": "distributeEbyteForEBYTE",
        "code": "function distributeEbyteForEBYTE(address[] addresses) onlyOwner public { for (uint i = 0; i < addresses.length; i++) { if (getTokenBalance(addresses[i]) < ebyteBalance) { continue; } uint256 toDistr = (getTokenBalance(addresses[i]) / 100) * percentage; sendTokens(addresses[i], toDistr); ebyteToken.transfer(addresses[i], toDistr); } }",
        "vulnerability": "Integer overflow in token distribution",
        "reason": "The calculation of `toDistr` using `(getTokenBalance(addresses[i]) / 100) * percentage` can result in an integer overflow if `getTokenBalance(addresses[i])` is very large. This can lead to incorrect distribution amounts, potentially allowing attackers to receive more tokens than intended if they manipulate their token balance to a large value.",
        "file_name": "0xb69a50f98a49f85fd2042813e1647b02dc43d71f.sol"
    },
    {
        "function_name": "distributeEbyte",
        "code": "function distributeEbyte(address[] addresses, uint256 value) onlyOwner public { for (uint i = 0; i < addresses.length; i++) { sendTokens(addresses[i], value); ebyteToken.transfer(addresses[i], value); } }",
        "vulnerability": "Lack of validation on token transfer",
        "reason": "This function does not validate if the `ebyteToken.transfer` call is successful. If the transfer fails, it will not revert the transaction, potentially causing accounting discrepancies. An attacker can exploit this by providing addresses that cannot receive tokens, resulting in a mismatch between expected and actual token distribution.",
        "file_name": "0xb69a50f98a49f85fd2042813e1647b02dc43d71f.sol"
    }
]