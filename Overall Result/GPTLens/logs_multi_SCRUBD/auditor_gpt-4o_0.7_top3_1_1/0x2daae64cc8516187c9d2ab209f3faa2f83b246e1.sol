[
    {
        "function_name": "submitProposal",
        "code": "function submitProposal( address applicant, uint256 sharesRequested, uint256 lootRequested, uint256 tributeOffered, address tributeToken, uint256 paymentRequested, address paymentToken, bytes32 details ) payable external nonReentrant returns (uint256 proposalId) { require(sharesRequested.add(lootRequested) <= MAX_GUILD_BOUND, \"guild maxed\"); require(tokenWhitelist[tributeToken], \"tributeToken not whitelisted\"); require(tokenWhitelist[paymentToken], \"paymentToken not whitelisted\"); require(applicant != GUILD && applicant != ESCROW && applicant != TOTAL, \"applicant unreservable\"); require(members[applicant].jailed == 0, \"applicant jailed\"); if (tributeOffered > 0 && userTokenBalances[GUILD][tributeToken] == 0) { require(totalGuildBankTokens < MAX_TOKEN_GUILDBANK_COUNT, \"guildbank maxed\"); } if (tributeToken == wETH && msg.value > 0) { require(msg.value == tributeOffered, \"insufficient ETH\"); IWETH(wETH).deposit(); (bool success, ) = wETH.call.value(msg.value)(\"\"); require(success, \"transfer failed\"); IWETH(wETH).transfer(address(this), msg.value); } else { IERC20(tributeToken).transferFrom(msg.sender, address(this), tributeOffered); } unsafeAddToBalance(ESCROW, tributeToken, tributeOffered); uint8[7] memory flags; _submitProposal(applicant, sharesRequested, lootRequested, tributeOffered, tributeToken, paymentRequested, paymentToken, details, flags); return proposalCount - 1; }",
        "vulnerability": "Improper ETH handling",
        "reason": "The function directly calls wETH's `deposit` and `transfer` functions without proper checks, and allows fallback calls with `call.value(msg.value)(\"\")`. This could be exploited if the wETH contract is malicious or has vulnerabilities.",
        "file_name": "0x2daae64cc8516187c9d2ab209f3faa2f83b246e1.sol"
    },
    {
        "function_name": "processGuildActionProposal",
        "code": "function processGuildActionProposal(uint256 proposalIndex) external nonReentrant returns (bytes memory) { _validateProposalForProcessing(proposalIndex); uint256 proposalId = proposalQueue[proposalIndex]; Action storage action = actions[proposalId]; Proposal storage proposal = proposals[proposalId]; require(proposal.flags[6] == 1, \"not action proposal\"); proposal.flags[1] = 1; bool didPass = _didPass(proposalIndex); if (didPass == true) { proposal.flags[2] = 1; require(address(this).balance >= action.value, \"insufficient ether\"); (bool success, bytes memory retData) = action.to.call.value(action.value)(action.data); require(success, \"call failure\"); return retData; } emit ProcessGuildActionProposal(proposalIndex, proposalId, didPass); }",
        "vulnerability": "Reentrancy risk via external call",
        "reason": "In the function, an external call is made using `.call.value(action.value)(action.data)`, which allows any external contract to reenter the contract, potentially exploiting any state changes made before this call.",
        "file_name": "0x2daae64cc8516187c9d2ab209f3faa2f83b246e1.sol"
    },
    {
        "function_name": "transfer",
        "code": "function transfer(address receiver, uint256 lootToTransfer) external { members[msg.sender].loot = members[msg.sender].loot.sub(lootToTransfer); members[receiver].loot = members[msg.sender].loot.add(lootToTransfer); balances[msg.sender] -= lootToTransfer; balances[receiver] += lootToTransfer; emit Transfer(msg.sender, receiver, lootToTransfer); }",
        "vulnerability": "Incorrect balance update logic",
        "reason": "The function attempts to update the `members[receiver].loot` by adding `lootToTransfer` to `members[msg.sender].loot`, which is incorrect and allows sender's loot to be mistakenly added to the receiver's loot. It should be `members[receiver].loot = members[receiver].loot.add(lootToTransfer);`.",
        "file_name": "0x2daae64cc8516187c9d2ab209f3faa2f83b246e1.sol"
    }
]