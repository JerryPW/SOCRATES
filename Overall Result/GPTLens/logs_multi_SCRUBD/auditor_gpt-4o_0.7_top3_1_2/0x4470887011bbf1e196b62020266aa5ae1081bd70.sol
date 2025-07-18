[
    {
        "function_name": "ClaimMTU",
        "code": "function ClaimMTU(bool claim) paused public { uint256 ethVal = Investors[msg.sender]; require(ethVal >= claimRate); if (claim) { require(claimRate > 0); require(block.timestamp < ClaimingTimeLimit); ethRaised += ethVal; uint256 claimTokens = ethVal / claimRate; address tokenAddress = getAddress(\"unit\"); token tokenTransfer = token(tokenAddress); tokenTransfer.transfer(msg.sender, claimTokens); if (isCharged) {getAddress(\"team\").transfer(ethVal / 20);} } else { msg.sender.transfer(ethVal); } Investors[msg.sender] -= ethVal; unClaimedEther -= ethVal; }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function allows an attacker to exploit the reentrancy vulnerability by calling the fallback function within the same transaction. When `msg.sender.transfer(ethVal);` is executed, control is passed back to `msg.sender`, who can recursively call `ClaimMTU` again before the `Investors[msg.sender] -= ethVal;` line is executed, allowing the attacker to drain funds.",
        "file_name": "0x4470887011bbf1e196b62020266aa5ae1081bd70.sol"
    },
    {
        "function_name": "SendEtherToBoard",
        "code": "function SendEtherToBoard(uint256 weiAmt) onlyAdmin public { require(address(this).balance > unClaimedEther); getAddress(\"board\").transfer(weiAmt); }",
        "vulnerability": "Unchecked Transfer Amount",
        "reason": "The function does not check if `weiAmt` is less than or equal to the contract's balance minus `unClaimedEther`. This allows an admin to transfer more Ether than the contract should allow, potentially depleting funds reserved for investors.",
        "file_name": "0x4470887011bbf1e196b62020266aa5ae1081bd70.sol"
    },
    {
        "function_name": "DepositMTU",
        "code": "function DepositMTU(uint256 NoOfTokens) paused public { require(block.timestamp > RedeemingTimeLimit); address tokenAddress = getAddress(\"unit\"); token tokenFunction = token(tokenAddress); tokenFunction.transferFrom(msg.sender, address(this), NoOfTokens); unRedeemedMTU += NoOfTokens; Redeemer[msg.sender] += NoOfTokens; emit eAllowedMTU(msg.sender, NoOfTokens); }",
        "vulnerability": "Lack of Approval Check",
        "reason": "The function does not check if the user has given the contract sufficient allowance before calling `transferFrom`. This could lead to failed transactions and potential denial of service if the allowance is not properly set by the user.",
        "file_name": "0x4470887011bbf1e196b62020266aa5ae1081bd70.sol"
    }
]