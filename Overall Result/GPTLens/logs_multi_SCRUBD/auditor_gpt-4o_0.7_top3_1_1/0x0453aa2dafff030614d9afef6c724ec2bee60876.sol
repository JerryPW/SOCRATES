[
    {
        "function_name": "withdrawEth",
        "code": "function withdrawEth() external onlyOwner { (bool os,) = payable(owner).call{value:address(this).balance}(\"\"); require(os); }",
        "vulnerability": "Denial of Service",
        "reason": "The withdrawEth function allows the owner to withdraw all Ether from the contract using a call. If the owner is an externally owned account (EOA) with a fallback function that consumes more than 2300 gas, the transaction could fail, making it impossible to withdraw Ether. This could lead to a denial of service for the owner.",
        "file_name": "0x0453aa2dafff030614d9afef6c724ec2bee60876.sol"
    },
    {
        "function_name": "closePosition",
        "code": "function closePosition(uint positionId) external nonReentrant { require(tx.origin == msg.sender, \"Nice Try\"); require(positions[positionId].walletAddress == msg.sender, 'Not the owner of this position'); require(positions[positionId].open == true, 'Position already closed'); IERC20(tokens[positions[positionId].symbol].tokenAddress).transfer(msg.sender, positions[positionId].tokenQuantity); positions[positionId].open = false; positions[positionId].tokenQuantity = 0; positions[positionId].profitsPerWeek = 0; }",
        "vulnerability": "Missing Event Emission",
        "reason": "The closePosition function closes a staking position and transfers tokens back to the user. However, it does not emit any events to signal that the position has been closed. This lack of transparency can make it difficult for users and third parties to track changes in the contract state, potentially leading to trust issues or disputes.",
        "file_name": "0x0453aa2dafff030614d9afef6c724ec2bee60876.sol"
    },
    {
        "function_name": "receiveWeekProfits",
        "code": "function receiveWeekProfits(uint positionId) external nonReentrant { require(tx.origin == msg.sender, \"Nice Try\"); require(stakingOn == true, \"Staking Off\"); require(positions[positionId].open == true, 'Position already closed'); require(positions[positionId].walletAddress == msg.sender, 'Not the owner of this position.'); require(block.timestamp > positions[positionId].nextWeekUnlockDate, 'Weekly profit withdrawal date in a couple days.'); positions[positionId].apy = apr; positions[positionId].profitsPerWeek = calculatePerWeekPayment(positions[positionId].apy, positions[positionId].tokenQuantity); positions[positionId].profitsReclaimed += (positions[positionId].profitsPerWeek); positions[positionId].nextWeekUnlockDate = block.timestamp + (7 * 1 days); uint amountToPay = (positions[positionId].profitsPerWeek / amountOfTokenPerEth) * 1000000000; (bool os,) = payable(msg.sender).call{value: amountToPay}(\"\"); require(os); }",
        "vulnerability": "Arithmetic Precision Loss",
        "reason": "The receiveWeekProfits function calculates the amount to pay out as weekly profits using integer division, which can lead to a loss of precision. This can result in the user receiving less Ether than they are entitled to, especially if the profits are small relative to the amountOfTokenPerEth.",
        "file_name": "0x0453aa2dafff030614d9afef6c724ec2bee60876.sol"
    }
]