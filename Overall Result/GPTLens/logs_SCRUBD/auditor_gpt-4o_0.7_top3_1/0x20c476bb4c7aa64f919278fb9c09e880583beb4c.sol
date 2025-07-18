[
    {
        "function_name": "fallback",
        "code": "function () external payable { if(msg.value == 0 || (msg.sender == ADDRESS_EIFP2_CONTRACT && msg.value >= 0.1 ether && !isResend)){ if(ADDRESS_EIFP2_CONTRACT.balance > maxBalance) { ADDRESS_ADMIN.transfer(address(this).balance); return; } isResend = msg.sender == ADDRESS_EIFP2_CONTRACT; if(!ADDRESS_EIFP2_CONTRACT.call.value(address(this).balance)()) revert(); isResend = false; } }",
        "vulnerability": "Reentrancy",
        "reason": "The contract calls an external contract through ADDRESS_EIFP2_CONTRACT.call.value(address(this).balance)() without implementing any reentrancy guard other than setting isResend. This can allow a reentrancy attack where the attacker drains the contract's funds by repeatedly calling the fallback function and exploiting the fact that the state change of resetting isResend is done after the call.",
        "file_name": "0x20c476bb4c7aa64f919278fb9c09e880583beb4c.sol"
    },
    {
        "function_name": "fallback",
        "code": "function () external payable { if(msg.value == 0 || (msg.sender == ADDRESS_EIFP2_CONTRACT && msg.value >= 0.1 ether && !isResend)){ if(ADDRESS_EIFP2_CONTRACT.balance > maxBalance) { ADDRESS_ADMIN.transfer(address(this).balance); return; } isResend = msg.sender == ADDRESS_EIFP2_CONTRACT; if(!ADDRESS_EIFP2_CONTRACT.call.value(address(this).balance)()) revert(); isResend = false; } }",
        "vulnerability": "Denial of Service (DoS) with Failed Call",
        "reason": "The contract attempts to transfer the entire balance to ADDRESS_EIFP2_CONTRACT using .call.value(address(this).balance)(). If the transfer fails, the fallback function reverts, effectively locking all funds in the contract. This can be exploited if ADDRESS_EIFP2_CONTRACT is a contract with a fallback function that always reverts, causing a permanent DoS.",
        "file_name": "0x20c476bb4c7aa64f919278fb9c09e880583beb4c.sol"
    },
    {
        "function_name": "fallback",
        "code": "function () external payable { if(msg.value == 0 || (msg.sender == ADDRESS_EIFP2_CONTRACT && msg.value >= 0.1 ether && !isResend)){ if(ADDRESS_EIFP2_CONTRACT.balance > maxBalance) { ADDRESS_ADMIN.transfer(address(this).balance); return; } isResend = msg.sender == ADDRESS_EIFP2_CONTRACT; if(!ADDRESS_EIFP2_CONTRACT.call.value(address(this).balance)()) revert(); isResend = false; } }",
        "vulnerability": "Ether Thief",
        "reason": "The fallback function allows ADDRESS_ADMIN to withdraw the entire contract balance if the balance of ADDRESS_EIFP2_CONTRACT exceeds maxBalance. This can be exploited by an attacker controlling ADDRESS_ADMIN to steal funds from the contract whenever the condition is met, regardless of the intentions of the original contract design.",
        "file_name": "0x20c476bb4c7aa64f919278fb9c09e880583beb4c.sol"
    }
]