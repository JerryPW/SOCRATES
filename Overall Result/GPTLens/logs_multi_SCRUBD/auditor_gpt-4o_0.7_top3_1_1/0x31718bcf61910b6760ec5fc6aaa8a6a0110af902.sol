[
    {
        "function_name": "pepFarm",
        "code": "function pepFarm() external { for (uint8 i = 0; i < 100; i++) { CornFarm(shop).buyObject(this); } workDone[msg.sender] = workDone[msg.sender].add(uint256(100 ether)); }",
        "vulnerability": "Potential DoS with gas limit",
        "reason": "The function 'pepFarm' contains a loop that iterates 100 times, calling an external contract function 'buyObject'. If the 'buyObject' function is gas-intensive, this could lead to a denial of service as the transaction might run out of gas and revert. This makes it difficult for users to execute this function and can be exploited by attackers to prevent legitimate users from participating.",
        "file_name": "0x31718bcf61910b6760ec5fc6aaa8a6a0110af902.sol"
    },
    {
        "function_name": "reapFarm",
        "code": "function reapFarm() external { require(workDone[msg.sender] > 0); Corn(object).transfer(msg.sender, workDone[msg.sender]); workDone[msg.sender] = 0; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The 'reapFarm' function transfers tokens to the caller before setting their 'workDone' to zero. This order of operations allows a reentrancy attack: an attacker could call 'reapFarm' and within the execution of 'transfer', call 'reapFarm' again before 'workDone' is set to zero, thus draining the contract of tokens. To mitigate, state changes should be done before external calls.",
        "file_name": "0x31718bcf61910b6760ec5fc6aaa8a6a0110af902.sol"
    },
    {
        "function_name": "pepFarm",
        "code": "function pepFarm() external { for (uint8 i = 0; i < 100; i++) { CornFarm(shop).buyObject(this); } workDone[msg.sender] = workDone[msg.sender].add(uint256(100 ether)); }",
        "vulnerability": "Arbitrary call to external contract",
        "reason": "The 'pepFarm' function calls 'buyObject' on an external contract 'CornFarm', which could be controlled by an attacker. This allows the attacker to execute arbitrary code within 'buyObject', potentially causing side effects or unexpected behavior in the 'PepFarmer' contract. There is no validation on the execution or response from 'buyObject', making this a severe risk.",
        "file_name": "0x31718bcf61910b6760ec5fc6aaa8a6a0110af902.sol"
    }
]