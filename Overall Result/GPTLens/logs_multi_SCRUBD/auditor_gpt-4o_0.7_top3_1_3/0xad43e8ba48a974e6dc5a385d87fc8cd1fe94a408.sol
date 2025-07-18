[
    {
        "function_name": "getUnsoldTokens",
        "code": "function getUnsoldTokens(uint val_) onlyOwner { tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Lack of return value handling in ERC20 transfer",
        "reason": "The function calls the transfer function of the token interface without checking the return value. This can lead to a situation where transfer fails (e.g., due to lack of allowance or other reasons), but the contract would still assume that the transfer was successful. This can be exploited to give the impression that tokens have been moved when they actually have not.",
        "file_name": "0xad43e8ba48a974e6dc5a385d87fc8cd1fe94a408.sol"
    },
    {
        "function_name": "getUnsoldTokensWithDecimals",
        "code": "function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner { val_ = val_ * 10 ** dec_; tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Integer overflow vulnerability",
        "reason": "This function multiplies val_ by 10 ** dec_ without checking for integer overflow. In Solidity versions prior to 0.8, this does not automatically cause a revert, potentially allowing an attacker to overflow the value, leading to incorrect token amounts being transferred if dec_ is excessively large.",
        "file_name": "0xad43e8ba48a974e6dc5a385d87fc8cd1fe94a408.sol"
    },
    {
        "function_name": "function ()",
        "code": "function () payable { require(!crowdsaleClosed && msg.value <= 2 ether); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint sendTokens = (amount / price) * 10 ** uint256(18); tokenReward.transfer(msg.sender, sendTokens); soldTokensCounter += sendTokens; FundTransfer(msg.sender, amount, price, true); if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } }",
        "vulnerability": "Reentrancy vulnerability due to send",
        "reason": "The fallback function uses the send method to transfer ether to the beneficiary without proper reentrancy protection. This is a classic reentrancy pattern where an attacker can repeatedly call the fallback function to drain funds because the state update occurs after the send operation, allowing an attacker to exploit this by reentering the contract.",
        "file_name": "0xad43e8ba48a974e6dc5a385d87fc8cd1fe94a408.sol"
    }
]