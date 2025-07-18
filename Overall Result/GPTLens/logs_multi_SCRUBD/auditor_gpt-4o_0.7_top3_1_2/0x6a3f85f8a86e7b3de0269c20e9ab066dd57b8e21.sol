[
    {
        "function_name": "TransferToAllAccounts",
        "code": "function TransferToAllAccounts() onlyOwner public { for(uint i=0;i<recieverList.length;i++) { recievermap[recieverList[i]].lastTransfer = false; address to = recievermap[recieverList[i]].useraddress; uint256 val = recievermap[recieverList[i]].useramount; if(val>0) { require(ERC20Basic(token).transfer(to, val)); emit TransferTo(to, val); recievermap[recieverList[i]].lastTransfer = true; } } }",
        "vulnerability": "Lack of Gas Limit in Loop",
        "reason": "The TransferToAllAccounts function iterates over the entire recieverList without any gas limit checks, potentially causing out-of-gas errors if the list is too large. This could prevent the function from executing successfully or being used as a denial-of-service vector.",
        "file_name": "0x6a3f85f8a86e7b3de0269c20e9ab066dd57b8e21.sol"
    },
    {
        "function_name": "transfer",
        "code": "function transfer(address to,uint val) onlyOwner public { require(ERC20Basic(token).transfer(to, val)); emit TransferTo(to, val); }",
        "vulnerability": "Centralization of Control",
        "reason": "The function allows the contract owner to transfer any amount of tokens to any address without any checks or balances. This centralization of control could be exploited if the owner is malicious or if the owner's private key is compromised.",
        "file_name": "0x6a3f85f8a86e7b3de0269c20e9ab066dd57b8e21.sol"
    },
    {
        "function_name": "transfertoacc",
        "code": "function transfertoacc(string key,uint val) onlyOwner public { recievermap[key].lastTransfer = false; address to = recievermap[key].useraddress; require(ERC20Basic(token).transfer(to, val)); emit TransferToName(to,key, val); recievermap[key].lastTransfer = true; }",
        "vulnerability": "Insecure Key Usage",
        "reason": "The transfertoacc function relies on a string key to identify accounts, which could be subject to hash collisions or other manipulation attacks. If an attacker can manipulate the key, they might redirect funds to an unintended recipient.",
        "file_name": "0x6a3f85f8a86e7b3de0269c20e9ab066dd57b8e21.sol"
    }
]