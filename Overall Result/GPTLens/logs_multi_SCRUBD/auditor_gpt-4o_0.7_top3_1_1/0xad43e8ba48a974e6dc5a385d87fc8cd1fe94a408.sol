[
    {
        "function_name": "function() payable",
        "code": "function () payable { require(!crowdsaleClosed && msg.value <= 2 ether); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint sendTokens = (amount / price) * 10 ** uint256(18); tokenReward.transfer(msg.sender, sendTokens); soldTokensCounter += sendTokens; FundTransfer(msg.sender, amount, price, true); if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function sends Ether to the `beneficiary` using `beneficiary.send(amount)`. This approach opens up the possibility for a reentrancy attack since the external call is made before updating all internal states. An attacker can use a fallback function in the `beneficiary` contract to re-enter the contract and cause unexpected behavior.",
        "file_name": "0xad43e8ba48a974e6dc5a385d87fc8cd1fe94a408.sol"
    },
    {
        "function_name": "getUnsoldTokens",
        "code": "function getUnsoldTokens(uint val_) onlyOwner { tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Lack of validation on token transfer",
        "reason": "The function `getUnsoldTokens` allows the owner to transfer any amount of tokens from the contract without any checks. This could lead to transferring more tokens than available, disrupting the tokenomics, or even draining the token balance unintentionally or maliciously.",
        "file_name": "0xad43e8ba48a974e6dc5a385d87fc8cd1fe94a408.sol"
    },
    {
        "function_name": "getUnsoldTokensWithDecimals",
        "code": "function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner { val_ = val_ * 10 ** dec_; tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Arbitrary token transfer with potential overflow",
        "reason": "The function `getUnsoldTokensWithDecimals` allows the owner to specify the number of decimals and multiply the `val_` by it, which can lead to an overflow if `dec_` is too large. This can result in incorrect amounts being transferred, leading to potential loss or manipulation of token balances.",
        "file_name": "0xad43e8ba48a974e6dc5a385d87fc8cd1fe94a408.sol"
    }
]