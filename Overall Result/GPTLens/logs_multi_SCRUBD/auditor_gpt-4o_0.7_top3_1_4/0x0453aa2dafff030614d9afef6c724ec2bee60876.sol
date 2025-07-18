[
    {
        "function_name": "withdrawEth",
        "code": "function withdrawEth() external onlyOwner { (bool os,) = payable(owner).call{value:address(this).balance}(\"\"); require(os); }",
        "vulnerability": "Potential reentrancy via call",
        "reason": "The withdrawEth function uses a low-level call to transfer Ether to the owner. Though it is guarded by the nonReentrant modifier, such calls can introduce vulnerabilities, especially if future modifications or interactions with external contracts occur. It is safer to use transfer or send for Ether transfers to minimize risks, even if the reentrancy guard is in place.",
        "file_name": "0x0453aa2dafff030614d9afef6c724ec2bee60876.sol"
    },
    {
        "function_name": "stakeTokens",
        "code": "function stakeTokens(string calldata symbol, uint tokenQuantity) external nonReentrant { require(tokens[symbol].tokenId > 0, 'This token cannot be staked'); require(tx.origin == msg.sender, \"Nice Try\"); require(stakingOn == true, \"Staking Off\"); IERC20(tokens[symbol].tokenAddress).transferFrom(msg.sender, address(this), tokenQuantity); uint taxesTaken = (tokenQuantity * 5) / 100; uint actualTokensThatWentIn = tokenQuantity - taxesTaken; uint stakingApr = apr; uint perWeekPayment = calculatePerWeekPayment(stakingApr, actualTokensThatWentIn); positions[currentPositionId] = Position( currentPositionId, msg.sender, symbol, actualTokensThatWentIn, block.timestamp, perWeekPayment, block.timestamp + (7 * 1 days), 0, apr, true, true ); positionsIdsByAddress[msg.sender].push(currentPositionId); currentPositionId += 1; }",
        "vulnerability": "Lack of slippage protection",
        "reason": "The stakeTokens function does not account for token slippage during the transferFrom operation. If the token has transfer fees or taxes that are not accounted for, the contract could end up with fewer tokens than expected, causing discrepancies in the staking logic and potential loss of funds for the user.",
        "file_name": "0x0453aa2dafff030614d9afef6c724ec2bee60876.sol"
    },
    {
        "function_name": "receiveWeekProfits",
        "code": "function receiveWeekProfits(uint positionId) external nonReentrant { require(tx.origin == msg.sender, \"Nice Try\"); require(stakingOn == true, \"Staking Off\"); require(positions[positionId].open == true, 'Position already closed'); require(positions[positionId].walletAddress == msg.sender, 'Not the owner of this position.'); require(block.timestamp > positions[positionId].nextWeekUnlockDate, 'Weekly profit withdrawal date in a couple days.'); positions[positionId].apy = apr; positions[positionId].profitsPerWeek = calculatePerWeekPayment(positions[positionId].apy, positions[positionId].tokenQuantity); positions[positionId].profitsReclaimed += (positions[positionId].profitsPerWeek); positions[positionId].nextWeekUnlockDate = block.timestamp + (7 * 1 days); uint amountToPay = (positions[positionId].profitsPerWeek / amountOfTokenPerEth) * 1000000000; (bool os,) = payable(msg.sender).call{value: amountToPay}(\"\"); require(os); }",
        "vulnerability": "Arithmetic precision error",
        "reason": "The receiveWeekProfits function calculates the amountToPay using division and multiplication, which can lead to significant precision loss due to Solidity's lack of floating-point arithmetic. This precision loss can result in incorrect payouts, potentially allowing an attacker to exploit these rounding errors for financial gain or causing honest users to receive less than their expected profits.",
        "file_name": "0x0453aa2dafff030614d9afef6c724ec2bee60876.sol"
    }
]