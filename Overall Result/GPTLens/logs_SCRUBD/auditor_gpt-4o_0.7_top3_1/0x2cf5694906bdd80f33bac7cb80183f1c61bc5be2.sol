[
    {
        "function_name": "destroyAndSend",
        "code": "function destroyAndSend(address _recipient) public onlyOwner { selfdestruct(_recipient); }",
        "vulnerability": "misuse_of_selfdestruct",
        "reason": "The function allows the contract owner to self-destruct the contract and send all contract funds to any arbitrary address. If the owner's private key is compromised, an attacker can call this function and redirect the funds to their address.",
        "file_name": "0x2cf5694906bdd80f33bac7cb80183f1c61bc5be2.sol"
    },
    {
        "function_name": "withdrawAllToExchange",
        "code": "function withdrawAllToExchange(address depositAccount, uint min_amount) external onlyMerchantOrMonetha whenNotPaused { require (address(this).balance >= min_amount); doWithdrawal(depositAccount, address(this).balance); }",
        "vulnerability": "funds_drainage_risk",
        "reason": "The function allows an authorized party to withdraw all funds from the contract to a specified deposit account. If a Monetha address is compromised or misused, they could drain the contract's balance entirely.",
        "file_name": "0x2cf5694906bdd80f33bac7cb80183f1c61bc5be2.sol"
    },
    {
        "function_name": "acceptPayment",
        "code": "function acceptPayment(address _merchantWallet, uint _monethaFee, address _customerAddress, uint _vouchersApply, uint _paybackPermille) external payable onlyMonetha whenNotPaused returns (uint discountWei){ require(_merchantWallet != 0x0); uint price = msg.value; require(_monethaFee >= 0 && _monethaFee <= FEE_PERMILLE.mul(price).div(1000)); discountWei = 0; if (monethaVoucher != address(0)) { if (_vouchersApply > 0 && MaxDiscountPermille > 0) { uint maxDiscountWei = price.mul(MaxDiscountPermille).div(PERMILLE_COEFFICIENT); uint maxVouchers = monethaVoucher.fromWei(maxDiscountWei); uint vouchersApply = _vouchersApply; if (vouchersApply > maxVouchers) { vouchersApply = maxVouchers; } (, discountWei) = monethaVoucher.applyDiscount(_customerAddress, vouchersApply); } if (_paybackPermille > 0) { uint paybackWei = price.sub(discountWei).mul(_paybackPermille).div(PERMILLE_COEFFICIENT); if (paybackWei > 0) { monethaVoucher.applyPayback(_customerAddress, paybackWei); } } } uint merchantIncome = price.sub(_monethaFee); _merchantWallet.transfer(merchantIncome); monethaVault.transfer(_monethaFee); emit PaymentProcessedEther(_merchantWallet, merchantIncome, _monethaFee); }",
        "vulnerability": "reentrancy_vulnerability",
        "reason": "The function directly transfers Ether to the merchant wallet without using the checks-effects-interactions pattern, which can be prone to reentrancy attacks if the merchant wallet is a contract with a fallback function.",
        "file_name": "0x2cf5694906bdd80f33bac7cb80183f1c61bc5be2.sol"
    }
]