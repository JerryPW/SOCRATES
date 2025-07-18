[
    {
        "function_name": "function",
        "code": "function () payable { require(!crowdsaleClosed); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint sendTokens = (amount / price) * 10 ** uint256(18); tokenReward.transfer(msg.sender, sendTokens); soldTokensCounter += sendTokens; FundTransfer(msg.sender, amount, price, true); if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function is vulnerable to reentrancy because it sends Ether to the beneficiary before updating the state variables. If the beneficiary is a contract with a fallback or receive function that interacts with this contract, it can call the fallback function again before the state variables are updated, potentially draining funds.",
        "file_name": "0x1bd367eeb05d9c7f8b5ba488df1878d9b983ebfd.sol"
    },
    {
        "function_name": "getUnsoldTokensWithDecimals",
        "code": "function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner { val_ = val_ * 10 ** dec_; tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Arithmetic overflow",
        "reason": "The function multiplies val_ by 10 raised to the power of dec_ without any overflow checks. If dec_ is large enough, this can cause an overflow, leading to incorrect token transfers potentially exceeding the available token supply.",
        "file_name": "0x1bd367eeb05d9c7f8b5ba488df1878d9b983ebfd.sol"
    },
    {
        "function_name": "function",
        "code": "function () payable { require(!crowdsaleClosed); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint sendTokens = (amount / price) * 10 ** uint256(18); tokenReward.transfer(msg.sender, sendTokens); soldTokensCounter += sendTokens; FundTransfer(msg.sender, amount, price, true); if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } }",
        "vulnerability": "Integer division truncation",
        "reason": "The calculation of sendTokens uses integer division which truncates the result. This can result in significant discrepancies between the Ether sent and the tokens received, leading to user dissatisfaction or exploitation if the rounding is consistently in favor of the attacker.",
        "file_name": "0x1bd367eeb05d9c7f8b5ba488df1878d9b983ebfd.sol"
    }
]