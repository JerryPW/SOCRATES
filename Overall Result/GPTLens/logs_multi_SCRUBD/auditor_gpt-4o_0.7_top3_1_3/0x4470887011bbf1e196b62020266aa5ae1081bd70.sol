[
    {
        "function_name": "ClaimMTU",
        "code": "function ClaimMTU(bool claim) paused public { uint256 ethVal = Investors[msg.sender]; require(ethVal >= claimRate); if (claim) { require(claimRate > 0); require(block.timestamp < ClaimingTimeLimit); ethRaised += ethVal; uint256 claimTokens = ethVal / claimRate; address tokenAddress = getAddress(\"unit\"); token tokenTransfer = token(tokenAddress); tokenTransfer.transfer(msg.sender, claimTokens); if (isCharged) {getAddress(\"team\").transfer(ethVal / 20);} } else { msg.sender.transfer(ethVal); } Investors[msg.sender] -= ethVal; unClaimedEther -= ethVal; }",
        "vulnerability": "Reentrancy vulnerability in ether refund",
        "reason": "The function allows for a reentrancy attack during the refund operation. When `msg.sender.transfer(ethVal)` is called, control is transferred to the caller, who can then reenter the contract and call `ClaimMTU` again before the state variables `Investors[msg.sender]` and `unClaimedEther` are updated. This can lead to multiple withdrawals of `ethVal`, draining the contract.",
        "file_name": "0x4470887011bbf1e196b62020266aa5ae1081bd70.sol"
    },
    {
        "function_name": "DepositMTU",
        "code": "function DepositMTU(uint256 NoOfTokens) paused public { require(block.timestamp > RedeemingTimeLimit); address tokenAddress = getAddress(\"unit\"); token tokenFunction = token(tokenAddress); tokenFunction.transferFrom(msg.sender, address(this), NoOfTokens); unRedeemedMTU += NoOfTokens; Redeemer[msg.sender] += NoOfTokens; emit eAllowedMTU(msg.sender, NoOfTokens); }",
        "vulnerability": "Lack of allowance check in transferFrom",
        "reason": "The use of `transferFrom` without checking if the sender has sufficient allowance set can lead to unexpected behaviors if allowances are manipulated externally. This could potentially cause the function to fail, or tokens to be locked if the allowance is insufficient but the call is still made.",
        "file_name": "0x4470887011bbf1e196b62020266aa5ae1081bd70.sol"
    },
    {
        "function_name": "SendEtherToBoard",
        "code": "function SendEtherToBoard(uint256 weiAmt) onlyAdmin public { require(address(this).balance > unClaimedEther); getAddress(\"board\").transfer(weiAmt); }",
        "vulnerability": "Insecure check for ether balance",
        "reason": "The function checks if the contract's balance is greater than `unClaimedEther` before transferring ether. However, this check does not account for the specific amount (`weiAmt`) being sent, which might result in sending more ether than intended if `weiAmt` is larger than the difference between `address(this).balance` and `unClaimedEther`.",
        "file_name": "0x4470887011bbf1e196b62020266aa5ae1081bd70.sol"
    }
]