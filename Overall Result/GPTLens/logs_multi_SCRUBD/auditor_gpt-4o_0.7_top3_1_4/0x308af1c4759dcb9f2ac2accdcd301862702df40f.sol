[
    {
        "function_name": "userRecover",
        "code": "function userRecover(address _origin, address _destination, uint _baseAmt) external { transactions[_origin] = Transaction( transactionStatus.PendingR1, _baseAmt, 0, eternal.getUint(2), 0, 0, _destination, 0); Transaction storage transaction = transactions[_origin]; base.transferFrom(_origin, owner, transaction.sellerFee); base.transferFrom(_origin, reserve, rF); uint destinationAmt = _baseAmt - (transaction.sellerFee + rF); base.transferFrom(_origin, _destination, destinationAmt); recovery(_origin); }",
        "vulnerability": "Lack of access control",
        "reason": "The `userRecover` function can be called by anyone, allowing unauthorized entities to manipulate transactions and funds by setting arbitrary transaction data and transferring tokens from `_origin` without restriction.",
        "file_name": "0x308af1c4759dcb9f2ac2accdcd301862702df40f.sol"
    },
    {
        "function_name": "releaseFunds",
        "code": "function releaseFunds (address _tag) private { Transaction storage transaction = transactions[_tag]; require(transaction.status == transactionStatus.Pending); uint buyerTotal = transaction.txnAmt + transaction.buyerFee; uint buyerBalance = transaction.buyerBalance; transaction.buyerBalance = 0; require(buyerTotal == buyerBalance); base.transferFrom(_tag, transaction.buyer, transaction.baseAmt); uint totalFees = transaction.buyerFee + transaction.sellerFee; uint sellerTotal = transaction.txnAmt - transaction.sellerFee; transaction.txnAmt = 0; transaction.sellerFee = 0; if (transaction.token == 0) { _tag.transfer(sellerTotal); owner.transfer(totalFees); } else { token = ERC20(eternal.getAddress(transaction.token)); token.transfer(_tag, sellerTotal); token.transfer(owner, totalFees); } transaction.status = transactionStatus.PendingR1; recovery(_tag); }",
        "vulnerability": "Incorrect Ether transfer",
        "reason": "In `releaseFunds`, the function attempts to transfer Ether using `_tag.transfer(sellerTotal);` and `owner.transfer(totalFees);`, which may fail due to gas limitations with transfer method. This can lead to locked funds and incomplete transactions.",
        "file_name": "0x308af1c4759dcb9f2ac2accdcd301862702df40f.sol"
    },
    {
        "function_name": "createTransaction",
        "code": "function createTransaction ( address _tag, uint _baseAmt, uint _txnAmt, uint _sellerFee, uint _buyerFee) external payable { Transaction storage transaction = transactions[_tag]; require(transaction.buyer == 0x0); transactions[_tag] = Transaction( transactionStatus.Pending, _baseAmt, _txnAmt, _sellerFee, _buyerFee, 0, msg.sender, 0); uint buyerTotal = _txnAmt + _buyerFee; require(transaction.buyerBalance + msg.value == buyerTotal); transaction.buyerBalance += msg.value; balance[msg.sender] += msg.value; }",
        "vulnerability": "Re-entrancy possibility",
        "reason": "The `createTransaction` function updates balances after external calls. While not immediately vulnerable due to lack of direct external calls, future updates or inherited contracts could introduce re-entrancy issues if not carefully managed.",
        "file_name": "0x308af1c4759dcb9f2ac2accdcd301862702df40f.sol"
    }
]