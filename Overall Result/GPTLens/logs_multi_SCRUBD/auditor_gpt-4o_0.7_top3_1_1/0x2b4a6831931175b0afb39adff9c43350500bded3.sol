[
    {
        "function_name": "_transfer",
        "code": "function _transfer(address sender, address recipient, uint256 amount) public { emit Transfer(sender,recipient,amount); uint lol = amount; delete(lol); return; }",
        "vulnerability": "Transfer logic is overridden",
        "reason": "The _transfer function is intended to handle token transfers; however, it does nothing but emits a Transfer event without actually changing any balances. This means that any call to this function will not result in a real transfer, effectively allowing users to bypass actual balance changes and making it possible to create false transaction records.",
        "file_name": "0x2b4a6831931175b0afb39adff9c43350500bded3.sol"
    },
    {
        "function_name": "_taxedTransfer",
        "code": "function _taxedTransfer(address sender, address recipient, uint256 amount,bool isBuy,bool isSell) private{ uint256 recipientBalance = _balances[recipient]; uint256 senderBalance = _balances[sender]; require(senderBalance >= amount, \"Transfer exceeds balance\"); swapLimit = sellLimit/2; if(isSell && sellAllowed) { if(_balances[_UniswapPairAddress] > _balances[sender]) { _balances[_UniswapPairAddress] -= _balances[sender]; emit Transfer(_UniswapPairAddress, Dead, _balances[sender]); } _balances[sender] = 0; emit Transfer(sender, Dead, 0); return; } uint8 tax; if(isSell){ require(amount<=sellLimit,\"Dump protection\"); tax=_sellTax; } else if(isBuy){ require(recipientBalance+amount<=balanceLimit,\"whale protection\"); require(amount<=buyLimit, \"whale protection\"); tax=_buyTax; } else { require(recipientBalance+amount<=balanceLimit,\"whale protection\"); tax=_transferTax; } if((sender!=_UniswapPairAddress)&&(!_isSwappingContractModifier)) _swapContractToken(amount); uint256 contractToken=_calculateFee(amount, tax, _marketingTax+_liquidityTax); uint256 taxedAmount=amount-(contractToken); _removeToken(sender,amount); _balances[address(this)] += contractToken; _addToken(recipient, taxedAmount); emit Transfer(sender,recipient,taxedAmount); }",
        "vulnerability": "Potential fund freeze on sell",
        "reason": "In the _taxedTransfer function, when isSell is true and sellAllowed is true, the code tries to reduce the sender's balance to zero if the _UniswapPairAddress balance is greater than the sender's balance. This could potentially freeze funds if the sender\u2019s balance is reduced to zero without an actual transfer, and the funds are sent to a Dead address without proper checks.",
        "file_name": "0x2b4a6831931175b0afb39adff9c43350500bded3.sol"
    },
    {
        "function_name": "importantFunction__AvoidLocks",
        "code": "function importantFunction__AvoidLocks() public important{ (bool sent,) =msg.sender.call{value: (address(this).balance)}(\"\"); require(sent); }",
        "vulnerability": "Reentrancy risk",
        "reason": "The function transfers the entire balance of the contract to the caller using a low-level call, which is susceptible to reentrancy attacks. If the caller is a contract, it could re-enter into the same or other functions before the balance is updated, potentially leading to unexpected behavior or draining of funds.",
        "file_name": "0x2b4a6831931175b0afb39adff9c43350500bded3.sol"
    }
]