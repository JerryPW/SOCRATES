[
    {
        "function_name": "unlockContract",
        "code": "function unlockContract() onlyOwner public returns (bool) { contractLocked = false; Unlocked(); return false; }",
        "vulnerability": "Incorrect return value",
        "reason": "The function always returns false, which is misleading. While it should return true to indicate successful unlocking, this could lead to logical errors in dependent systems that rely on the return value to confirm the contract's state.",
        "file_name": "0xecfe4b7afc47260cb590d3043d3f790a61bb7910.sol"
    },
    {
        "function_name": "distribution",
        "code": "function distribution(address[] addresses) onlyOwner public { for (uint i = 0; i < addresses.length; i++) { distributeEbyteForEBYTE(addresses); distributeEbyteForETH(addresses); break; } }",
        "vulnerability": "Incorrect loop break",
        "reason": "The loop breaks after the first iteration, meaning that only the first address in the array is processed. This prevents distribution to the rest of the addresses, which might be a logical error depending on the intended behavior.",
        "file_name": "0xecfe4b7afc47260cb590d3043d3f790a61bb7910.sol"
    },
    {
        "function_name": "distributeEbyte",
        "code": "function distributeEbyte(address[] addresses, uint256 value) onlyOwner public { for (uint i = 0; i < addresses.length; i++) { sendTokens(addresses[i], value); ebyteToken.transfer(addresses[i], value); } }",
        "vulnerability": "Potential out-of-gas issue",
        "reason": "The function can potentially run out of gas if the addresses array is too large, due to the unbounded iteration and external calls to transfer tokens. This can lead to transaction failures, especially if the array size is not controlled or limited.",
        "file_name": "0xecfe4b7afc47260cb590d3043d3f790a61bb7910.sol"
    }
]