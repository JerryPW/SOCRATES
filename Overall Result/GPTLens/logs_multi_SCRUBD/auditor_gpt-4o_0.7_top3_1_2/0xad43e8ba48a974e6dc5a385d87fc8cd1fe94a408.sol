[
    {
        "function_name": "function () payable",
        "code": "function () payable { require(!crowdsaleClosed && msg.value <= 2 ether); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint sendTokens = (amount / price) * 10 ** uint256(18); tokenReward.transfer(msg.sender, sendTokens); soldTokensCounter += sendTokens; FundTransfer(msg.sender, amount, price, true); if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The fallback function sends Ether to the beneficiary using `beneficiary.send(amount)`, which only forwards 2300 gas. If the beneficiary is a contract, it may execute code on receiving ether, potentially leading to a reentrancy attack if the contract's logic is modified in future versions. Additionally, the `send` method\u2019s failure is not properly handled, which could lead to inconsistencies in the contract's state.",
        "file_name": "0xad43e8ba48a974e6dc5a385d87fc8cd1fe94a408.sol"
    },
    {
        "function_name": "function () payable",
        "code": "function () payable { require(!crowdsaleClosed && msg.value <= 2 ether); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint sendTokens = (amount / price) * 10 ** uint256(18); tokenReward.transfer(msg.sender, sendTokens); soldTokensCounter += sendTokens; FundTransfer(msg.sender, amount, price, true); if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } }",
        "vulnerability": "Arithmetic Precision Loss",
        "reason": "The calculation of `sendTokens` uses integer division `(amount / price) * 10 ** uint256(18)`, which can lead to a loss of precision because Solidity does not support floating point arithmetic. As a result, contributors may receive fewer tokens than they are entitled to, leading to potential financial losses and unfair distribution.",
        "file_name": "0xad43e8ba48a974e6dc5a385d87fc8cd1fe94a408.sol"
    },
    {
        "function_name": "getUnsoldTokens",
        "code": "function getUnsoldTokens(uint val_) onlyOwner { tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Lack of Validation for Unsold Token Retrieval",
        "reason": "The function allows the owner to transfer any amount of tokens to the beneficiary without any checks on whether these tokens are indeed unsold or even available in the contract's balance. This could lead to transferring more tokens than intended or authorized, allowing the owner to potentially drain the contract of tokens at will.",
        "file_name": "0xad43e8ba48a974e6dc5a385d87fc8cd1fe94a408.sol"
    }
]