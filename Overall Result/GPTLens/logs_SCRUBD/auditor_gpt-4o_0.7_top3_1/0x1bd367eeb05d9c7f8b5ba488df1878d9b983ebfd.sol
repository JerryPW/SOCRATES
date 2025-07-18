[
    {
        "function_name": "function()",
        "code": "function () payable { require(!crowdsaleClosed); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint sendTokens = (amount / price) * 10 ** uint256(18); tokenReward.transfer(msg.sender, sendTokens); soldTokensCounter += sendTokens; FundTransfer(msg.sender, amount, price, true); if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function uses the pattern where it first sends tokens to the sender and then sends ether to the beneficiary. If the beneficiary is a contract, it can re-enter the fallback function by calling another transaction, potentially altering the state variables like balanceOf and amountRaised before the first transaction is completed. This is due to the fact that the ether transfer happens after the state change, making it susceptible to reentrancy attacks.",
        "file_name": "0x1bd367eeb05d9c7f8b5ba488df1878d9b983ebfd.sol"
    },
    {
        "function_name": "getUnsoldTokens",
        "code": "function getUnsoldTokens(uint val_) onlyOwner { tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Lack of validation for token transfer",
        "reason": "The function allows the owner to transfer any amount of tokens to the beneficiary without checking the remaining unsold tokens or the total token balance. This means the owner can potentially transfer more tokens than are available, leading to incorrect accounting and potential loss for other participants.",
        "file_name": "0x1bd367eeb05d9c7f8b5ba488df1878d9b983ebfd.sol"
    },
    {
        "function_name": "getUnsoldTokensWithDecimals",
        "code": "function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner { val_ = val_ * 10 ** dec_; tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Unsafe calculation leading to overflow",
        "reason": "The function multiplies val_ by 10 raised to the power of dec_ without checking for overflow, which can lead to an integer overflow. This allows the owner to specify a large dec_ value, resulting in a very large val_ that can transfer more tokens than intended, causing a potential loss of tokens and disruption of token distribution mechanics.",
        "file_name": "0x1bd367eeb05d9c7f8b5ba488df1878d9b983ebfd.sol"
    }
]