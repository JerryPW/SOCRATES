[
    {
        "function_name": "TransferToAllAccounts",
        "vulnerability": "Lack of gas limit on loop",
        "criticism": "The reasoning is correct. The function does not have a gas limit check and could potentially fail if the list grows too large. However, the severity is moderate because it depends on the size of the list and the gas limit set for the transaction. The profitability is low because an external attacker cannot profit from this vulnerability.",
        "correctness": 7,
        "severity": 5,
        "profitability": 0,
        "reason": "The function `TransferToAllAccounts` iterates over all users in `recieverList` without any gas limit checks. If the list grows too large, the transaction may run out of gas, resulting in a failure. This could potentially be exploited by an attacker by adding a large number of users to exhaust gas and prevent the execution of this function.",
        "code": "function TransferToAllAccounts() onlyOwner public { for(uint i=0;i<recieverList.length;i++) { recievermap[recieverList[i]].lastTransfer = false; address to = recievermap[recieverList[i]].useraddress; uint256 val = recievermap[recieverList[i]].useramount; if(val>0) { require(ERC20Basic(token).transfer(to, val)); emit TransferTo(to, val); recievermap[recieverList[i]].lastTransfer = true; } } }",
        "file_name": "0x6a3f85f8a86e7b3de0269c20e9ab066dd57b8e21.sol"
    },
    {
        "function_name": "ResetAllAmount",
        "vulnerability": "Lack of gas limit on loop",
        "criticism": "The reasoning is correct. The function does not have a gas limit check and could potentially fail if the list grows too large. However, the severity is moderate because it depends on the size of the list and the gas limit set for the transaction. The profitability is low because an external attacker cannot profit from this vulnerability.",
        "correctness": 7,
        "severity": 5,
        "profitability": 0,
        "reason": "Similar to `TransferToAllAccounts`, the `ResetAllAmount` function iterates over all entries in `recieverList`. If the list is very large, this could lead to a transaction running out of gas. An attacker could add numerous entries to the list, causing the function to become unusable.",
        "code": "function ResetAllAmount() onlyOwner public { for(uint i=0;i<recieverList.length;i++) { recievermap[recieverList[i]].useramount = 0; } }",
        "file_name": "0x6a3f85f8a86e7b3de0269c20e9ab066dd57b8e21.sol"
    },
    {
        "function_name": "AddUser",
        "vulnerability": "Potential DoS with large data",
        "criticism": "The reasoning is correct. The function allows the owner to add an unlimited number of users, which could potentially lead to a Denial of Service if the list grows too large. However, the severity is moderate because it depends on the owner's actions. The profitability is low because an external attacker cannot profit from this vulnerability unless they gain control of the owner account.",
        "correctness": 7,
        "severity": 5,
        "profitability": 1,
        "reason": "The `AddUser` function allows the owner to add an unlimited number of users. If the owner (or an attacker who gains control of the owner account) adds a large number of users, it could lead to a situation where functions that iterate over `recieverList` become unusable due to high gas costs, effectively causing a Denial of Service.",
        "code": "function AddUser(string user,address add,uint amount) onlyOwner public { require(recievermap[user].useraddress == address(0)); recieverList.push(user); recievermap[user].useraddress = add; recievermap[user].useramount = amount; }",
        "file_name": "0x6a3f85f8a86e7b3de0269c20e9ab066dd57b8e21.sol"
    }
]