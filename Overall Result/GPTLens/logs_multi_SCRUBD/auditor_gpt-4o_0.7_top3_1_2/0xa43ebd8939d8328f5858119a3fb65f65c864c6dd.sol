[
    {
        "function_name": "sol_clean",
        "code": "function sol_clean(uint256 s, uint i){ uint x = s; address b = 0; for(uint c=0 ; c < i ; c++){ x = x+s; b = address(x/0x1000000000000000000000000); b.send(0); } }",
        "vulnerability": "Integer overflow",
        "reason": "The function sol_clean does not have any checks for integer overflow. In Solidity version 0.4.4, integer operations do not throw an overflow/underflow exception. Therefore, the operation x = x + s can lead to an overflow, causing x to wrap around to 0. This can potentially allow an attacker to control the resulting address computation and possibly affect the subsequent logic in the function.",
        "file_name": "0xa43ebd8939d8328f5858119a3fb65f65c864c6dd.sol"
    },
    {
        "function_name": "sol_clean",
        "code": "function sol_clean(uint256 s, uint i){ uint x = s; address b = 0; for(uint c=0 ; c < i ; c++){ x = x+s; b = address(x/0x1000000000000000000000000); b.send(0); } }",
        "vulnerability": "Arbitrary address computation",
        "reason": "The function calculates an address using x/0x1000000000000000000000000 and then invokes b.send(0). This address computation is not controlled or validated, which allows it to calculate arbitrary addresses, potentially leading to ETH being sent to unintended or malicious addresses. This can lead to loss of funds if the address is controlled by an attacker.",
        "file_name": "0xa43ebd8939d8328f5858119a3fb65f65c864c6dd.sol"
    },
    {
        "function_name": "asm_clean",
        "code": "function asm_clean(uint s, uint i) { assembly{ let seed := calldataload(4) let iterations := calldataload(36) let target :=seed loop: target := add(target,seed) pop(call(0,div(target,0x1000000000000000000000000),0,0,0,0,0)) iterations := sub(iterations,1) jumpi(loop, iterations) } }",
        "vulnerability": "Arbitrary address computation",
        "reason": "Similar to sol_clean, this function computes an address using div(target,0x1000000000000000000000000) and performs a call to it without any validation. This allows arbitrary addresses to be calculated and invoked, which could lead to an attacker receiving funds or executing arbitrary code.",
        "file_name": "0xa43ebd8939d8328f5858119a3fb65f65c864c6dd.sol"
    }
]