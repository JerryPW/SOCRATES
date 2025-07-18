[
    {
        "function_name": "refund",
        "code": "function refund() public { require(state == State.Failed); if (now < completedAt.add(90 days)){ uint256 holderTokens = tokensSent[msg.sender]; tokensSent[msg.sender] = 0; balance[msg.sender] = 0; uint256 holderETH = ethOnContract[msg.sender]; ethOnContract[msg.sender] = 0; require(tokenReward.transferFrom(msg.sender,address(this),holderTokens)); msg.sender.transfer(holderETH); emit LogRefund(msg.sender,holderETH); } else{ require(level[msg.sender] >= 2); uint256 remanent = tokenReward.balanceOf(this); creator.transfer(address(this).balance); tokenReward.transfer(creator,remanent); emit LogBeneficiaryPaid(creator); emit LogContributorsPayout(creator, remanent); } }",
        "vulnerability": "tokensSent manipulation risk",
        "reason": "The refund function allows users to transfer tokens back to the contract and receive their ETH refund. However, there is no verification that the tokens transferred back are equal to the amount initially received, allowing users to potentially send fewer tokens for a full refund.",
        "file_name": "0x0bc95951bb59d6fd063ce7ad5c3b3dcaace98132.sol"
    },
    {
        "function_name": "claimTokensByAdmin",
        "code": "function claimTokensByAdmin(address _target) onlyAdmin(1) public { require(KYCValid[_target] == true); uint256 tokens = balance[_target]; balance[_target] = 0; require(tokenReward.transfer(_target, tokens)); tokensSent[_target] = tokensSent[_target].add(tokens); emit LogContributorsPayout(_target, tokens); }",
        "vulnerability": "Admin privilege abuse",
        "reason": "The claimTokensByAdmin function allows an admin with level 1 to transfer tokens to a target user without any additional checks. This could be abused by a malicious admin to drain tokens if any mistake is made in balance calculations or if tokens are added maliciously.",
        "file_name": "0x0bc95951bb59d6fd063ce7ad5c3b3dcaace98132.sol"
    },
    {
        "function_name": "externalTokensRecovery",
        "code": "function externalTokensRecovery(ERC20Basic _address) onlyAdmin(2) public{ require(_address != tokenReward); uint256 remainder = _address.balanceOf(this); _address.transfer(msg.sender,remainder); }",
        "vulnerability": "Lack of access control on token recovery",
        "reason": "The externalTokensRecovery function allows admin level 2 to transfer any tokens other than tokenReward from the contract to themselves. Without proper checks or limitations, an admin could potentially misuse this function to drain tokens from the contract.",
        "file_name": "0x0bc95951bb59d6fd063ce7ad5c3b3dcaace98132.sol"
    }
]