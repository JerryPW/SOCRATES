[
    {
        "function_name": "function() payable",
        "code": "function () payable { require(!crowdsaleClosed && msg.value >= 1 ether); price = getPrice(); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint sendTokens = (amount / price) * 10 ** uint256(18); tokenReward.transfer(msg.sender, sendTokens); soldTokensCounter += sendTokens; FundTransfer(msg.sender, amount, price, true); if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function uses 'beneficiary.send(amount)' after state changes. This could be exploited via a reentrancy attack, where the beneficiary is a contract that re-enters this function before the state changes are complete. To mitigate this, state changes should occur after all external calls or use the 'transfer' method instead of 'send', which throws an error on failure, preventing reentrancy.",
        "file_name": "0x41021442eab722c0a52c61738550faabfd0fca4e.sol"
    },
    {
        "function_name": "getUnsoldTokens",
        "code": "function getUnsoldTokens(uint val_) onlyOwner { tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Lack of validation for token transfer",
        "reason": "The function allows the owner to transfer any amount of tokens to the beneficiary without checking if 'val_' exceeds the available token balance. This can lead to transferring more tokens than the contract holds, which could result in a failed transaction or unintended behavior.",
        "file_name": "0x41021442eab722c0a52c61738550faabfd0fca4e.sol"
    },
    {
        "function_name": "getUnsoldTokensWithDecimals",
        "code": "function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner { val_ = val_ * 10 ** dec_; tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Integer overflow vulnerability",
        "reason": "The multiplication 'val_ * 10 ** dec_' can cause an integer overflow if 'dec_' is large enough, resulting in an incorrect token amount being transferred. This can be exploited by the owner to inadvertently or maliciously transfer an incorrect number of tokens to the beneficiary.",
        "file_name": "0x41021442eab722c0a52c61738550faabfd0fca4e.sol"
    }
]