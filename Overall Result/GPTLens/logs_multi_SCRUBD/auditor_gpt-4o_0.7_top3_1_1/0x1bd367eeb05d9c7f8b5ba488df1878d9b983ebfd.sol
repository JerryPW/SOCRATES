[
    {
        "function_name": "function () payable",
        "code": "function () payable { require(!crowdsaleClosed); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint sendTokens = (amount / price) * 10 ** uint256(18); tokenReward.transfer(msg.sender, sendTokens); soldTokensCounter += sendTokens; FundTransfer(msg.sender, amount, price, true); if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function sends Ether to the beneficiary using 'beneficiary.send(amount)', which can trigger code execution in the beneficiary's fallback function. If the beneficiary is a contract with a fallback function that calls back into the Crowdsale contract, it can potentially reenter and manipulate the state or cause unintended behaviors. This is due to the fact that state changes (like updating 'balanceOf' or 'amountRaised') are made before the Ether is sent.",
        "file_name": "0x1bd367eeb05d9c7f8b5ba488df1878d9b983ebfd.sol"
    },
    {
        "function_name": "function getUnsoldTokensWithDecimals",
        "code": "function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner { val_ = val_ * 10 ** dec_; tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Integer overflow/underflow",
        "reason": "The multiplication 'val_ * 10 ** dec_' can result in an integer overflow if 'dec_' is large enough, especially in older versions of Solidity (like 0.4.19) that do not have built-in overflow checks. This could allow the owner to transfer an incorrect and potentially very large number of tokens, which could be exploited to drain the token supply.",
        "file_name": "0x1bd367eeb05d9c7f8b5ba488df1878d9b983ebfd.sol"
    },
    {
        "function_name": "function getUnsoldTokens",
        "code": "function getUnsoldTokens(uint val_) onlyOwner { tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Privilege misuse",
        "reason": "This function allows the owner to transfer any amount of unsold tokens to themselves without any checks on the amount. This can lead to misuse where the owner can transfer more tokens than intended or reasonable, leading to potential loss of funds for contributors if the owner drains the token supply.",
        "file_name": "0x1bd367eeb05d9c7f8b5ba488df1878d9b983ebfd.sol"
    }
]