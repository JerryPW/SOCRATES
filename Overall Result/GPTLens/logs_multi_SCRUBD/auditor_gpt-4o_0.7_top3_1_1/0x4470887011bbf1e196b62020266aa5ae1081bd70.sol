[
    {
        "function_name": "ClaimMTU",
        "code": "function ClaimMTU(bool claim) paused public { uint256 ethVal = Investors[msg.sender]; require(ethVal >= claimRate); if (claim) { require(claimRate > 0); require(block.timestamp < ClaimingTimeLimit); ethRaised += ethVal; uint256 claimTokens = ethVal / claimRate; address tokenAddress = getAddress(\"unit\"); token tokenTransfer = token(tokenAddress); tokenTransfer.transfer(msg.sender, claimTokens); if (isCharged) {getAddress(\"team\").transfer(ethVal / 20);} } else { msg.sender.transfer(ethVal); } Investors[msg.sender] -= ethVal; unClaimedEther -= ethVal; }",
        "vulnerability": "Reentrancy",
        "reason": "The function allows an attacker to reenter the contract during the msg.sender.transfer(ethVal) call. The state changes (Investors[msg.sender] and unClaimedEther updates) occur after the external call, allowing an attacker to potentially drain funds by recursively calling ClaimMTU before the state is updated.",
        "file_name": "0x4470887011bbf1e196b62020266aa5ae1081bd70.sol"
    },
    {
        "function_name": "SendEtherToBoard",
        "code": "function SendEtherToBoard(uint256 weiAmt) onlyAdmin public { require(address(this).balance > unClaimedEther); getAddress(\"board\").transfer(weiAmt); }",
        "vulnerability": "Incorrect balance check",
        "reason": "The function checks if the contract balance is greater than unClaimedEther, but it does not verify if the balance is sufficient to cover the weiAmt being transferred. This could result in failed transactions if weiAmt exceeds the available balance, potentially halting contract operations.",
        "file_name": "0x4470887011bbf1e196b62020266aa5ae1081bd70.sol"
    },
    {
        "function_name": "DepositMTU",
        "code": "function DepositMTU(uint256 NoOfTokens) paused public { require(block.timestamp > RedeemingTimeLimit); address tokenAddress = getAddress(\"unit\"); token tokenFunction = token(tokenAddress); tokenFunction.transferFrom(msg.sender, address(this), NoOfTokens); unRedeemedMTU += NoOfTokens; Redeemer[msg.sender] += NoOfTokens; emit eAllowedMTU(msg.sender, NoOfTokens); }",
        "vulnerability": "Missing allowance check",
        "reason": "The function does not check if the msg.sender has set an adequate allowance for the contract to transfer their tokens. Without this check, the transferFrom call could fail, leading to unexpected behavior or transaction reversion, which might disrupt the contract's functionality.",
        "file_name": "0x4470887011bbf1e196b62020266aa5ae1081bd70.sol"
    }
]