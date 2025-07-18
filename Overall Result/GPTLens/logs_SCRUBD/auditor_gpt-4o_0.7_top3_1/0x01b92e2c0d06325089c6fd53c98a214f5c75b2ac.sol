[
    {
        "function_name": "submitProposal",
        "code": "function submitProposal( address applicant, uint256 sharesRequested, uint256 lootRequested, uint256 tributeOffered, address tributeToken, uint256 paymentRequested, address paymentToken, bytes32 details ) external nonReentrant payable returns (uint256 proposalId) { require(sharesRequested.add(lootRequested) <= MAX_GUILD_BOUND, \"guild maxed\"); require(tokenWhitelist[tributeToken], \"tributeToken != whitelist\"); require(tokenWhitelist[paymentToken], \"paymentToken != whitelist\"); require(applicant != GUILD && applicant != ESCROW && applicant != TOTAL, \"applicant unreservable\"); require(members[applicant].jailed == 0, \"applicant jailed\"); if (tributeOffered > 0 && userTokenBalances[GUILD][tributeToken] == 0) { require(totalGuildBankTokens < MAX_TOKEN_GUILDBANK_COUNT, \"guildbank maxed\"); } if (msg.value > 0) { require(tributeToken == wETH && msg.value == tributeOffered, \"!ethBalance\"); (bool success, ) = wETH.call{value: msg.value}(\"\"); require(success, \"!ethCall\"); IERC20(wETH).safeTransfer(address(this), msg.value); } else { IERC20(tributeToken).safeTransferFrom(msg.sender, address(this), tributeOffered); } unsafeAddToBalance(ESCROW, tributeToken, tributeOffered); uint8[8] memory flags; flags[7] = 1; _submitProposal(applicant, sharesRequested, lootRequested, tributeOffered, tributeToken, paymentRequested, paymentToken, details, flags, \"\"); return proposalCount - 1; }",
        "vulnerability": "ETH transfer to wETH contract without proper handling",
        "reason": "The code attempts to wrap ETH by directly calling the fallback function of the wETH contract without ensuring that the contract is a legitimate wETH contract. This could lead to loss of funds if the address is not properly verified or if the call fails silently.",
        "file_name": "0x01b92e2c0d06325089c6fd53c98a214f5c75b2ac.sol"
    },
    {
        "function_name": "processActionProposal",
        "code": "function processActionProposal(uint256 proposalIndex) external nonReentrant returns (bool, bytes memory) { _validateProposalForProcessing(proposalIndex); uint256 proposalId = proposalQueue[proposalIndex]; bytes storage action = actions[proposalId]; Proposal storage proposal = proposals[proposalId]; require(proposal.flags[6] == 1, \"!action\"); proposal.flags[1] = 1; bool didPass = _didPass(proposalIndex); if (tokenWhitelist[proposal.applicant] && proposal.paymentRequested > userTokenBalances[GUILD][proposal.applicant]) { didPass = false; } if (proposal.tributeOffered > address(this).balance) { didPass = false; } if (didPass) { proposal.flags[2] = 1; (bool success, bytes memory returnData) = proposal.applicant.call{value: proposal.tributeOffered}(action); if (tokenWhitelist[proposal.applicant]) { unsafeSubtractFromBalance(GUILD, proposal.applicant, proposal.paymentRequested); if (userTokenBalances[GUILD][proposal.applicant] == 0 && proposal.paymentRequested > 0) {totalGuildBankTokens -= 1;} } return (success, returnData); } _returnDeposit(proposal.sponsor); emit ProcessActionProposal(proposalIndex, proposalId, didPass); }",
        "vulnerability": "Reentrancy through external call",
        "reason": "The function calls an external address with a value transfer and arbitrary data, which can lead to reentrancy vulnerabilities if the called contract is malicious and modifies the contract's state in unexpected ways. While the function is marked nonReentrant, the external call still presents a risk, especially when interacting with unknown contracts.",
        "file_name": "0x01b92e2c0d06325089c6fd53c98a214f5c75b2ac.sol"
    },
    {
        "function_name": "unsafeInternalTransfer",
        "code": "function unsafeInternalTransfer(address from, address to, address token, uint256 amount) internal { unsafeSubtractFromBalance(from, token, amount); unsafeAddToBalance(to, token, amount); }",
        "vulnerability": "Lack of proper balance checks",
        "reason": "The function performs balance transfers without verifying that the 'from' address has sufficient balance. This can lead to underflows and incorrect balance states, allowing an attacker to manipulate internal balances and extract funds they do not own.",
        "file_name": "0x01b92e2c0d06325089c6fd53c98a214f5c75b2ac.sol"
    }
]