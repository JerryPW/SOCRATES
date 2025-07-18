[
    {
        "function_name": "function () payable",
        "code": "function () payable { require(!crowdsaleClosed); price = getPrice(); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint sendTokens = (amount / price) * 10 ** uint256(18); tokenReward.transfer(msg.sender, sendTokens); soldTokensCounter += sendTokens; FundTransfer(msg.sender, amount, price, true); if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } }",
        "vulnerability": "Reentrancy",
        "reason": "The fallback function sends Ether to the beneficiary without using the Checks-Effects-Interactions pattern. This could allow a reentrancy attack if the `beneficiary` is a contract that calls back into this contract, potentially modifying its state or draining funds.",
        "file_name": "0xb25cef763846fe25185de5cf970fdf2ac13fc16d.sol"
    },
    {
        "function_name": "getUnsoldTokens",
        "code": "function getUnsoldTokens(uint val_) onlyOwner { tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Unauthorized Token Transfer",
        "reason": "The function allows the owner to transfer any amount of tokens to the beneficiary without any checks on the conditions or the amount, potentially draining the contract of tokens and harming the investors.",
        "file_name": "0xb25cef763846fe25185de5cf970fdf2ac13fc16d.sol"
    },
    {
        "function_name": "getUnsoldTokensWithDecimals",
        "code": "function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner { val_ = val_ * 10 ** dec_; tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Unauthorized Token Transfer with Decimals",
        "reason": "Similar to `getUnsoldTokens`, this function allows the owner to transfer any amount of tokens, but with more flexibility in specifying decimals. This increases the risk of an unauthorized transfer, as the owner can specify an inflated amount by manipulating decimals.",
        "file_name": "0xb25cef763846fe25185de5cf970fdf2ac13fc16d.sol"
    }
]