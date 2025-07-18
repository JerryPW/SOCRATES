[
    {
        "function_name": "change_owner",
        "code": "function change_owner(address new_owner) public onlyAuth { owner = new_owner; }",
        "vulnerability": "Authorization bypass",
        "reason": "The `onlyAuth` modifier is used to protect the `change_owner` function. However, the `onlyAuth` modifier checks if the caller is either in the `is_auth` mapping or is the current owner. If an attacker can add their address to the `is_auth` mapping using `set_authorized`, they can call `change_owner` and take ownership of the contract.",
        "file_name": "0x128ad1ad707c3b36e6f2ac9739f9df7516fdb592.sol"
    },
    {
        "function_name": "WithdrawProjectETH",
        "code": "function WithdrawProjectETH() public onlyAuth { uint256 amount = projectBalance; projectBalance = 0; address sender = msg.sender; (bool sent, ) = sender.call{value: (amount)}(\"\"); require(sent, \"withdraw failed\"); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function `WithdrawProjectETH` transfers ETH to the caller without using a reentrancy guard, allowing for potential reentrancy attacks. An attacker could repeatedly call this function via a fallback function to drain the contract\u2019s ETH balance before `projectBalance` is reset to 0.",
        "file_name": "0x128ad1ad707c3b36e6f2ac9739f9df7516fdb592.sol"
    },
    {
        "function_name": "AvoidLocks",
        "code": "function AvoidLocks() public onlyAuth { (bool sent, ) = msg.sender.call{value: (address(this).balance)}(\"\"); require(sent); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `AvoidLocks` function transfers the entire ETH balance of the contract to the caller without using a reentrancy guard. This permits reentrancy attacks where an attacker could call this function multiple times before the internal balance is updated, draining the contract's balance.",
        "file_name": "0x128ad1ad707c3b36e6f2ac9739f9df7516fdb592.sol"
    }
]