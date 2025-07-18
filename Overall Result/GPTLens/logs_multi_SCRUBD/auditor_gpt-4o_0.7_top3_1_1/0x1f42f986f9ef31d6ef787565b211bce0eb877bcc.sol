[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom( address from, address to, uint256 value ) public returns (bool) { _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value); _transfer(from, to, value); return true; }",
        "vulnerability": "Missing approval check",
        "reason": "The transferFrom function does not properly check if the sender has sufficient allowance before performing the transfer. This can lead to unauthorized transfers if the allowance is not correctly managed.",
        "file_name": "0x1f42f986f9ef31d6ef787565b211bce0eb877bcc.sol"
    },
    {
        "function_name": "getWinners",
        "code": "function getWinners() public { require(winner == 0 && !getState()); uint256 seed1 = address(this).balance; uint256 seed2 = totalSupplyOfBulls; uint256 seed3 = totalSupplyOfBears; uint256 seed4 = totalGWSupplyOfBulls; uint256 seed5 = totalGWSupplyOfBulls; uint256 seed6 = block.difficulty; uint256 seed7 = block.timestamp; bytes32 randomHash = keccak256(abi.encodePacked(seed1, seed2, seed3, seed4, seed5, seed6, seed7)); uint randomNumber = uint(randomHash); if (randomNumber == 0){ randomNumber = 1; } uint winningNumber = randomNumber % 10000; if (1 <= winningNumber && winningNumber <= probabilityOfBears){ winner = 1; } if (probabilityOfBears < winningNumber && winningNumber <= 10000){ winner = 2; } if (GameWaveContract.balanceOf(address(BullsContract)) > 0) GameWaveContract.transferFrom( address(BullsContract), address(this), GameWaveContract.balanceOf(address(BullsContract)) ); if (GameWaveContract.balanceOf(address(BearsContract)) > 0) GameWaveContract.transferFrom( address(BearsContract), address(this), GameWaveContract.balanceOf(address(BearsContract)) ); lastTotalSupplyOfBulls = totalSupplyOfBulls; lastTotalSupplyOfBears = totalSupplyOfBears; lastTotalGWSupplyOfBears = totalGWSupplyOfBears; lastTotalGWSupplyOfBulls = totalGWSupplyOfBulls; lastRoundHero = lastHero; lastJackPot = jackPot; lastWinner = winner; lastCountOfBears = countOfBears; lastCountOfBulls = countOfBulls; lastWithdrawn = withdrawn; lastWithdrawnGW = withdrawnGW; if (lastBalance > lastWithdrawn){ remainder = lastBalance.sub(lastWithdrawn); address(GameWaveContract).transfer(remainder); } lastBalance = lastTotalSupplyOfBears.add(lastTotalSupplyOfBulls).add(lastJackPot); if (lastBalanceGW > lastWithdrawnGW){ remainderGW = lastBalanceGW.sub(lastWithdrawnGW); tokenReturn = (totalGWSupplyOfBears.add(totalGWSupplyOfBulls)).mul(20).div(100).add(remainderGW); GameWaveContract.transfer(crowdSale, tokenReturn); } lastBalanceGW = GameWaveContract.balanceOf(address(this)); totalSupplyOfBulls = 0; totalSupplyOfBears = 0; totalGWSupplyOfBulls = 0; totalGWSupplyOfBears = 0; remainder = 0; remainderGW = 0; jackPot = 0; withdrawn = 0; winner = 0; withdrawnGW = 0; countOfBears = 0; countOfBulls = 0; probabilityOfBulls = 0; probabilityOfBears = 0; _setRoundTime(defaultCurrentDeadlineInHours, defaultLastDeadlineInHours); currentRound++; }",
        "vulnerability": "Predictable randomness",
        "reason": "The random number generation in getWinners uses predictable variables like block.timestamp and block.difficulty, making it vulnerable to manipulation and prediction by miners, potentially allowing them to influence the outcome.",
        "file_name": "0x1f42f986f9ef31d6ef787565b211bce0eb877bcc.sol"
    },
    {
        "function_name": "withdrawDividends",
        "code": "function withdrawDividends(address payable _holder) public returns(uint) { uint dividends = getDividends(_holder); lastWithdrawTime[_holder] = block.timestamp; lastTotalPaymentAmount = lastTotalPaymentAmount.add(dividends); _holder.transfer(dividends); }",
        "vulnerability": "Reentrancy attack",
        "reason": "The withdrawDividends function is vulnerable to reentrancy attacks as it updates the state variables after the transfer function. This allows an attacker to call the function repeatedly before the state is updated, potentially withdrawing more funds than intended.",
        "file_name": "0x1f42f986f9ef31d6ef787565b211bce0eb877bcc.sol"
    }
]