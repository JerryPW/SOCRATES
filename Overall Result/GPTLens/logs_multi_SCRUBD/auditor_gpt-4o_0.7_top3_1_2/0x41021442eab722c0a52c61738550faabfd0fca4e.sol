[
    {
        "function_name": "fallback function",
        "code": "function () payable { require(!crowdsaleClosed && msg.value >= 1 ether); price = getPrice(); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint sendTokens = (amount / price) * 10 ** uint256(18); tokenReward.transfer(msg.sender, sendTokens); soldTokensCounter += sendTokens; FundTransfer(msg.sender, amount, price, true); if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function uses beneficiary.send(amount) which sends Ether to the beneficiary. This method is considered unsafe as it can be exploited for reentrancy attacks. If the beneficiary is a contract with a fallback function, it can recursively call this function before the state variables are updated, leading to inconsistent state and potential theft of funds.",
        "file_name": "0x41021442eab722c0a52c61738550faabfd0fca4e.sol"
    },
    {
        "function_name": "getUnsoldTokens",
        "code": "function getUnsoldTokens(uint val_) onlyOwner { tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Unchecked token transfer",
        "reason": "The function getUnsoldTokens does not verify the success of the token transfer operation. If the transfer fails (due to insufficient balance or any other reason), the contract will not be aware, potentially leading to incorrect assumptions about token distribution and contract state.",
        "file_name": "0x41021442eab722c0a52c61738550faabfd0fca4e.sol"
    },
    {
        "function_name": "getUnsoldTokensWithDecimals",
        "code": "function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner { val_ = val_ * 10 ** dec_; tokenReward.transfer(beneficiary, val_); }",
        "vulnerability": "Integer overflow",
        "reason": "The multiplication operation val_ * 10 ** dec_ is prone to integer overflow in older Solidity versions like 0.4.19. If dec_ is large, this overflow can occur, leading to incorrect token calculations and potential loss of control over token distribution. This is critical as it allows the owner to mint excessive tokens.",
        "file_name": "0x41021442eab722c0a52c61738550faabfd0fca4e.sol"
    }
]