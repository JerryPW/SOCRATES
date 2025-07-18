[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address from, address to, uint256 value) public returns (bool) { _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value); _transfer(from, to, value); return true; }",
        "vulnerability": "Lack of checks on allowance before subtraction",
        "reason": "The function `transferFrom` does not check if the allowance for the spender is sufficient before attempting to subtract the `value`. This can result in an underflow if the spender tries to transfer more than allowed, potentially allowing them to transfer any amount of tokens without proper authorization.",
        "file_name": "0x1f42f986f9ef31d6ef787565b211bce0eb877bcc.sol"
    },
    {
        "function_name": "setGameWaveAddress",
        "code": "function setGameWaveAddress(address payable _GameWaveAddress) public { require(address(GameWaveContract) == address(0x0)); GameWaveContract = GameWave(_GameWaveAddress); }",
        "vulnerability": "No access control modifier",
        "reason": "The function `setGameWaveAddress` lacks an access control modifier such as `onlyOwner`. This allows any user to set the `GameWaveContract` address, potentially pointing it to a malicious contract and compromising the integrity of the system.",
        "file_name": "0x1f42f986f9ef31d6ef787565b211bce0eb877bcc.sol"
    },
    {
        "function_name": "calculateProbability",
        "code": "function calculateProbability() public { require(winner == 0 && getState()); totalGWSupplyOfBulls = GameWaveContract.balanceOf(address(BullsContract)); totalGWSupplyOfBears = GameWaveContract.balanceOf(address(BearsContract)); uint256 percent = (totalSupplyOfBulls.add(totalSupplyOfBears)).div(100); if (totalGWSupplyOfBulls < 1 ether) { totalGWSupplyOfBulls = 0; } if (totalGWSupplyOfBears < 1 ether) { totalGWSupplyOfBears = 0; } if (totalGWSupplyOfBulls <= totalGWSupplyOfBears) { uint256 difference = totalGWSupplyOfBears.sub(totalGWSupplyOfBulls).div(0.01 ether); probabilityOfBears = totalSupplyOfBears.mul(100).div(percent).add(estimateTokenPercent(difference)); if (probabilityOfBears > 8000) { probabilityOfBears = 8000; } if (probabilityOfBears < 2000) { probabilityOfBears = 2000; } probabilityOfBulls = 10000 - probabilityOfBears; } else { uint256 difference = totalGWSupplyOfBulls.sub(totalGWSupplyOfBears).div(0.01 ether); probabilityOfBulls = totalSupplyOfBulls.mul(100).div(percent).add(estimateTokenPercent(difference)); if (probabilityOfBulls > 8000) { probabilityOfBulls = 8000; } if (probabilityOfBulls < 2000) { probabilityOfBulls = 2000; } probabilityOfBears = 10000 - probabilityOfBulls; } totalGWSupplyOfBulls = GameWaveContract.balanceOf(address(BullsContract)); totalGWSupplyOfBears = GameWaveContract.balanceOf(address(BearsContract)); }",
        "vulnerability": "Lack of access control",
        "reason": "The function `calculateProbability` can be called by any user, which might lead to manipulation or unintended recalculations of probabilities. This could potentially allow attackers to influence the probability calculations repeatedly until a favorable outcome is achieved.",
        "file_name": "0x1f42f986f9ef31d6ef787565b211bce0eb877bcc.sol"
    }
]