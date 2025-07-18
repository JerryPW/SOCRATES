[
    {
        "function_name": "TransferToAllAccounts",
        "code": "function TransferToAllAccounts() onlyOwner public { for(uint i=0;i<recieverList.length;i++) { recievermap[recieverList[i]].lastTransfer = false; address to = recievermap[recieverList[i]].useraddress; uint256 val = recievermap[recieverList[i]].useramount; if(val>0) { require(ERC20Basic(token).transfer(to, val)); emit TransferTo(to, val); recievermap[recieverList[i]].lastTransfer = true; } } }",
        "vulnerability": "Potential Out-of-Gas Exception",
        "reason": "This function iterates over the entire `recieverList` array and attempts to transfer tokens to each address. If `recieverList` is large, the execution could exceed the block gas limit, causing the transaction to fail. This could prevent any tokens from being transferred, and the function does not revert partial transfers if it runs out of gas mid-execution.",
        "file_name": "0x6a3f85f8a86e7b3de0269c20e9ab066dd57b8e21.sol"
    },
    {
        "function_name": "ResetAllAmount",
        "code": "function ResetAllAmount() onlyOwner public { for(uint i=0;i<recieverList.length;i++) { recievermap[recieverList[i]].useramount = 0; } }",
        "vulnerability": "Potential Out-of-Gas Exception",
        "reason": "Similar to `TransferToAllAccounts`, this function iterates over all entries in `recieverList` and sets their `useramount` to zero. If `recieverList` is too large, this could also cause an out-of-gas exception, preventing the function from completing successfully and leaving the state of `recievermap` inconsistent.",
        "file_name": "0x6a3f85f8a86e7b3de0269c20e9ab066dd57b8e21.sol"
    },
    {
        "function_name": "transfer",
        "code": "function transfer(address to,uint val) onlyOwner public { require(ERC20Basic(token).transfer(to, val)); emit TransferTo(to, val); }",
        "vulnerability": "Lack of Access Control",
        "reason": "The function `transfer` allows the owner to transfer any amount of tokens to any address without any restrictions or checks on the balance of tokens held by the contract. This could be exploited by a malicious owner to drain all tokens from the contract, if they have access to the owner account.",
        "file_name": "0x6a3f85f8a86e7b3de0269c20e9ab066dd57b8e21.sol"
    }
]