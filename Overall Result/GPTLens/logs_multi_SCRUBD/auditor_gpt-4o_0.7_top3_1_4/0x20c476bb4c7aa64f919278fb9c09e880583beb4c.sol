[
    {
        "function_name": "fallback_function",
        "code": "function () external payable { if(msg.value == 0 || (msg.sender == ADDRESS_EIFP2_CONTRACT && msg.value >= 0.1 ether && !isResend)){ if(ADDRESS_EIFP2_CONTRACT.balance > maxBalance) { ADDRESS_ADMIN.transfer(address(this).balance); return; } isResend = msg.sender == ADDRESS_EIFP2_CONTRACT; if(!ADDRESS_EIFP2_CONTRACT.call.value(address(this).balance)()) revert(); isResend = false; } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The contract allows transferring all its balance to ADDRESS_EIFP2_CONTRACT using a call. This is susceptible to reentrancy attacks, as the external call is made before the state variable `isResend` is reset to false. An attacker could exploit this by recursively calling the fallback function, leading to multiple transfers before the state is updated.",
        "file_name": "0x20c476bb4c7aa64f919278fb9c09e880583beb4c.sol"
    },
    {
        "function_name": "fallback_function",
        "code": "function () external payable { if(msg.value == 0 || (msg.sender == ADDRESS_EIFP2_CONTRACT && msg.value >= 0.1 ether && !isResend)){ if(ADDRESS_EIFP2_CONTRACT.balance > maxBalance) { ADDRESS_ADMIN.transfer(address(this).balance); return; } isResend = msg.sender == ADDRESS_EIFP2_CONTRACT; if(!ADDRESS_EIFP2_CONTRACT.call.value(address(this).balance)()) revert(); isResend = false; } }",
        "vulnerability": "Unauthorized fund transfer",
        "reason": "The contract allows ADDRESS_ADMIN to transfer the entire balance when ADDRESS_EIFP2_CONTRACT's balance exceeds the maxBalance, without proper access controls. This could lead to unauthorized fund transfers if ADDRESS_ADMIN's private key is compromised or if there's a misconfiguration.",
        "file_name": "0x20c476bb4c7aa64f919278fb9c09e880583beb4c.sol"
    },
    {
        "function_name": "fallback_function",
        "code": "function () external payable { if(msg.value == 0 || (msg.sender == ADDRESS_EIFP2_CONTRACT && msg.value >= 0.1 ether && !isResend)){ if(ADDRESS_EIFP2_CONTRACT.balance > maxBalance) { ADDRESS_ADMIN.transfer(address(this).balance); return; } isResend = msg.sender == ADDRESS_EIFP2_CONTRACT; if(!ADDRESS_EIFP2_CONTRACT.call.value(address(this).balance)()) revert(); isResend = false; } }",
        "vulnerability": "Unrestricted fallback function",
        "reason": "The fallback function lacks restrictions on who can send ether, making it possible for anyone to interact with it under certain conditions. This could lead to unintended behavior or enable attackers to manipulate the flow of funds by sending 0 ether transactions, especially when the `isResend` flag is involved.",
        "file_name": "0x20c476bb4c7aa64f919278fb9c09e880583beb4c.sol"
    }
]