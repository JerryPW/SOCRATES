[
    {
        "function_name": "pepFarm",
        "code": "function pepFarm() external { for (uint8 i = 0; i < 100; i++) { CornFarm(shop).buyObject(this); } workDone[msg.sender] = workDone[msg.sender].add(uint256(100 ether)); }",
        "vulnerability": "Uncontrolled External Call",
        "reason": "The function pepFarm calls the external contract CornFarm's buyObject function 100 times without any checks or restrictions. If the shop address is a malicious contract, it could re-enter the pepFarm function, leading to potential reentrancy attacks or unexpected behavior that could deplete resources or cause denial of service.",
        "file_name": "0x31718bcf61910b6760ec5fc6aaa8a6a0110af902.sol"
    },
    {
        "function_name": "pepFarm",
        "code": "function pepFarm() external { for (uint8 i = 0; i < 100; i++) { CornFarm(shop).buyObject(this); } workDone[msg.sender] = workDone[msg.sender].add(uint256(100 ether)); }",
        "vulnerability": "Gas Limit and Out-of-Gas Exception",
        "reason": "The for loop executes 100 iterations, each calling an external contract. If buyObject is complex or if the transaction has a strict gas limit, this could lead to an out-of-gas exception, resulting in a failed transaction. This vulnerability could be exploited by an attacker to waste gas and prevent other operations from executing successfully.",
        "file_name": "0x31718bcf61910b6760ec5fc6aaa8a6a0110af902.sol"
    },
    {
        "function_name": "reapFarm",
        "code": "function reapFarm() external { require(workDone[msg.sender] > 0); Corn(object).transfer(msg.sender, workDone[msg.sender]); workDone[msg.sender] = 0; }",
        "vulnerability": "Lack of Safe Transfer Checks",
        "reason": "The function reapFarm does not check the return value of the Corn object's transfer function. If the transfer fails (for example, if the Corn contract is malicious or the balance is insufficient), the function will still proceed to set workDone[msg.sender] to 0, potentially resulting in a loss of 'workDone' credits for the user without receiving any tokens. An attacker could exploit this by crafting a situation where transfers fail, causing users to inadvertently lose their accrued work.",
        "file_name": "0x31718bcf61910b6760ec5fc6aaa8a6a0110af902.sol"
    }
]