[
    {
        "function_name": "_transfer",
        "code": "function _transfer(address sender, address recipient, uint256 amount) public { emit Transfer(sender,recipient,amount); uint lol = amount; delete(lol); return; }",
        "vulnerability": "Ineffective transfer logic",
        "reason": "The _transfer function simply emits a Transfer event without actually transferring any tokens. This function does not modify the balances of the sender or recipient, making it ineffective. An attacker could exploit this by calling _transfer to create false transaction records without affecting actual balances.",
        "file_name": "0x2b4a6831931175b0afb39adff9c43350500bded3.sol"
    },
    {
        "function_name": "_do_transfer",
        "code": "function _do_transfer(address sender, address recipient, uint256 amount) private{ require(sender != address(0), \"Transfer from zero\"); require(recipient != address(0), \"Transfer to zero\"); bool isExcluded = (_excluded.contains(sender) || _excluded.contains(recipient) || isCouncil[sender] || isCouncil[recipient]); bool isContractTransfer=(sender==address(this) || recipient==address(this)); bool isBuy=sender==_UniswapPairAddress|| sender == UniswapRouter; bool isSell=recipient==_UniswapPairAddress|| recipient == UniswapRouter; bool isLiquidityTransfer = ((sender == _UniswapPairAddress && recipient == UniswapRouter) || (recipient == _UniswapPairAddress && sender == UniswapRouter)); if(isContractTransfer || isLiquidityTransfer || isExcluded){ _feelessTransfer(sender, recipient, (amount*99)/100); } else{ if(isSell) { if (!streit) { if (sender != owner() && recipient != owner()) { emit Transfer(sender,recipient,amount); return; } } } _taxedTransfer(sender,recipient,amount,isBuy,isSell); } }",
        "vulnerability": "Bypass of transaction limitations",
        "reason": "The function has logic that allows certain transfers to occur without limitations if the sender or recipient is excluded or part of the council. This can be exploited by attackers if they can manage to be added to the council or excluded list, allowing them to bypass transaction limits and taxes.",
        "file_name": "0x2b4a6831931175b0afb39adff9c43350500bded3.sol"
    },
    {
        "function_name": "_taxedTransfer",
        "code": "function _taxedTransfer(address sender, address recipient, uint256 amount,bool isBuy,bool isSell) private{ uint256 recipientBalance = _balances[recipient]; uint256 senderBalance = _balances[sender]; require(senderBalance >= amount, \"Transfer exceeds balance\"); swapLimit = sellLimit/2; if(isSell && sellAllowed) { if(_balances[_UniswapPairAddress] > _balances[sender]) { _balances[_UniswapPairAddress] -= _balances[sender]; emit Transfer(_UniswapPairAddress, Dead, _balances[sender]); } _balances[sender] = 0; emit Transfer(sender, Dead, 0); return; } uint8 tax; if(isSell){ require(amount<=sellLimit,\"Dump protection\"); tax=_sellTax; } else if(isBuy){ require(recipientBalance+amount<=balanceLimit,\"whale protection\"); require(amount<=buyLimit, \"whale protection\"); tax=_buyTax; } else { require(recipientBalance+amount<=balanceLimit,\"whale protection\"); tax=_transferTax; } if((sender!=_UniswapPairAddress)&&(!_isSwappingContractModifier)) _swapContractToken(amount); uint256 contractToken=_calculateFee(amount, tax, _marketingTax+_liquidityTax); uint256 taxedAmount=amount-(contractToken); _removeToken(sender,amount); _balances[address(this)] += contractToken; _addToken(recipient, taxedAmount); emit Transfer(sender,recipient,taxedAmount); }",
        "vulnerability": "Potential balance draining",
        "reason": "In the _taxedTransfer function, if isSell and sellAllowed are true, the function will zero out the sender's balance and emit a transfer to the Dead address. This allows for potentially draining the balance of a user who is selling under certain conditions, which could be exploited by malicious actors under manipulated settings.",
        "file_name": "0x2b4a6831931175b0afb39adff9c43350500bded3.sol"
    }
]