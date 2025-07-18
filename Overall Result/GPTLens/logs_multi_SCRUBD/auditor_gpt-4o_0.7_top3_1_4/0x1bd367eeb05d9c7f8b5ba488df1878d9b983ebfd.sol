[
    {
        "function_name": "getUnsoldTokens",
        "code": "function getUnsoldTokens(uint val_) onlyOwner { tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "No return value check on token transfer",
        "reason": "The function does not check the return value of the token transfer function. If the token contract's transfer function returns false due to any reason (like insufficient balance or allowance), this will not be caught, leading to potential inconsistencies in the contract state. An attacker could exploit this by manipulating the token contract to always return false, effectively blocking token transfers without the Crowdsale contract being aware.",
        "file_name": "0x1bd367eeb05d9c7f8b5ba488df1878d9b983ebfd.sol"
    },
    {
        "function_name": "getUnsoldTokensWithDecimals",
        "code": "function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner { val_ = val_ * 10 ** dec_; tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Potential arithmetic overflow",
        "reason": "The function multiplies 'val_' by '10 ** dec_' without checking for overflow. If 'dec_' is large enough, this calculation could overflow, resulting in an incorrect and much smaller 'val_' being transferred. An attacker could use this to force an overflow, leading to an unintended amount of tokens being transferred to the beneficiary, potentially draining the Crowdsale contract of tokens.",
        "file_name": "0x1bd367eeb05d9c7f8b5ba488df1878d9b983ebfd.sol"
    },
    {
        "function_name": "function () payable",
        "code": "function () payable { require(!crowdsaleClosed); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint sendTokens = (amount / price) * 10 ** uint256(18); tokenReward.transfer(msg.sender, sendTokens); soldTokensCounter += sendTokens; FundTransfer(msg.sender, amount, price, true); if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function makes an external call to 'beneficiary.send(amount)' after updating the state with 'balanceOf[msg.sender] += amount;' and 'amountRaised += amount;'. This allows for a reentrancy attack if the 'beneficiary' is a contract that can call back into this fallback function before the state is fully updated. An attacker could exploit this to drain ether by recursively calling the fallback function, extracting more ether than they contributed.",
        "file_name": "0x1bd367eeb05d9c7f8b5ba488df1878d9b983ebfd.sol"
    }
]