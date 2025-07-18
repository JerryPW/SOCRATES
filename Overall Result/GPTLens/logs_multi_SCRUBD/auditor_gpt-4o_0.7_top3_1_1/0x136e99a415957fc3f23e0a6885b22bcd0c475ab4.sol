[
    {
        "function_name": "setTokenSaleContract",
        "code": "function setTokenSaleContract(address _tokenSaleAddr) external { require(tokenSaleAddr == address(0x0)); require(_tokenSaleAddr != address(0x0)); tokenSaleAddr = _tokenSaleAddr; }",
        "vulnerability": "Token sale contract can be set only once",
        "reason": "The function `setTokenSaleContract` allows setting the `tokenSaleAddr` only if it is initially set to address zero. This means that if the address is incorrectly set or needs to be updated, it cannot be changed, potentially locking the contract into an unusable state if the address becomes invalid.",
        "file_name": "0x136e99a415957fc3f23e0a6885b22bcd0c475ab4.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _amount) public onlyOwner { require(_amount > 0); uint256 amount = _amount; updateReleasedBalance(); uint256 available_balance = getAvailableBalance(); if (amount > available_balance) { amount = available_balance; } withdrawnBalance = withdrawnBalance.add(amount); owner.transfer(amount); emit WithdrawalHistory(\"ETH\", amount); }",
        "vulnerability": "No reentrancy protection",
        "reason": "The `withdraw` function transfers Ether to the owner without any reentrancy protection mechanism like a mutex or using the Checks-Effects-Interactions pattern. This can allow a reentrancy attack where the `transfer` call can trigger malicious fallback functions resulting in multiple withdrawals.",
        "file_name": "0x136e99a415957fc3f23e0a6885b22bcd0c475ab4.sol"
    },
    {
        "function_name": "refund",
        "code": "function refund(uint256 tokenAmount) external poolDestructed { require(ERC20Interface(votingTokenAddr).transferFrom(msg.sender, this, tokenAmount)); uint256 refundingEther = tokenAmount.mul(refundRateNano).div(10**9); emit Refund(msg.sender, tokenAmount); msg.sender.transfer(refundingEther); }",
        "vulnerability": "No reentrancy protection on refund",
        "reason": "The `refund` function transfers Ether to the caller without any reentrancy protection, which can be exploited through reentrancy attacks. An attacker could potentially call the `refund` function repeatedly before the `transfer` call completes, draining the contract balance.",
        "file_name": "0x136e99a415957fc3f23e0a6885b22bcd0c475ab4.sol"
    }
]