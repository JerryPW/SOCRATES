[
    {
        "function_name": "change_owner",
        "code": "function change_owner(address new_owner) public onlyAuth { owner = new_owner; }",
        "vulnerability": "Potential unauthorized ownership change",
        "reason": "The function allows any authorized address to change the ownership of the contract. If an attacker gains authorization (possibly through compromised credentials or mismanagement), they can call this function and transfer ownership to themselves, giving them full control over the contract.",
        "file_name": "0x128ad1ad707c3b36e6f2ac9739f9df7516fdb592.sol"
    },
    {
        "function_name": "WithdrawProjectETH",
        "code": "function WithdrawProjectETH() public onlyAuth { uint256 amount = projectBalance; projectBalance = 0; address sender = msg.sender; (bool sent, ) = sender.call{value: (amount)}(\"\"); require(sent, \"withdraw failed\"); }",
        "vulnerability": "Potential fund drainage by authorized users",
        "reason": "This function allows any authorized user to withdraw the entire projectBalance. If an attacker becomes authorized, they can drain all funds in the projectBalance by calling this function, leading to loss of funds for legitimate users or stakeholders.",
        "file_name": "0x128ad1ad707c3b36e6f2ac9739f9df7516fdb592.sol"
    },
    {
        "function_name": "AvoidLocks",
        "code": "function AvoidLocks() public onlyAuth { (bool sent, ) = msg.sender.call{value: (address(this).balance)}(\"\"); require(sent); }",
        "vulnerability": "Complete contract balance withdrawal by authorized users",
        "reason": "This function allows any authorized user to withdraw the entire balance of the contract to their address. This could be exploited by an attacker with authorization to completely drain the contract's balance, potentially causing a loss of all funds held by the contract.",
        "file_name": "0x128ad1ad707c3b36e6f2ac9739f9df7516fdb592.sol"
    }
]