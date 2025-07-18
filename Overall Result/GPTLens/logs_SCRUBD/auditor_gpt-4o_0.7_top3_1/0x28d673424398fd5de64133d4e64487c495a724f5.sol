[
    {
        "function_name": "fallback",
        "code": "function () external payable { msg.sender.send(address(this).balance-msg.value); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function sends Ether back to the sender before updating any state, allowing an attacker to repeatedly call the contract and drain its balance before the original transaction completes.",
        "file_name": "0x28d673424398fd5de64133d4e64487c495a724f5.sol"
    },
    {
        "function_name": "fallback",
        "code": "function () external payable { msg.sender.send(address(this).balance-msg.value); }",
        "vulnerability": "Denial of service",
        "reason": "The use of 'send' limits the gas forwarded to 2300, which is not enough if the recipient is a contract with a fallback function that requires more gas. This can cause the transaction to fail and prevent legitimate users from interacting with the contract.",
        "file_name": "0x28d673424398fd5de64133d4e64487c495a724f5.sol"
    },
    {
        "function_name": "fallback",
        "code": "function () external payable { msg.sender.send(address(this).balance-msg.value); }",
        "vulnerability": "Insecure Ether transfer logic",
        "reason": "The contract attempts to send the entire balance minus the sent amount back to the sender, which might not be the intended behavior. An attacker could exploit this logic by sending a small amount of Ether, causing the contract to attempt to send nearly its entire balance to the attacker.",
        "file_name": "0x28d673424398fd5de64133d4e64487c495a724f5.sol"
    }
]