[
    {
        "function_name": "function () payable",
        "code": "function () payable { require(!crowdsaleClosed); price = getPrice(); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint sendTokens = (amount / price) * 10 ** uint256(18); tokenReward.transfer(msg.sender, sendTokens); soldTokensCounter += sendTokens; FundTransfer(msg.sender, amount, price, true); if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function directly sends Ether to the beneficiary using `beneficiary.send(amount)`. This operation can be exploited by attackers to perform reentrancy attacks, as the `send` function only forwards 2300 gas, which might not be enough for complex operations in the receiving contract but is still enough for simple reentrancy attacks. This could result in attackers withdrawing more funds than they are supposed to or disrupting the flow of the function.",
        "file_name": "0xb25cef763846fe25185de5cf970fdf2ac13fc16d.sol"
    },
    {
        "function_name": "getUnsoldTokens",
        "code": "function getUnsoldTokens(uint val_) onlyOwner { tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Missing transfer return value check",
        "reason": "The `getUnsoldTokens` function calls `tokenReward.transfer(beneficiary, val_)` without checking the return value. If the transfer fails, the contract will assume it succeeded, which could lead to inconsistencies and potentially the permanent loss of tokens.",
        "file_name": "0xb25cef763846fe25185de5cf970fdf2ac13fc16d.sol"
    },
    {
        "function_name": "getUnsoldTokensWithDecimals",
        "code": "function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner { val_ = val_ * 10 ** dec_; tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Arithmetic overflow/underflow",
        "reason": "The function `getUnsoldTokensWithDecimals` performs multiplication to calculate `val_ * 10 ** dec_` without any overflow checks. Given that Solidity 0.4.19 does not automatically check for overflows, this can lead to unexpected behavior where the result of multiplication exceeds the maximum uint256 value, causing it to wrap around and result in a much smaller number. This vulnerability can be exploited to steal tokens or cause other unintended behaviors.",
        "file_name": "0xb25cef763846fe25185de5cf970fdf2ac13fc16d.sol"
    }
]