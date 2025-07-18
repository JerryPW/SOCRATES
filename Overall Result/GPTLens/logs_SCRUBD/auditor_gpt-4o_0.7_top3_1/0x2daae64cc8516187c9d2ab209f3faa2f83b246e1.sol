[
    {
        "function_name": "submitProposal",
        "code": "function submitProposal( address applicant, uint256 sharesRequested, uint256 lootRequested, uint256 tributeOffered, address tributeToken, uint256 paymentRequested, address paymentToken, bytes32 details ) payable external nonReentrant returns (uint256 proposalId) { require(sharesRequested.add(lootRequested) <= MAX_GUILD_BOUND, \"guild maxed\"); require(tokenWhitelist[tributeToken], \"tributeToken not whitelisted\"); require(tokenWhitelist[paymentToken], \"paymentToken not whitelisted\"); require(applicant != GUILD && applicant != ESCROW && applicant != TOTAL, \"applicant unreservable\"); require(members[applicant].jailed == 0, \"applicant jailed\"); if (tributeOffered > 0 && userTokenBalances[GUILD][tributeToken] == 0) { require(totalGuildBankTokens < MAX_TOKEN_GUILDBANK_COUNT, \"guildbank maxed\"); } if (tributeToken == wETH && msg.value > 0) { require(msg.value == tributeOffered, \"insufficient ETH\"); IWETH(wETH).deposit(); (bool success, ) = wETH.call.value(msg.value)(\"\"); require(success, \"transfer failed\"); IWETH(wETH).transfer(address(this), msg.value); } else { IERC20(tributeToken).transferFrom(msg.sender, address(this), tributeOffered); } unsafeAddToBalance(ESCROW, tributeToken, tributeOffered); uint8[7] memory flags; _submitProposal(applicant, sharesRequested, lootRequested, tributeOffered, tributeToken, paymentRequested, paymentToken, details, flags); return proposalCount - 1; }",
        "vulnerability": "Potential reentrancy attack in ETH deposit",
        "reason": "The function allows for ETH to be sent, and then it calls an external contract (IWETH). Even though the function is marked as nonReentrant, reentrancy can occur if the IWETH contract itself is vulnerable. This could be exploited by malicious contracts to repeatedly call back into the function before the state is updated.",
        "file_name": "0x2daae64cc8516187c9d2ab209f3faa2f83b246e1.sol"
    },
    {
        "function_name": "processGuildActionProposal",
        "code": "function processGuildActionProposal(uint256 proposalIndex) external nonReentrant returns (bytes memory) { _validateProposalForProcessing(proposalIndex); uint256 proposalId = proposalQueue[proposalIndex]; Action storage action = actions[proposalId]; Proposal storage proposal = proposals[proposalId]; require(proposal.flags[6] == 1, \"not action proposal\"); proposal.flags[1] = 1; bool didPass = _didPass(proposalIndex); if (didPass == true) { proposal.flags[2] = 1; require(address(this).balance >= action.value, \"insufficient ether\"); (bool success, bytes memory retData) = action.to.call.value(action.value)(action.data); require(success, \"call failure\"); return retData; } emit ProcessGuildActionProposal(proposalIndex, proposalId, didPass); }",
        "vulnerability": "Arbitrary external call execution",
        "reason": "The function allows arbitrary calls to be made to any contract, with any data and value, if a proposal passes. This means that if a proposal is crafted maliciously and passes, it could execute any arbitrary code, potentially transferring funds or disrupting the contract's state.",
        "file_name": "0x2daae64cc8516187c9d2ab209f3faa2f83b246e1.sol"
    },
    {
        "function_name": "transfer",
        "code": "function transfer(address receiver, uint256 lootToTransfer) external { members[msg.sender].loot = members[msg.sender].loot.sub(lootToTransfer); members[receiver].loot = members[msg.sender].loot.add(lootToTransfer); balances[msg.sender] -= lootToTransfer; balances[receiver] += lootToTransfer; emit Transfer(msg.sender, receiver, lootToTransfer); }",
        "vulnerability": "Incorrect state update logic",
        "reason": "The function incorrectly updates the receiver's loot balance by adding the sender's loot balance instead of the amount to transfer. This logic error allows an attacker to manipulate state to incorrectly increase balances, leading to potential unauthorized fund allocation.",
        "file_name": "0x2daae64cc8516187c9d2ab209f3faa2f83b246e1.sol"
    }
]