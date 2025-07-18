[
    {
        "function_name": "executeTxn",
        "code": "function executeTxn(uint txId) onlyOwner() external returns (bool){ Transaction storage txn = transactions[txId]; require(txn.status == TxnStatus.Pending); require(allowance >= txn.value); address dest = txn.destination; uint val = txn.value; bytes memory dat = txn.data; assert(dest.call.value(val)(dat)); txn.status = TxnStatus.Executed; allowance = allowance - txn.value; return true; }",
        "vulnerability": "Reentrancy",
        "reason": "The function uses 'dest.call.value(val)(dat)' to execute a transaction, which is vulnerable to reentrancy attacks. This allows an attacker to recursively call back into the contract before the transaction status and allowance updates are completed, potentially draining the contract's funds or performing unauthorized actions.",
        "file_name": "0x0a42ef719ee77820993b27369089ae2c6bd6ced5.sol"
    },
    {
        "function_name": "submitTransaction",
        "code": "function submitTransaction(address _destination, uint _value, bytes _data) onlyOwner () external returns (bool) { uint newTxId = transactions.length++; transactions[newTxId].id = newTxId; transactions[newTxId].destination = _destination; transactions[newTxId].value = _value; transactions[newTxId].data = _data; transactions[newTxId].creator = msg.sender; transactions[newTxId].confirmed.push(msg.sender); if (transactions[newTxId].confirmed.length == approvalsreq){ transactions[newTxId].status = TxnStatus.Pending; } emit TxnSumbitted(newTxId); return true; }",
        "vulnerability": "Unchecked Array Indexing",
        "reason": "The function does not validate that the transaction ID is within the bounds of the transactions array when accessing it. An attacker could potentially exploit this by manipulating the array length to access out-of-bounds memory, leading to unexpected behavior or data corruption.",
        "file_name": "0x0a42ef719ee77820993b27369089ae2c6bd6ced5.sol"
    },
    {
        "function_name": "confirmTransaction",
        "code": "function confirmTransaction(uint txId) onlyOwner() external returns (bool){ Transaction storage txn = transactions[txId]; bool f; for (uint8 i = 0; i<txn.confirmed.length;i++){ if (txn.confirmed[i] == msg.sender){ f = true; } } require(!f); txn.confirmed.push(msg.sender); if (txn.confirmed.length == approvalsreq){ txn.status = TxnStatus.Pending; } emit TxnConfirmed(txId); return true; }",
        "vulnerability": "Duplicate Confirmation",
        "reason": "The function uses a boolean flag to check if the sender has already confirmed the transaction, but it does not revert the transaction early if the sender is found in the confirmed list. This leads to unnecessary gas consumption and does not efficiently prevent duplicate confirmations.",
        "file_name": "0x0a42ef719ee77820993b27369089ae2c6bd6ced5.sol"
    }
]