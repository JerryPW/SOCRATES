[
    {
        "function_name": "pepFarm",
        "code": "function pepFarm() external { for (uint8 i = 0; i < 100; i++) { CornFarm(shop).buyObject(this); } workDone[msg.sender] = workDone[msg.sender].add(uint256(100 ether)); }",
        "vulnerability": "Unrestricted call to external contract",
        "reason": "The pepFarm function calls the buyObject function of an external CornFarm contract in a loop without any checks or restrictions. This could lead to re-entrancy attacks or unexpected behavior if the external contract is malicious or not functioning as intended. An attacker could potentially exploit this by deploying a malicious contract at the 'shop' address and manipulating the behavior of the loot function.",
        "file_name": "0x31718bcf61910b6760ec5fc6aaa8a6a0110af902.sol"
    },
    {
        "function_name": "reapFarm",
        "code": "function reapFarm() external { require(workDone[msg.sender] > 0); Corn(object).transfer(msg.sender, workDone[msg.sender]); workDone[msg.sender] = 0; }",
        "vulnerability": "Lack of reentrancy protection",
        "reason": "The reapFarm function transfers tokens and then sets the workDone mapping to 0. Since there is no reentrancy protection, an attacker could potentially call reapFarm in a reentrant way, causing the transfer function to be called multiple times before workDone is set to 0, effectively draining tokens from the contract.",
        "file_name": "0x31718bcf61910b6760ec5fc6aaa8a6a0110af902.sol"
    },
    {
        "function_name": "pepFarm",
        "code": "function pepFarm() external { for (uint8 i = 0; i < 100; i++) { CornFarm(shop).buyObject(this); } workDone[msg.sender] = workDone[msg.sender].add(uint256(100 ether)); }",
        "vulnerability": "Integer overflow in workDone calculation",
        "reason": "The add operation on the workDone mapping increments the user's work done by a fixed large amount (100 ether). Although SafeMath is used, the repeated calling of pepFarm by the same user could potentially lead to an integer overflow in older versions of Solidity where SafeMath is not adequately protective. This could result in incorrect bookkeeping of workDone, allowing manipulation of the transfer amount in reapFarm.",
        "file_name": "0x31718bcf61910b6760ec5fc6aaa8a6a0110af902.sol"
    }
]