[
    {
        "function_name": "initLockedBalance",
        "code": "function initLockedBalance() public returns (uint256) { require(totalLockedBalance == 0, \"Locker: There is no token stored\"); totalLockedBalance = APIX.balanceOf(address(this)); unlockBalancePerRound = totalLockedBalance / 4; emit APIXLock (totalLockedBalance); return totalLockedBalance; }",
        "vulnerability": "Multiple Initialization",
        "reason": "The function allows anyone to call it, and the only requirement is that `totalLockedBalance` is 0. This means that if the contract is reset or reused, someone could reinitialize the balance, leading to potential denial of service or manipulation of the contract state.",
        "file_name": "0x57acbe7bf11b8a4584403cc900e230a18a7ab138.sol"
    },
    {
        "function_name": "unlock",
        "code": "function unlock(uint8 round) public returns (bool) { require(totalLockedBalance > 0, \"Locker: There is no locked token\"); require(round == lastRound + 1, \"Locker: The round value is incorrect\"); require(round <= 4, \"Locker: The round value has exceeded the executable range\"); require(block.timestamp >= _getNextRoundTime(), \"Locker: It's not time to unlock yet\"); uint256 amount = _getNextRoundUnlock(); require(amount > 0, 'Locker: There is no unlockable token'); require(APIX.transfer(receiver, amount)); emit APIXUnlock(amount, receiver); lastRound = round; return true; }",
        "vulnerability": "Incorrect Token Transfer Authorization",
        "reason": "The function does not ensure that only authorized users can execute the unlock function. This could allow anyone to unlock the tokens and transfer them to the receiver address when the conditions are met, potentially allowing unauthorized actors to influence the contract's operation.",
        "file_name": "0x57acbe7bf11b8a4584403cc900e230a18a7ab138.sol"
    },
    {
        "function_name": "unlock",
        "code": "function unlock(uint8 round) public returns (bool) { require(totalLockedBalance > 0, \"Locker: There is no locked token\"); require(round == lastRound + 1, \"Locker: The round value is incorrect\"); require(round <= 4, \"Locker: The round value has exceeded the executable range\"); require(block.timestamp >= _getNextRoundTime(), \"Locker: It's not time to unlock yet\"); uint256 amount = _getNextRoundUnlock(); require(amount > 0, 'Locker: There is no unlockable token'); require(APIX.transfer(receiver, amount)); emit APIXUnlock(amount, receiver); lastRound = round; return true; }",
        "vulnerability": "Replay Attack Vulnerability",
        "reason": "The function logic does not prevent replay attacks effectively. If the `lastRound` variable is not updated successfully due to a transaction failure after the transfer, the function can potentially be called again for the same round, allowing for multiple transfers before `lastRound` is incremented.",
        "file_name": "0x57acbe7bf11b8a4584403cc900e230a18a7ab138.sol"
    }
]