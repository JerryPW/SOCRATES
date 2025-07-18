[
    {
        "function_name": "withdrawEther",
        "code": "function withdrawEther(uint _amount) public onlyEscrow { require(namiMultiSigWallet != 0x0); if (this.balance > 0) { namiMultiSigWallet.transfer(_amount); } }",
        "vulnerability": "Unrestricted Ether Withdrawal by Escrow",
        "reason": "The function allows the escrow address to withdraw any amount of Ether from the contract balance without any checks on the amount being withdrawn compared to the balance. This could lead to a situation where the entire contract balance is drained if the escrow is compromised.",
        "file_name": "0x0e33ca464b1c76a384039eb1b7e9dc3b0416b5ae.sol"
    },
    {
        "function_name": "withdrawNAC",
        "code": "function withdrawNAC(uint _amount) public onlyEscrow { require(namiMultiSigWallet != 0x0 && _amount != 0); NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr); if (namiToken.balanceOf(this) > 0) { namiToken.transfer(namiMultiSigWallet, _amount); } }",
        "vulnerability": "Unrestricted Token Withdrawal by Escrow",
        "reason": "Similar to the Ether withdrawal, this function allows the escrow to transfer any amount of NAC tokens to the multisig wallet without any constraints on the amount, potentially draining all tokens if the escrow is compromised.",
        "file_name": "0x0e33ca464b1c76a384039eb1b7e9dc3b0416b5ae.sol"
    },
    {
        "function_name": "sellNac",
        "code": "function sellNac(uint _value, address _buyer, uint _price) public returns (bool success) { require(_price == bid[_buyer].price && _buyer != msg.sender); NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr); uint ethOfBuyer = bid[_buyer].eth; uint maxToken = ethOfBuyer.mul(bid[_buyer].price); require(namiToken.allowance(msg.sender, this) >= _value && _value > 0 && ethOfBuyer != 0 && _buyer != 0x0); if (_value > maxToken) { if (msg.sender.send(ethOfBuyer) && namiToken.transferFrom(msg.sender,_buyer,maxToken)) { bid[_buyer].eth = 0; UpdateBid(_buyer, bid[_buyer].price, bid[_buyer].eth); BuyHistory(_buyer, msg.sender, bid[_buyer].price, maxToken, now); return true; } else { revert(); } } else { uint eth = _value.div(bid[_buyer].price); if (msg.sender.send(eth) && namiToken.transferFrom(msg.sender,_buyer,_value)) { bid[_buyer].eth = (bid[_buyer].eth).sub(eth); UpdateBid(_buyer, bid[_buyer].price, bid[_buyer].eth); BuyHistory(_buyer, msg.sender, bid[_buyer].price, _value, now); return true; } else { revert(); } } }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function calls `send` before updating the bid state, which could potentially be exploited by reentrancy attacks. If the sender is a contract, it could re-enter `sellNac` and manipulate the contract's state by leveraging the unchanged balance state.",
        "file_name": "0x0e33ca464b1c76a384039eb1b7e9dc3b0416b5ae.sol"
    }
]