[
    {
        "function_name": "deposit",
        "code": "function deposit(bytes32 _commitment) external payable nonReentrant returns (bytes32 commitment, uint32 insertedIndex, uint256 blocktime, uint256 M87Deno, uint256 fee){ require(!commitments[_commitment], \"The commitment has been submitted\"); require(msg.value >= coinDenomination, \"insufficient coin amount\"); commitment = _commitment; blocktime = block.timestamp; uint256 refund = msg.value - coinDenomination; insertedIndex = _insert(_commitment); commitments[_commitment] = true; M87Deno = M87Denomination(); fee = anonymityFee; uint256 td = tokenDenomination; if (td > 0) { token.safeTransferFrom(msg.sender, address(this), td); } accumulateM87 += M87Deno; numOfShares += 1; if (refund > 0) { (bool success, ) = msg.sender.call.value(refund)(\"\"); require(success, \"failed to refund\"); } collectedFee += feeToCollectAmount; if(collectedFee > overMinEth) { swapAndShare(); } else { sendRewardtoPool(); } updateBlockReward(); emit Deposit(_commitment, insertedIndex, block.timestamp, M87Deno, fee); }",
        "vulnerability": "Use of deprecated 'call.value' for refunds",
        "reason": "The use of 'call.value' for sending Ether can lead to reentrancy vulnerabilities. The contract attempts to refund excess Ether, but using 'call.value' in this way is unsafe because it can be exploited by reentrant calls. A safer approach would be to use 'transfer' or 'send', which have a fixed gas stipend.",
        "file_name": "0x1963737af12d3649f6f319fb64af2aa29f7256b7.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(bytes calldata _proof, bytes32 _root, bytes32 _nullifierHash, address payable _recipient, address payable _relayer, uint256 _relayerFee, uint256 _refund) external payable nonReentrant { require(_refund == 0, \"refund is not zero\"); require(!Address.isContract(_recipient), \"recipient of cannot be contract\"); require(isKnownRoot(_root), \"Cannot find your merkle root\"); require(verifier.verifyProof(_proof, [uint256(_root), uint256(_nullifierHash), uint256(_recipient), uint256(_relayer), _relayerFee, _refund]), \"Invalid withdraw proof\"); verifier.verifyNullifier(_nullifierHash); uint256 td = tokenDenomination; if (td > 0) { safeTransfer(token, _recipient, td); } updateBlockReward(); uint256 relayerFee = 0; uint256 M87Deno = getAccumulateM87().div(numOfShares); if (M87Deno > 0) { accumulateM87 -= M87Deno; safeTransfer(M87Token, _recipient, M87Deno); } uint256 cd = coinDenomination - feeToCollectAmount; if (_relayerFee > cd) { _relayerFee = cd; } if (_relayerFee > 0) { (bool success,) = _relayer.call.value(_relayerFee)(\"\"); require(success, \"failed to send relayer fee\"); cd -= _relayerFee; } if (cd > 0) { (bool success,) = _recipient.call.value(cd)(\"\"); require(success, \"failed to withdraw coin\"); } numOfShares -= 1; sendRewardtoPool(); emit Withdrawal(_recipient, _nullifierHash, _relayer, M87Deno, relayerFee); }",
        "vulnerability": "Use of deprecated 'call.value' for Ether transfers",
        "reason": "Using 'call.value' for sending Ether to '_recipient' and '_relayer' can be exploited via reentrancy attacks. This pattern is no longer recommended in Solidity due to its potential for vulnerabilities. Instead, using 'transfer' or 'send' is safer as they provide a fixed gas stipend that limits the execution of further code.",
        "file_name": "0x1963737af12d3649f6f319fb64af2aa29f7256b7.sol"
    },
    {
        "function_name": "forceSwapAndShare",
        "code": "function forceSwapAndShare() public onlyOwner { swapAndShare(); }",
        "vulnerability": "Potential for front-running attacks",
        "reason": "The 'forceSwapAndShare' function can be called by the owner to execute 'swapAndShare', which involves swapping tokens on Uniswap. This can be front-run by other users or bots who detect the transaction and execute trades in anticipation, potentially leading to unfavorable swap rates and financial losses for the contract.",
        "file_name": "0x1963737af12d3649f6f319fb64af2aa29f7256b7.sol"
    }
]