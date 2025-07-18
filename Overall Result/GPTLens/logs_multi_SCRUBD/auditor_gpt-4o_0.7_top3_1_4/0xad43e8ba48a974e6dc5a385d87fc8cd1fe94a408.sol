[
    {
        "function_name": "function () payable",
        "code": "function () payable { require(!crowdsaleClosed && msg.value <= 2 ether); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint sendTokens = (amount / price) * 10 ** uint256(18); tokenReward.transfer(msg.sender, sendTokens); soldTokensCounter += sendTokens; FundTransfer(msg.sender, amount, price, true); if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function transfers Ether to the beneficiary using the low-level `send` function, which might fail. This also allows for a potential reentrancy attack where an attacker could re-enter the function before the state is updated (i.e., before `balanceOf[msg.sender]` is updated), causing inconsistent state or draining funds. This issue is exacerbated by the fact that the state update is done after the send operation.",
        "file_name": "0xad43e8ba48a974e6dc5a385d87fc8cd1fe94a408.sol"
    },
    {
        "function_name": "function () payable",
        "code": "function () payable { require(!crowdsaleClosed && msg.value <= 2 ether); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint sendTokens = (amount / price) * 10 ** uint256(18); tokenReward.transfer(msg.sender, sendTokens); soldTokensCounter += sendTokens; FundTransfer(msg.sender, amount, price, true); if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } }",
        "vulnerability": "Arithmetic precision error",
        "reason": "The calculation `uint sendTokens = (amount / price) * 10 ** uint256(18);` can lead to precision issues due to integer division in Solidity, which truncates the remainder. If `amount` is not a perfect multiple of `price`, this will result in fewer tokens being sent than expected, which could be exploited by an attacker to receive more tokens than they should by slightly adjusting their contribution amounts.",
        "file_name": "0xad43e8ba48a974e6dc5a385d87fc8cd1fe94a408.sol"
    },
    {
        "function_name": "function getUnsoldTokensWithDecimals",
        "code": "function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner { val_ = val_ * 10 ** dec_; tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Arithmetic overflow",
        "reason": "The multiplication `val_ = val_ * 10 ** dec_;` can cause an overflow if `dec_` is large enough, particularly since the contract uses Solidity 0.4.19 which does not have built-in overflow checking. This can be exploited by the owner to transfer an unintended large number of tokens to the beneficiary.",
        "file_name": "0xad43e8ba48a974e6dc5a385d87fc8cd1fe94a408.sol"
    }
]