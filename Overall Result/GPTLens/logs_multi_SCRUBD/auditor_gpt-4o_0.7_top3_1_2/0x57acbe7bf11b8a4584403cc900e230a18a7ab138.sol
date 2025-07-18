[
    {
        "function_name": "initLockedBalance",
        "code": "function initLockedBalance() public returns (uint256) { require(totalLockedBalance == 0, \"Locker: There is no token stored\"); totalLockedBalance = APIX.balanceOf(address(this)); unlockBalancePerRound = totalLockedBalance / 4; emit APIXLock (totalLockedBalance); return totalLockedBalance; }",
        "vulnerability": "Reinitialization of Locked Balance",
        "reason": "The function 'initLockedBalance' can be called by anyone at any time as long as 'totalLockedBalance' is zero. This allows an attacker to potentially reinitialize the locked balance after it has been unlocked and drained, enabling them to reset the contract state and disrupt the expected flow of token distribution.",
        "file_name": "0x57acbe7bf11b8a4584403cc900e230a18a7ab138.sol"
    },
    {
        "function_name": "unlock",
        "code": "function unlock(uint8 round) public returns (bool) { require(totalLockedBalance > 0, \"Locker: There is no locked token\"); require(round == lastRound + 1, \"Locker: The round value is incorrect\"); require(round <= 4, \"Locker: The round value has exceeded the executable range\"); require(block.timestamp >= _getNextRoundTime(), \"Locker: It's not time to unlock yet\"); uint256 amount = _getNextRoundUnlock(); require(amount > 0, 'Locker: There is no unlockable token'); require(APIX.transfer(receiver, amount)); emit APIXUnlock(amount, receiver); lastRound = round; return true; }",
        "vulnerability": "Unauthorized Access to Unlock Function",
        "reason": "The 'unlock' function can be called by anyone, not just the contract owner or a specific authorized party. This means an attacker can trigger the unlocking process at the valid time, potentially redirecting unlocked tokens if they have control over the 'receiver' address or exploit other vulnerabilities related to its execution.",
        "file_name": "0x57acbe7bf11b8a4584403cc900e230a18a7ab138.sol"
    },
    {
        "function_name": "constructor",
        "code": "constructor (address _APIXContractAddress, address _receiver, uint256 _unlockStartTime, uint32 _unlockStartYear) public { APIX = IERC20(_APIXContractAddress); receiver = _receiver; unlockStartTime = _unlockStartTime; unlockStartYear = _unlockStartYear; }",
        "vulnerability": "Arbitrary Receiver Address",
        "reason": "The constructor allows the arbitrary setting of the 'receiver' address without any access control. This means that during deployment, an attacker can specify their own address as the receiver, ensuring that all unlocked tokens are transferred to them instead of the intended recipient.",
        "file_name": "0x57acbe7bf11b8a4584403cc900e230a18a7ab138.sol"
    }
]