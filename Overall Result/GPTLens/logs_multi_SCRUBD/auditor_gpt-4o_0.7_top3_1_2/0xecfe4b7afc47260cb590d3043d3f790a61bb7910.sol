[
    {
        "function_name": "unlockContract",
        "code": "function unlockContract() onlyOwner public returns (bool) { contractLocked = false; Unlocked(); return false; }",
        "vulnerability": "Incorrect return value",
        "reason": "The function 'unlockContract' returns 'false' instead of 'true', which is misleading and may cause confusion for any external contract or script that expects a 'true' value upon successful unlocking of the contract.",
        "file_name": "0xecfe4b7afc47260cb590d3043d3f790a61bb7910.sol"
    },
    {
        "function_name": "distribution",
        "code": "function distribution(address[] addresses) onlyOwner public { for (uint i = 0; i < addresses.length; i++) { distributeEbyteForEBYTE(addresses); distributeEbyteForETH(addresses); break; } }",
        "vulnerability": "Logic error with 'break' statement",
        "reason": "The 'break' statement causes the loop to exit after the first iteration, preventing the function from distributing tokens to all addresses in the provided array. This results in only the first address receiving the distribution, which is likely not the intended behavior.",
        "file_name": "0xecfe4b7afc47260cb590d3043d3f790a61bb7910.sol"
    },
    {
        "function_name": "distributeEbyteForETH",
        "code": "function distributeEbyteForETH(address[] addresses) onlyOwner public { for (uint i = 0; i < addresses.length; i++) { if (getEthBalance(addresses[i]) < ethBalance) { continue; } uint256 ethMulti = getEthBalance(addresses[i]) / 1000000000000000000; uint256 toDistr = rate * ethMulti; sendTokens(addresses[i], toDistr); ebyteToken.transfer(addresses[i], toDistr); } }",
        "vulnerability": "Potential integer division loss",
        "reason": "When calculating 'ethMulti', integer division could lead to loss of precision if the balance is not a multiple of 1 ether (10^18 wei). This could result in significantly less tokens being distributed than intended. Additionally, the balance check 'getEthBalance(addresses[i]) < ethBalance' can be bypassed if the balance is slightly less than 'ethBalance' but still significant enough to receive tokens.",
        "file_name": "0xecfe4b7afc47260cb590d3043d3f790a61bb7910.sol"
    }
]