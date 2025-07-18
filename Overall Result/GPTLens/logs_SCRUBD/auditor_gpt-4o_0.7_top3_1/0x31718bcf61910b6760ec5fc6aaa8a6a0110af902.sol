[
    {
        "function_name": "pepFarm",
        "code": "function pepFarm() external { for (uint8 i = 0; i < 100; i++) { CornFarm(shop).buyObject(this); } workDone[msg.sender] = workDone[msg.sender].add(uint256(100 ether)); }",
        "vulnerability": "Potential Denial of Service",
        "reason": "The pepFarm function contains a loop that calls an external contract function (CornFarm's buyObject) 100 times. If the buyObject function has any complex logic or gas-intensive operations, it can lead to running out of gas, causing the function to fail and potentially leading to a denial of service. This could prevent users from executing the function successfully.",
        "file_name": "0x31718bcf61910b6760ec5fc6aaa8a6a0110af902.sol"
    },
    {
        "function_name": "pepFarm",
        "code": "function pepFarm() external { for (uint8 i = 0; i < 100; i++) { CornFarm(shop).buyObject(this); } workDone[msg.sender] = workDone[msg.sender].add(uint256(100 ether)); }",
        "vulnerability": "Lack of Access Control",
        "reason": "The pepFarm function does not have any access control mechanisms, allowing any user to call it. Each call to this function increases the workDone balance of the caller by 100 ether, which can later be redeemed for tokens in the reapFarm function. This allows attackers to repeatedly call pepFarm, increasing their balance indefinitely and draining tokens from the contract.",
        "file_name": "0x31718bcf61910b6760ec5fc6aaa8a6a0110af902.sol"
    },
    {
        "function_name": "reapFarm",
        "code": "function reapFarm() external { require(workDone[msg.sender] > 0); Corn(object).transfer(msg.sender, workDone[msg.sender]); workDone[msg.sender] = 0; }",
        "vulnerability": "Reentrancy Attack",
        "reason": "The reapFarm function is vulnerable to reentrancy attacks as it transfers tokens to the caller before resetting their workDone balance. An attacker could exploit this by re-entering the reapFarm function during the token transfer, allowing them to drain more tokens than intended by repeatedly calling the function before the workDone balance is set to zero.",
        "file_name": "0x31718bcf61910b6760ec5fc6aaa8a6a0110af902.sol"
    }
]