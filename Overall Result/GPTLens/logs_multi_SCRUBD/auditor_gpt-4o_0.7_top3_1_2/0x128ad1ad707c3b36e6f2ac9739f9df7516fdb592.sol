[
    {
        "function_name": "change_owner",
        "code": "function change_owner(address new_owner) public onlyAuth { owner = new_owner; }",
        "vulnerability": "Unauthorized owner change",
        "reason": "The `change_owner` function allows any authorized user to change the contract owner. If an attacker gains access to an authorized account, they can change the owner and take control of the contract.",
        "file_name": "0x128ad1ad707c3b36e6f2ac9739f9df7516fdb592.sol"
    },
    {
        "function_name": "WithdrawProjectETH",
        "code": "function WithdrawProjectETH() public onlyAuth { uint256 amount = projectBalance; projectBalance = 0; address sender = msg.sender; (bool sent, ) = sender.call{value: (amount)}(\"\"); require(sent, \"withdraw failed\"); }",
        "vulnerability": "Unauthorized withdrawal of ETH",
        "reason": "The `WithdrawProjectETH` function allows any authorized user to withdraw all the ETH from the contract's project balance. If an attacker becomes authorized, they can drain the contract's ETH funds.",
        "file_name": "0x128ad1ad707c3b36e6f2ac9739f9df7516fdb592.sol"
    },
    {
        "function_name": "AvoidLocks",
        "code": "function AvoidLocks() public onlyAuth { (bool sent, ) = msg.sender.call{value: (address(this).balance)}(\"\"); require(sent); }",
        "vulnerability": "Unauthorized withdrawal of entire contract balance",
        "reason": "The `AvoidLocks` function allows any authorized user to withdraw the entire balance of the contract to their address. If an attacker gains authorization, they can drain the contract's entire ETH balance.",
        "file_name": "0x128ad1ad707c3b36e6f2ac9739f9df7516fdb592.sol"
    }
]