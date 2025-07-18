[
    {
        "function_name": "lock",
        "code": "function lock(uint256 lockTime) public onlyOwner returns (bool){ require(!isLocked); require(tokenBalance() > 0); start_time = now; end_time = lockTime; isLocked = true; }",
        "vulnerability": "Lock end time can be set in the past",
        "reason": "The function `lock` allows the owner to set `end_time` to any arbitrary value, including a time in the past, because `end_time = lockTime;` does not validate if `lockTime` is greater than `start_time`. This means the lock can be immediately considered over, allowing the owner to release tokens without waiting for the intended lock period.",
        "file_name": "0x7e433aee8090ee2c8ee3e6aaedfde1b76d776ace.sol"
    },
    {
        "function_name": "release",
        "code": "function release() onlyOwner public{ require(isLocked); require(!isReleased); require(lockOver()); uint256 token_amount = tokenBalance(); token_reward.transfer( beneficiary, token_amount); emit TokenReleased(beneficiary, token_amount); isReleased = true; }",
        "vulnerability": "Unauthorized token release by the contract owner",
        "reason": "The `release` function can only be called by the owner, which means the owner has full control over releasing the tokens. If the owner is compromised or malicious, they can release the tokens to the specified `beneficiary` address after the lock time, even if it was not the intended behavior.",
        "file_name": "0x7e433aee8090ee2c8ee3e6aaedfde1b76d776ace.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address newOwner) onlyOwner public { require(newOwner != address(0)); emit OwnershipTransferred(owner, newOwner); owner = newOwner; }",
        "vulnerability": "Ownership can be transferred to an arbitrary address",
        "reason": "The `transferOwnership` function allows the current owner to transfer ownership to any address, including a contract that may not be able to manage ownership correctly or an address controlled by an attacker. This could lead to potential loss of control over the contract.",
        "file_name": "0x7e433aee8090ee2c8ee3e6aaedfde1b76d776ace.sol"
    }
]