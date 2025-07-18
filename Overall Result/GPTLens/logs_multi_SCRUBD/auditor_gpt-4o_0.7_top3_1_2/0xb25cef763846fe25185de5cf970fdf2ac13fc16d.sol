[
    {
        "function_name": "function () payable",
        "code": "function () payable { require(!crowdsaleClosed); price = getPrice(); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint sendTokens = (amount / price) * 10 ** uint256(18); tokenReward.transfer(msg.sender, sendTokens); soldTokensCounter += sendTokens; FundTransfer(msg.sender, amount, price, true); if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function transfers Ether to the beneficiary using 'beneficiary.send(amount)', which is susceptible to reentrancy attacks. An attacker could create a malicious contract that calls this function and re-enters before the state variables are updated, potentially causing incorrect token distribution or Ether theft.",
        "file_name": "0xb25cef763846fe25185de5cf970fdf2ac13fc16d.sol"
    },
    {
        "function_name": "getUnsoldTokens",
        "code": "function getUnsoldTokens(uint val_) onlyOwner { tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Lack of validation for token transfers",
        "reason": "The function allows the owner to transfer any amount of tokens to themselves without validating if the tokens are actually unsold. This could lead to the owner draining the contract of tokens that should be reserved for contributors or other purposes.",
        "file_name": "0xb25cef763846fe25185de5cf970fdf2ac13fc16d.sol"
    },
    {
        "function_name": "getUnsoldTokensWithDecimals",
        "code": "function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner { val_ = val_ * 10 ** dec_; tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Potential arithmetic overflow",
        "reason": "The calculation 'val_ * 10 ** dec_' can lead to an arithmetic overflow if 'dec_' is too large, which could cause incorrect token amounts to be transferred. This vulnerability could be exploited by the owner to transfer unintended amounts of tokens.",
        "file_name": "0xb25cef763846fe25185de5cf970fdf2ac13fc16d.sol"
    }
]