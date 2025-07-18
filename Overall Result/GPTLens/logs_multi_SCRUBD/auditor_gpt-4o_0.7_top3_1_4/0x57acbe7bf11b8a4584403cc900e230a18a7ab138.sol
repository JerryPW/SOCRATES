[
    {
        "function_name": "initLockedBalance",
        "code": "function initLockedBalance() public returns (uint256) { require(totalLockedBalance == 0, \"Locker: There is no token stored\"); totalLockedBalance = APIX.balanceOf(address(this)); unlockBalancePerRound = totalLockedBalance / 4; emit APIXLock (totalLockedBalance); return totalLockedBalance; }",
        "vulnerability": "Incorrect require condition",
        "reason": "The require statement uses an incorrect error message that suggests there are no tokens stored when it should check if the totalLockedBalance has already been initialized. This might confuse the users or developers, leading to improper usage or misinterpretation of the contract's state.",
        "file_name": "0x57acbe7bf11b8a4584403cc900e230a18a7ab138.sol"
    },
    {
        "function_name": "unlock",
        "code": "function unlock(uint8 round) public returns (bool) { require(totalLockedBalance > 0, \"Locker: There is no locked token\"); require(round == lastRound + 1, \"Locker: The round value is incorrect\"); require(round <= 4, \"Locker: The round value has exceeded the executable range\"); require(block.timestamp >= _getNextRoundTime(), \"Locker: It's not time to unlock yet\"); uint256 amount = _getNextRoundUnlock(); require(amount > 0, 'Locker: There is no unlockable token'); require(APIX.transfer(receiver, amount)); emit APIXUnlock(amount, receiver); lastRound = round; return true; }",
        "vulnerability": "Lock bypass for last round",
        "reason": "The unlock function allows unlocking all remaining tokens in the last round regardless of the intended schedule. This is due to the logic in _getNextRoundUnlock, which allows unlocking all remaining tokens if round >= 4. An attacker could exploit this by advancing rounds prematurely, provided they control the timing and sequence of calls.",
        "file_name": "0x57acbe7bf11b8a4584403cc900e230a18a7ab138.sol"
    },
    {
        "function_name": "unlock",
        "code": "function unlock(uint8 round) public returns (bool) { require(totalLockedBalance > 0, \"Locker: There is no locked token\"); require(round == lastRound + 1, \"Locker: The round value is incorrect\"); require(round <= 4, \"Locker: The round value has exceeded the executable range\"); require(block.timestamp >= _getNextRoundTime(), \"Locker: It's not time to unlock yet\"); uint256 amount = _getNextRoundUnlock(); require(amount > 0, 'Locker: There is no unlockable token'); require(APIX.transfer(receiver, amount)); emit APIXUnlock(amount, receiver); lastRound = round; return true; }",
        "vulnerability": "Improper access control",
        "reason": "The unlock function is publicly accessible, allowing any user to trigger the unlocking process. This could lead to a scenario where unauthorized users execute the unlock function prematurely or at a time that the original creator of the contract did not intend, potentially leading to unexpected token distribution.",
        "file_name": "0x57acbe7bf11b8a4584403cc900e230a18a7ab138.sol"
    }
]