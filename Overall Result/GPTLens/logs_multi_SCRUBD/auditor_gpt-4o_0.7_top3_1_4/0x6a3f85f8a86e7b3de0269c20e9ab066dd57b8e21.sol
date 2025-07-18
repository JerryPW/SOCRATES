[
    {
        "function_name": "TransferToAllAccounts",
        "code": "function TransferToAllAccounts() onlyOwner public { for(uint i=0;i<recieverList.length;i++) { recievermap[recieverList[i]].lastTransfer = false; address to = recievermap[recieverList[i]].useraddress; uint256 val = recievermap[recieverList[i]].useramount; if(val>0) { require(ERC20Basic(token).transfer(to, val)); emit TransferTo(to, val); recievermap[recieverList[i]].lastTransfer = true; } } }",
        "vulnerability": "Lack of gas limit in unbounded loop",
        "reason": "The function TransferToAllAccounts iterates over the entire recieverList array and attempts to transfer tokens to each address. If the recieverList array grows too large, this function could run out of gas and fail to execute completely, leading to potential denial of service. An attacker could exploit this by adding numerous users to exhaust the gas limit.",
        "file_name": "0x6a3f85f8a86e7b3de0269c20e9ab066dd57b8e21.sol"
    },
    {
        "function_name": "ResetAllAmount",
        "code": "function ResetAllAmount() onlyOwner public { for(uint i=0;i<recieverList.length;i++) { recievermap[recieverList[i]].useramount = 0; } }",
        "vulnerability": "Lack of gas limit in unbounded loop",
        "reason": "Similar to TransferToAllAccounts, ResetAllAmount iterates over the recieverList array without any gas limit considerations. An attacker can exploit this by flooding the recieverList with entries, which can lead to the function exceeding the block gas limit and failing, thus allowing denial of service on resetting amounts.",
        "file_name": "0x6a3f85f8a86e7b3de0269c20e9ab066dd57b8e21.sol"
    },
    {
        "function_name": "AddUser",
        "code": "function AddUser(string user,address add,uint amount) onlyOwner public { require(recievermap[user].useraddress == address(0)); recieverList.push(user); recievermap[user].useraddress = add; recievermap[user].useramount = amount; }",
        "vulnerability": "Potential out-of-gas issue due to string keys",
        "reason": "The use of strings as keys in the recievermap mapping can lead to increased gas costs, especially if the strings are lengthy or numerous. This can lead to out-of-gas errors when manipulating the mapping or iterating over the recieverList, particularly in functions like TransferToAllAccounts or ResetAllAmount, which can result in a denial of service.",
        "file_name": "0x6a3f85f8a86e7b3de0269c20e9ab066dd57b8e21.sol"
    }
]