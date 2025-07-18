[
    {
        "function_name": "getUnsoldTokens",
        "code": "function getUnsoldTokens(uint val_) onlyOwner { tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Lack of validation on token transfer amount",
        "reason": "The function does not validate the amount of unsold tokens being transferred. The owner can transfer any amount of tokens, even more than the total supply, if the token contract does not handle such checks internally. This can lead to inflation of the token supply and loss of trust in the token's value.",
        "file_name": "0xad43e8ba48a974e6dc5a385d87fc8cd1fe94a408.sol"
    },
    {
        "function_name": "getUnsoldTokensWithDecimals",
        "code": "function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner { val_ = val_ * 10 ** dec_; tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Potential overflow in token calculation",
        "reason": "The multiplication operation val_ * 10 ** dec_ can lead to an overflow if dec_ is high enough. Since Solidity versions prior to 0.8.0 do not have built-in overflow checks, this can result in the transfer of an unintended amount of tokens, potentially allowing the owner to extract more tokens than intended.",
        "file_name": "0xad43e8ba48a974e6dc5a385d87fc8cd1fe94a408.sol"
    },
    {
        "function_name": "function",
        "code": "function () payable { require(!crowdsaleClosed && msg.value <= 2 ether); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint sendTokens = (amount / price) * 10 ** uint256(18); tokenReward.transfer(msg.sender, sendTokens); soldTokensCounter += sendTokens; FundTransfer(msg.sender, amount, price, true); if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } }",
        "vulnerability": "Unsafe use of beneficiary.send",
        "reason": "Using beneficiary.send(amount) is unsafe as it forwards only 2300 gas, which might not be enough if the beneficiary address is a contract with a fallback function requiring more than 2300 gas. This can cause the Ether transfer to fail while the token transfer would have already been executed, leading to an inconsistent state where the buyer gets tokens without paying.",
        "file_name": "0xad43e8ba48a974e6dc5a385d87fc8cd1fe94a408.sol"
    }
]