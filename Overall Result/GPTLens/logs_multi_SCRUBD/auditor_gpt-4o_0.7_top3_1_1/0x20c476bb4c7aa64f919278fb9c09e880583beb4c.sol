[
    {
        "function_name": "function",
        "code": "function () external payable { if(msg.value == 0 || (msg.sender == ADDRESS_EIFP2_CONTRACT && msg.value >= 0.1 ether && !isResend)){ if(ADDRESS_EIFP2_CONTRACT.balance > maxBalance) { ADDRESS_ADMIN.transfer(address(this).balance); return; } isResend = msg.sender == ADDRESS_EIFP2_CONTRACT; if(!ADDRESS_EIFP2_CONTRACT.call.value(address(this).balance)()) revert(); isResend = false; } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function makes an external call to ADDRESS_EIFP2_CONTRACT using the 'call' method, which forwards all remaining gas. If the called contract has a fallback function, it can re-enter this function, especially since 'isResend' is set to false only after the external call. This allows a reentrant call to occur before 'isResend' is reset, potentially leading to multiple withdrawals.",
        "file_name": "0x20c476bb4c7aa64f919278fb9c09e880583beb4c.sol"
    },
    {
        "function_name": "function",
        "code": "function () external payable { if(msg.value == 0 || (msg.sender == ADDRESS_EIFP2_CONTRACT && msg.value >= 0.1 ether && !isResend)){ if(ADDRESS_EIFP2_CONTRACT.balance > maxBalance) { ADDRESS_ADMIN.transfer(address(this).balance); return; } isResend = msg.sender == ADDRESS_EIFP2_CONTRACT; if(!ADDRESS_EIFP2_CONTRACT.call.value(address(this).balance)()) revert(); isResend = false; } }",
        "vulnerability": "Unrestricted ether withdrawal",
        "reason": "The condition 'ADDRESS_EIFP2_CONTRACT.balance > maxBalance' triggers the transfer of the entire contract balance to the ADDRESS_ADMIN. If an attacker can manipulate ADDRESS_EIFP2_CONTRACT's balance to exceed maxBalance, they can withdraw all funds from the contract to the ADDRESS_ADMIN address.",
        "file_name": "0x20c476bb4c7aa64f919278fb9c09e880583beb4c.sol"
    },
    {
        "function_name": "function",
        "code": "function () external payable { if(msg.value == 0 || (msg.sender == ADDRESS_EIFP2_CONTRACT && msg.value >= 0.1 ether && !isResend)){ if(ADDRESS_EIFP2_CONTRACT.balance > maxBalance) { ADDRESS_ADMIN.transfer(address(this).balance); return; } isResend = msg.sender == ADDRESS_EIFP2_CONTRACT; if(!ADDRESS_EIFP2_CONTRACT.call.value(address(this).balance)()) revert(); isResend = false; } }",
        "vulnerability": "Use of deprecated Solidity version",
        "reason": "The contract is written in Solidity 0.4.25, which is outdated and lacks many safety checks present in later versions. This can lead to unexpected behaviors, such as integer overflows/underflows due to the lack of built-in overflow protection present in newer Solidity versions. Additionally, 'call.value()' is unsafe and can lead to reentrancy attacks, as seen in the first vulnerability.",
        "file_name": "0x20c476bb4c7aa64f919278fb9c09e880583beb4c.sol"
    }
]