[
    {
        "function_name": "initLockedBalance",
        "code": "function initLockedBalance() public returns (uint256) { require(totalLockedBalance == 0, \"Locker: There is no token stored\"); totalLockedBalance = APIX.balanceOf(address(this)); unlockBalancePerRound = totalLockedBalance / 4; emit APIXLock (totalLockedBalance); return totalLockedBalance; }",
        "vulnerability": "Reinitialization of locked balance",
        "reason": "The function `initLockedBalance` can be called by anyone, and it does not verify the caller's identity or ensure that it's called in a safe context. This allows any user to call this function, potentially reinitializing the locked balance if the requirement on `totalLockedBalance` being zero is somehow met by transferring out tokens. This could lead to incorrect locking logic or possible further unlocking issues.",
        "file_name": "0x57acbe7bf11b8a4584403cc900e230a18a7ab138.sol"
    },
    {
        "function_name": "unlock",
        "code": "function unlock(uint8 round) public returns (bool) { require(totalLockedBalance > 0, \"Locker: There is no locked token\"); require(round == lastRound + 1, \"Locker: The round value is incorrect\"); require(round <= 4, \"Locker: The round value has exceeded the executable range\"); require(block.timestamp >= _getNextRoundTime(), \"Locker: It's not time to unlock yet\"); uint256 amount = _getNextRoundUnlock(); require(amount > 0, 'Locker: There is no unlockable token'); require(APIX.transfer(receiver, amount)); emit APIXUnlock(amount, receiver); lastRound = round; return true; }",
        "vulnerability": "Unauthorized access to unlock function",
        "reason": "The `unlock` function is publicly accessible and can be called by anyone. There are no checks to ensure that only an authorized user or contract can trigger the unlock process. This means any user could potentially call this function at the correct time and transfer the unlocked tokens to the designated receiver address, possibly disrupting the intended token distribution process.",
        "file_name": "0x57acbe7bf11b8a4584403cc900e230a18a7ab138.sol"
    },
    {
        "function_name": "initLockedBalance",
        "code": "function initLockedBalance() public returns (uint256) { require(totalLockedBalance == 0, \"Locker: There is no token stored\"); totalLockedBalance = APIX.balanceOf(address(this)); unlockBalancePerRound = totalLockedBalance / 4; emit APIXLock (totalLockedBalance); return totalLockedBalance; }",
        "vulnerability": "Integer division causing loss of precision",
        "reason": "The division operation in `unlockBalancePerRound = totalLockedBalance / 4;` could lead to a loss of precision if `totalLockedBalance` is not perfectly divisible by 4. This could result in a small remainder of tokens that are never unlocked, which might not be catastrophic but could lead to discrepancies in the expected token distribution.",
        "file_name": "0x57acbe7bf11b8a4584403cc900e230a18a7ab138.sol"
    }
]