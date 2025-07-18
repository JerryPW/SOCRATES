[
    {
        "function_name": "pepFarm",
        "code": "function pepFarm() external { for (uint8 i = 0; i < 100; i++) { CornFarm(shop).buyObject(this); } workDone[msg.sender] = workDone[msg.sender].add(uint256(100 ether)); }",
        "vulnerability": "Arbitrary Execution via External Call",
        "reason": "The function repeatedly calls an external contract (CornFarm) without any limit or checks. If the external contract is malicious or compromised, it could lead to reentrancy attacks or other undesired behaviors. The for loop allows calling the external contract 100 times, which could be exploited for gas exhaustion or unintended execution paths.",
        "file_name": "0x31718bcf61910b6760ec5fc6aaa8a6a0110af902.sol"
    },
    {
        "function_name": "pepFarm",
        "code": "function pepFarm() external { for (uint8 i = 0; i < 100; i++) { CornFarm(shop).buyObject(this); } workDone[msg.sender] = workDone[msg.sender].add(uint256(100 ether)); }",
        "vulnerability": "Overflow in workDone Calculation",
        "reason": "The workDone mapping for the sender is increased by a hardcoded value of 100 ether. While SafeMath is used, the logic of assigning a fixed large amount without any condition or input could be abused by repeatedly calling pepFarm. This allows users to inflate their workDone balance, potentially draining the contract when they call reapFarm.",
        "file_name": "0x31718bcf61910b6760ec5fc6aaa8a6a0110af902.sol"
    },
    {
        "function_name": "reapFarm",
        "code": "function reapFarm() external { require(workDone[msg.sender] > 0); Corn(object).transfer(msg.sender, workDone[msg.sender]); workDone[msg.sender] = 0; }",
        "vulnerability": "Potential for Unchecked Transfer of Tokens",
        "reason": "In reapFarm, the amount of tokens transferred is determined by the workDone mapping. Since the pepFarm function allows arbitrary increment of workDone without cost or limit, an attacker can repeatedly call pepFarm to inflate their balance and then call reapFarm to transfer an excessive amount of tokens to themselves. There is no check on the balance of the contract, allowing for potential draining of all available tokens.",
        "file_name": "0x31718bcf61910b6760ec5fc6aaa8a6a0110af902.sol"
    }
]