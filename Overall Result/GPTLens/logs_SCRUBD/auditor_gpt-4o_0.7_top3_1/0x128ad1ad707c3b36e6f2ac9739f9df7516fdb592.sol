[
    {
        "function_name": "change_owner",
        "code": "function change_owner(address new_owner) public onlyAuth { owner = new_owner; }",
        "vulnerability": "Unauthorized owner change",
        "reason": "The `change_owner` function allows an authorized user to change the contract owner. If an attacker gains access to an authorized account or if there is a bug allowing unauthorized access, the attacker could change the owner to themselves, giving them complete control over the contract.",
        "file_name": "0x128ad1ad707c3b36e6f2ac9739f9df7516fdb592.sol"
    },
    {
        "function_name": "WithdrawProjectETH",
        "code": "function WithdrawProjectETH() public onlyAuth { uint256 amount = projectBalance; projectBalance = 0; address sender = msg.sender; (bool sent, ) = sender.call{value: (amount)}(\"\"); require(sent, \"withdraw failed\"); }",
        "vulnerability": "Potential fund withdrawal by unauthorized user",
        "reason": "The `WithdrawProjectETH` function allows any authorized user to withdraw all ETH accumulated in the contract. If an attacker gains authorization, they can withdraw all ETH, resulting in a loss of funds. This vulnerability is exacerbated by the lack of checks to ensure funds are only withdrawn by intended parties.",
        "file_name": "0x128ad1ad707c3b36e6f2ac9739f9df7516fdb592.sol"
    },
    {
        "function_name": "AvoidLocks",
        "code": "function AvoidLocks() public onlyAuth { (bool sent, ) = msg.sender.call{value: (address(this).balance)}(\"\"); require(sent); }",
        "vulnerability": "Unrestricted ETH withdrawal",
        "reason": "The `AvoidLocks` function allows any authorized user to withdraw the entire ETH balance of the contract. This can be exploited if an attacker gains access to an authorized account, allowing them to empty the contract of all ETH, leading to a complete loss of funds.",
        "file_name": "0x128ad1ad707c3b36e6f2ac9739f9df7516fdb592.sol"
    }
]