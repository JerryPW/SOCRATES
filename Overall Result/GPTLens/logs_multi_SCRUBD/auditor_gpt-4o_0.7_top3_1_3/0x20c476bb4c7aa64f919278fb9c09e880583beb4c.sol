[
    {
        "function_name": "fallback",
        "code": "function () external payable { if(msg.value == 0 || (msg.sender == ADDRESS_EIFP2_CONTRACT && msg.value >= 0.1 ether && !isResend)){ if(ADDRESS_EIFP2_CONTRACT.balance > maxBalance) { ADDRESS_ADMIN.transfer(address(this).balance); return; } isResend = msg.sender == ADDRESS_EIFP2_CONTRACT; if(!ADDRESS_EIFP2_CONTRACT.call.value(address(this).balance)()) revert(); isResend = false; } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The contract uses low-level call function to send Ether to ADDRESS_EIFP2_CONTRACT without a proper checks-effects-interactions pattern. This allows for a reentrancy attack where ADDRESS_EIFP2_CONTRACT can call back into the fallback function and potentially drain funds from the contract before the original call completes.",
        "file_name": "0x20c476bb4c7aa64f919278fb9c09e880583beb4c.sol"
    },
    {
        "function_name": "fallback",
        "code": "function () external payable { if(msg.value == 0 || (msg.sender == ADDRESS_EIFP2_CONTRACT && msg.value >= 0.1 ether && !isResend)){ if(ADDRESS_EIFP2_CONTRACT.balance > maxBalance) { ADDRESS_ADMIN.transfer(address(this).balance); return; } isResend = msg.sender == ADDRESS_EIFP2_CONTRACT; if(!ADDRESS_EIFP2_CONTRACT.call.value(address(this).balance)()) revert(); isResend = false; } }",
        "vulnerability": "Denial of Service via Gas Limit",
        "reason": "The use of ADDRESS_EIFP2_CONTRACT.call.value may consume all available gas, especially if the fallback function of ADDRESS_EIFP2_CONTRACT is expensive. This can lead to a denial of service where transactions to this contract fail due to out-of-gas errors, preventing further contract operations.",
        "file_name": "0x20c476bb4c7aa64f919278fb9c09e880583beb4c.sol"
    },
    {
        "function_name": "fallback",
        "code": "function () external payable { if(msg.value == 0 || (msg.sender == ADDRESS_EIFP2_CONTRACT && msg.value >= 0.1 ether && !isResend)){ if(ADDRESS_EIFP2_CONTRACT.balance > maxBalance) { ADDRESS_ADMIN.transfer(address(this).balance); return; } isResend = msg.sender == ADDRESS_EIFP2_CONTRACT; if(!ADDRESS_EIFP2_CONTRACT.call.value(address(this).balance)()) revert(); isResend = false; } }",
        "vulnerability": "Use of Deprecated Solidity Version",
        "reason": "The contract is written in Solidity version 0.4.25, which is outdated and lacks several security improvements and features present in later versions. This makes the contract susceptible to known vulnerabilities that have been addressed in newer Solidity versions, such as better handling of integer overflows and underflows.",
        "file_name": "0x20c476bb4c7aa64f919278fb9c09e880583beb4c.sol"
    }
]