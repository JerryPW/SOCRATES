[
    {
        "function_name": "becomeNorsefire",
        "code": "function becomeNorsefire() public payable { require(initialized); address oldNorseAddr = currentNorsefire; uint oldNorsePrice = norsefirePrice.mul(100).div(110); require(msg.value >= norsefirePrice); uint excess = msg.value.sub(norsefirePrice); uint diffFivePct = (norsefirePrice.sub(oldNorsePrice)).div(20); norsefirePrice = norsefirePrice.add(norsefirePrice.div(10)); uint flipPrize = diffFivePct.mul(10); uint marketBoost = diffFivePct.mul(9); address _newNorse = msg.sender; uint _toRefund = (oldNorsePrice.add(flipPrize)); currentNorsefire = _newNorse; oldNorseAddr.send(_toRefund); actualNorse.send(diffFivePct); if (excess > 0){ msg.sender.send(excess); } boostCloneMarket(marketBoost); emit NorsefireSwitch(oldNorseAddr, _newNorse, norsefirePrice, _toRefund, flipPrize, diffFivePct); }",
        "vulnerability": "Unsafe use of 'send' for Ether transfer",
        "reason": "The function uses the 'send' method to transfer Ether, which is not recommended due to its potential to fail silently. If it fails, the state changes are not reverted, leaving the contract in an inconsistent state and potentially causing loss of funds or intended functionality.",
        "file_name": "0x3ab4a46beae2a0b025eeed54db05819814ff287a.sol"
    },
    {
        "function_name": "sellIdeas",
        "code": "function sellIdeas() public { require(initialized); address _caller = msg.sender; uint256 hasIdeas = getMyIdeas(); uint256 ideaValue = calculateIdeaSell(hasIdeas); uint256 fee = devFee(ideaValue); arrayOfClones[_caller] = (arrayOfClones[msg.sender].div(4)).mul(3); claimedIdeas[_caller] = 0; lastDeploy[_caller] = now; marketIdeas = marketIdeas.add(hasIdeas); currentNorsefire.send(fee); _caller.send(ideaValue.sub(fee)); emit IdeasSold(_caller, hasIdeas); }",
        "vulnerability": "Unsafe use of 'send' for Ether transfer",
        "reason": "The function uses the 'send' method to transfer Ether to both 'currentNorsefire' and '_caller'. This is unsafe because 'send' only forwards 2300 gas, which may not be enough for the receiving contract to execute logic, and it does not revert on failure, leading to potential loss of funds or logical errors.",
        "file_name": "0x3ab4a46beae2a0b025eeed54db05819814ff287a.sol"
    },
    {
        "function_name": "hijackClones",
        "code": "function hijackClones() public payable{ require(initialized); require(msg.value==0.00232 ether); address _caller = msg.sender; currentNorsefire.send(msg.value); require(arrayOfClones[_caller]==0); lastDeploy[_caller] = now; arrayOfClones[_caller] = starting_clones; }",
        "vulnerability": "Potential DoS with 'send' function",
        "reason": "The use of 'send' for transferring Ether to 'currentNorsefire' may result in a Denial of Service (DoS) if the 'currentNorsefire' address is a contract that cannot receive funds or if the transfer fails for any reason. This would prevent the function from proceeding, causing a halt in execution.",
        "file_name": "0x3ab4a46beae2a0b025eeed54db05819814ff287a.sol"
    }
]