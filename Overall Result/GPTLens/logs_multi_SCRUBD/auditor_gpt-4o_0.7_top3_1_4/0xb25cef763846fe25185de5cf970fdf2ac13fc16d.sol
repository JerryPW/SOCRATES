[
    {
        "function_name": "function () payable",
        "code": "function () payable { require(!crowdsaleClosed); price = getPrice(); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint sendTokens = (amount / price) * 10 ** uint256(18); tokenReward.transfer(msg.sender, sendTokens); soldTokensCounter += sendTokens; FundTransfer(msg.sender, amount, price, true); if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function transfers tokens to the sender before updating the state variables and uses a low-level 'send' to transfer Ether to the beneficiary. If an attacker can re-enter this function, they can manipulate the balanceOf or amountRaised by creating a reentrancy attack through a malicious contract that calls back into the fallback function before the state variables are updated.",
        "file_name": "0xb25cef763846fe25185de5cf970fdf2ac13fc16d.sol"
    },
    {
        "function_name": "getUnsoldTokensWithDecimals",
        "code": "function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner { val_ = val_ * 10 ** dec_; tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Arithmetic overflow/underflow",
        "reason": "The function multiplies val_ by 10 ** dec_ without checking for overflows. If dec_ is large enough, this can result in an overflow, causing val_ to wrap around and transfer an incorrect amount of tokens. This could lead to unintended token transfer amounts, potentially benefiting an attacker if they manipulate the contract to receive more tokens than intended.",
        "file_name": "0xb25cef763846fe25185de5cf970fdf2ac13fc16d.sol"
    },
    {
        "function_name": "beneficiary.send(amount)",
        "code": "if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); }",
        "vulnerability": "Usage of send instead of transfer",
        "reason": "The use of send instead of transfer only forwards 2300 gas, which is susceptible to failure if more gas is required for execution. This may prevent the completion of the Ether transfer if the beneficiary is a contract that requires more gas, potentially causing funds to become stuck in the contract and allowing attackers to exploit this behavior by preventing legitimate transfers.",
        "file_name": "0xb25cef763846fe25185de5cf970fdf2ac13fc16d.sol"
    }
]