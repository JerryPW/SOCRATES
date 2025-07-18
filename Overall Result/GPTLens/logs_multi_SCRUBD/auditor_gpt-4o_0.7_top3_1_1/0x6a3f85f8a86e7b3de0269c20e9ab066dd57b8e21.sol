[
    {
        "function_name": "TransferToAllAccounts",
        "code": "function TransferToAllAccounts() onlyOwner public { for(uint i=0;i<recieverList.length;i++) { recievermap[recieverList[i]].lastTransfer = false; address to = recievermap[recieverList[i]].useraddress; uint256 val = recievermap[recieverList[i]].useramount; if(val>0) { require(ERC20Basic(token).transfer(to, val)); emit TransferTo(to, val); recievermap[recieverList[i]].lastTransfer = true; } } }",
        "vulnerability": "Lack of gas limit on loop",
        "reason": "The function `TransferToAllAccounts` iterates over all users in `recieverList` without any gas limit checks. If the list grows too large, the transaction may run out of gas, resulting in a failure. This could potentially be exploited by an attacker by adding a large number of users to exhaust gas and prevent the execution of this function.",
        "file_name": "0x6a3f85f8a86e7b3de0269c20e9ab066dd57b8e21.sol"
    },
    {
        "function_name": "ResetAllAmount",
        "code": "function ResetAllAmount() onlyOwner public { for(uint i=0;i<recieverList.length;i++) { recievermap[recieverList[i]].useramount = 0; } }",
        "vulnerability": "Lack of gas limit on loop",
        "reason": "Similar to `TransferToAllAccounts`, the `ResetAllAmount` function iterates over all entries in `recieverList`. If the list is very large, this could lead to a transaction running out of gas. An attacker could add numerous entries to the list, causing the function to become unusable.",
        "file_name": "0x6a3f85f8a86e7b3de0269c20e9ab066dd57b8e21.sol"
    },
    {
        "function_name": "AddUser",
        "code": "function AddUser(string user,address add,uint amount) onlyOwner public { require(recievermap[user].useraddress == address(0)); recieverList.push(user); recievermap[user].useraddress = add; recievermap[user].useramount = amount; }",
        "vulnerability": "Potential DoS with large data",
        "reason": "The `AddUser` function allows the owner to add an unlimited number of users. If the owner (or an attacker who gains control of the owner account) adds a large number of users, it could lead to a situation where functions that iterate over `recieverList` become unusable due to high gas costs, effectively causing a Denial of Service.",
        "file_name": "0x6a3f85f8a86e7b3de0269c20e9ab066dd57b8e21.sol"
    }
]