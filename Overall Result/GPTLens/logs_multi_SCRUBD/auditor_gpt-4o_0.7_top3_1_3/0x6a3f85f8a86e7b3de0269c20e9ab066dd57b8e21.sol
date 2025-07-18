[
    {
        "function_name": "TransferToAllAccounts",
        "code": "function TransferToAllAccounts() onlyOwner public { for(uint i=0;i<recieverList.length;i++) { recievermap[recieverList[i]].lastTransfer = false; address to = recievermap[recieverList[i]].useraddress; uint256 val = recievermap[recieverList[i]].useramount; if(val>0) { require(ERC20Basic(token).transfer(to, val)); emit TransferTo(to, val); recievermap[recieverList[i]].lastTransfer = true; } } }",
        "vulnerability": "Potential Out-of-Gas Error",
        "reason": "The function iterates over the entire 'recieverList' array and performs a transfer for each entry. This can lead to an out-of-gas error if the array grows too large, causing the transaction to fail and potentially locking the contract's functionality until the list is reduced.",
        "file_name": "0x6a3f85f8a86e7b3de0269c20e9ab066dd57b8e21.sol"
    },
    {
        "function_name": "ResetAllAmount",
        "code": "function ResetAllAmount() onlyOwner public { for(uint i=0;i<recieverList.length;i++) { recievermap[recieverList[i]].useramount = 0; } }",
        "vulnerability": "Potential Out-of-Gas Error",
        "reason": "Similar to 'TransferToAllAccounts', this function iterates over the 'recieverList' array and sets all user amounts to zero. If the array is large, the transaction may run out of gas, preventing the function from executing successfully.",
        "file_name": "0x6a3f85f8a86e7b3de0269c20e9ab066dd57b8e21.sol"
    },
    {
        "function_name": "AddUser",
        "code": "function AddUser(string user,address add,uint amount) onlyOwner public { require(recievermap[user].useraddress == address(0)); recieverList.push(user); recievermap[user].useraddress = add; recievermap[user].useramount = amount; }",
        "vulnerability": "Unbounded Data Growth",
        "reason": "The 'AddUser' function allows the owner to add new entries to the 'recieverList' array without any restrictions. This can lead to unbounded growth of the array, increasing the risk of out-of-gas errors in functions that iterate over this array.",
        "file_name": "0x6a3f85f8a86e7b3de0269c20e9ab066dd57b8e21.sol"
    }
]