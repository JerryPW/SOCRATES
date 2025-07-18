[
    {
        "function_name": "function () payable",
        "code": "function () payable { require(!crowdsaleClosed); price = getPrice(); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint sendTokens = (amount / price) * 10 ** uint256(18); tokenReward.transfer(msg.sender, sendTokens); soldTokensCounter += sendTokens; FundTransfer(msg.sender, amount, price, true); if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function sends Ether to the beneficiary using `beneficiary.send(amount)`, which is a potential reentrancy attack vector. If the beneficiary is a contract, it could re-enter the fallback function before the state changes are finalized, potentially draining funds or manipulating state variables.",
        "file_name": "0xb25cef763846fe25185de5cf970fdf2ac13fc16d.sol"
    },
    {
        "function_name": "getUnsoldTokens",
        "code": "function getUnsoldTokens(uint val_) onlyOwner { tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Lack of token balance check",
        "reason": "The function does not check whether the contract has enough tokens to fulfill the transfer request. This could result in a failed transaction and prevent legitimate users from claiming their tokens if the contract's token balance is insufficient.",
        "file_name": "0xb25cef763846fe25185de5cf970fdf2ac13fc16d.sol"
    },
    {
        "function_name": "getUnsoldTokensWithDecimals",
        "code": "function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner { val_ = val_ * 10 ** dec_; tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Arithmetic overflow/underflow",
        "reason": "The multiplication `val_ * 10 ** dec_` can lead to an overflow if `dec_` is large enough. This can cause incorrect token amounts to be transferred, potentially allowing the owner to drain the contract's token balance.",
        "file_name": "0xb25cef763846fe25185de5cf970fdf2ac13fc16d.sol"
    }
]