[
    {
        "function_name": "fallback function",
        "code": "function () external payable { if(msg.value == 0 || (msg.sender == ADDRESS_EIFP2_CONTRACT && msg.value >= 0.1 ether && !isResend)){ if(ADDRESS_EIFP2_CONTRACT.balance > maxBalance) { ADDRESS_ADMIN.transfer(address(this).balance); return; } isResend = msg.sender == ADDRESS_EIFP2_CONTRACT; if(!ADDRESS_EIFP2_CONTRACT.call.value(address(this).balance)()) revert(); isResend = false; } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function is vulnerable to reentrancy because it sends ether via a call to ADDRESS_EIFP2_CONTRACT without updating the state variable isResend beforehand. An attacker can exploit this by repeatedly calling the fallback function and sending 0 ether to trigger the transfer and drain the contract\u2019s funds.",
        "file_name": "0x20c476bb4c7aa64f919278fb9c09e880583beb4c.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function () external payable { if(msg.value == 0 || (msg.sender == ADDRESS_EIFP2_CONTRACT && msg.value >= 0.1 ether && !isResend)){ if(ADDRESS_EIFP2_CONTRACT.balance > maxBalance) { ADDRESS_ADMIN.transfer(address(this).balance); return; } isResend = msg.sender == ADDRESS_EIFP2_CONTRACT; if(!ADDRESS_EIFP2_CONTRACT.call.value(address(this).balance)()) revert(); isResend = false; } }",
        "vulnerability": "Improper use of call without gas limit",
        "reason": "The contract uses the low-level call function without specifying a gas limit, which could lead to unexpected behavior if the receiving contract consumes more gas than expected. This could also be exploited in combination with a reentrancy attack to ensure the call consumes all available gas, making the contract revert after draining funds.",
        "file_name": "0x20c476bb4c7aa64f919278fb9c09e880583beb4c.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function () external payable { if(msg.value == 0 || (msg.sender == ADDRESS_EIFP2_CONTRACT && msg.value >= 0.1 ether && !isResend)){ if(ADDRESS_EIFP2_CONTRACT.balance > maxBalance) { ADDRESS_ADMIN.transfer(address(this).balance); return; } isResend = msg.sender == ADDRESS_EIFP2_CONTRACT; if(!ADDRESS_EIFP2_CONTRACT.call.value(address(this).balance)()) revert(); isResend = false; } }",
        "vulnerability": "Unrestricted access to fallback function",
        "reason": "The fallback function is publicly accessible and can be triggered by any address. This can be exploited by attackers to manipulate the contract\u2019s behavior, especially when combined with the reentrancy vulnerability, enabling unauthorized users to potentially drain the contract of its funds.",
        "file_name": "0x20c476bb4c7aa64f919278fb9c09e880583beb4c.sol"
    }
]