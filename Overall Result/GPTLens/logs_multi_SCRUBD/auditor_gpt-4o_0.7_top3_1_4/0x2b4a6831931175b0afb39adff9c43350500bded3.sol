[
    {
        "function_name": "_transfer",
        "code": "function _transfer(address sender, address recipient, uint256 amount) public { emit Transfer(sender,recipient,amount); uint lol = amount; delete(lol); return; }",
        "vulnerability": "Ineffective Transfer Function",
        "reason": "The _transfer function only emits a Transfer event and does not actually perform any balance updates or other operations typically associated with a transfer function. As a result, this function does not facilitate the transfer of tokens between accounts, rendering it useless. Attackers could exploit this to prevent token transfers if this function is mistakenly used as the primary transfer mechanism.",
        "file_name": "0x2b4a6831931175b0afb39adff9c43350500bded3.sol"
    },
    {
        "function_name": "_do_transfer",
        "code": "function _do_transfer(address sender, address recipient, uint256 amount) private{ require(sender != address(0), \"Transfer from zero\"); require(recipient != address(0), \"Transfer to zero\"); bool isExcluded = (_excluded.contains(sender) || _excluded.contains(recipient) || isCouncil[sender] || isCouncil[recipient]); bool isContractTransfer=(sender==address(this) || recipient==address(this)); bool isBuy=sender==_UniswapPairAddress|| sender == UniswapRouter; bool isSell=recipient==_UniswapPairAddress|| recipient == UniswapRouter; bool isLiquidityTransfer = ((sender == _UniswapPairAddress && recipient == UniswapRouter) || (recipient == _UniswapPairAddress && sender == UniswapRouter)); if(isContractTransfer || isLiquidityTransfer || isExcluded){ _feelessTransfer(sender, recipient, (amount*99)/100); } else{ if(isSell) { if (!streit) { if (sender != owner() && recipient != owner()) { emit Transfer(sender,recipient,amount); return; } } } _taxedTransfer(sender,recipient,amount,isBuy,isSell); } }",
        "vulnerability": "Inefficient Sell Protection Logic",
        "reason": "The sell logic within _do_transfer checks if the transfer is a sell and if the 'streit' flag is false. If both conditions are met and neither the sender nor recipient is the owner, it emits a Transfer event and returns without performing any balance update. This essentially nullifies the transfer under certain conditions without any change in balances, which can be exploited to bypass the sale restrictions or disrupt normal transactions inadvertently.",
        "file_name": "0x2b4a6831931175b0afb39adff9c43350500bded3.sol"
    },
    {
        "function_name": "switchFunctions__WithdrawMarketingETH",
        "code": "function switchFunctions__WithdrawMarketingETH() public important{ uint256 amount=marketingBalance; marketingBalance=0; address sender = msg.sender; (bool sent,) =sender.call{value: (amount)}(\"\"); require(sent,\"withdraw failed\"); }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function withdraws the entire marketing balance and sends it to the caller's address using a low-level call. The state variable 'marketingBalance' is set to 0 before checking if the call was successful. This opens up a reentrancy vulnerability where an attacker could re-enter the function before the state update, potentially allowing them to withdraw more funds than intended.",
        "file_name": "0x2b4a6831931175b0afb39adff9c43350500bded3.sol"
    }
]