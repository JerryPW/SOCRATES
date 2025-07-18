[
    {
        "function_name": "executeTxn",
        "code": "function executeTxn(uint txId) onlyOwner() external returns (bool){ Transaction storage txn = transactions[txId]; require(txn.status == TxnStatus.Pending); require(allowance >= txn.value); address dest = txn.destination; uint val = txn.value; bytes memory dat = txn.data; assert(dest.call.value(val)(dat)); txn.status = TxnStatus.Executed; allowance = allowance - txn.value; return true; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function uses low-level call with assert(dest.call.value(val)(dat)), which forwards all remaining gas and does not update the state (txn.status) before the call. This allows a reentrant call that can exploit the transaction execution to drain funds.",
        "file_name": "0x0a42ef719ee77820993b27369089ae2c6bd6ced5.sol"
    },
    {
        "function_name": "confirmTransaction",
        "code": "function confirmTransaction(uint txId) onlyOwner() external returns (bool){ Transaction storage txn = transactions[txId]; bool f; for (uint8 i = 0; i<txn.confirmed.length;i++){ if (txn.confirmed[i] == msg.sender){ f = true; } } require(!f); txn.confirmed.push(msg.sender); if (txn.confirmed.length == approvalsreq){ txn.status = TxnStatus.Pending; } emit TxnConfirmed(txId); return true; }",
        "vulnerability": "Improper confirmation check",
        "reason": "The function does not properly update the status of transactions that have already been confirmed by the required number of owners, leading to potential logical errors where transactions may be confirmed multiple times by the same owner, due to lack of an explicit check before pushing the confirming owner.",
        "file_name": "0x0a42ef719ee77820993b27369089ae2c6bd6ced5.sol"
    },
    {
        "function_name": "executeTokenTxn",
        "code": "function executeTokenTxn(uint txId) onlyOwner() external returns (bool){ tokenTransaction storage txn = tokenTransactions[txId]; require(txn.status == TxnStatus.Pending); uint256 balance = txn.token.balanceOf(address(this)); require (txn.value <= balance); txn.token.transfer(txn.reciever, txn.value); txn.status = TxnStatus.Executed; emit tokenTxnExecuted(address(txn.token), txn.value, txn.reciever); return true; }",
        "vulnerability": "Lack of checks-effects-interactions pattern",
        "reason": "The function transfers the token before updating the status to Executed, which violates the checks-effects-interactions pattern and could lead to reentrancy issues if the token contract is malicious or buggy, allowing attackers to execute the transaction multiple times.",
        "file_name": "0x0a42ef719ee77820993b27369089ae2c6bd6ced5.sol"
    }
]