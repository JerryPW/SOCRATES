[
    {
        "function_name": "getUnsoldTokens",
        "code": "function getUnsoldTokens(uint val_) onlyOwner { tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Lack of input validation for token amount",
        "reason": "This function allows the owner to transfer any amount of tokens to themselves without any checks. This can be exploited to drain the contract of its tokens by simply calling this function with a large `val_` parameter.",
        "file_name": "0x41021442eab722c0a52c61738550faabfd0fca4e.sol"
    },
    {
        "function_name": "getUnsoldTokensWithDecimals",
        "code": "function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner { val_ = val_ * 10 ** dec_; tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Unchecked multiplication leads to overflow",
        "reason": "The multiplication `val_ * 10 ** dec_` can result in an overflow if `dec_` is large enough, causing unexpected behavior. This can be used maliciously to manipulate the `val_` to an incorrect and potentially large number, allowing the owner to transfer unintended token amounts.",
        "file_name": "0x41021442eab722c0a52c61738550faabfd0fca4e.sol"
    },
    {
        "function_name": "function () payable",
        "code": "function () payable { require(!crowdsaleClosed && msg.value >= 1 ether); price = getPrice(); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint sendTokens = (amount / price) * 10 ** uint256(18); tokenReward.transfer(msg.sender, sendTokens); soldTokensCounter += sendTokens; FundTransfer(msg.sender, amount, price, true); if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } }",
        "vulnerability": "Unsafe Ether transfer with send",
        "reason": "Using `beneficiary.send(amount)` can fail silently without throwing an error, which can lead to Ether being stuck in the contract if the transfer fails. This is especially risky if the gas cost of the transaction is high, or if the beneficiary address is a contract that implements a fallback function requiring more gas than provided by `send`.",
        "file_name": "0x41021442eab722c0a52c61738550faabfd0fca4e.sol"
    }
]