[
    {
        "function_name": "becomeNorsefire",
        "code": "function becomeNorsefire() public payable { require(initialized); address oldNorseAddr = currentNorsefire; uint oldNorsePrice = norsefirePrice.mul(100).div(110); require(msg.value >= norsefirePrice); uint excess = msg.value.sub(norsefirePrice); uint diffFivePct = (norsefirePrice.sub(oldNorsePrice)).div(20); norsefirePrice = norsefirePrice.add(norsefirePrice.div(10)); uint flipPrize = diffFivePct.mul(10); uint marketBoost = diffFivePct.mul(9); address _newNorse = msg.sender; uint _toRefund = (oldNorsePrice.add(flipPrize)); currentNorsefire = _newNorse; oldNorseAddr.send(_toRefund); actualNorse.send(diffFivePct); if (excess > 0){ msg.sender.send(excess); } boostCloneMarket(marketBoost); emit NorsefireSwitch(oldNorseAddr, _newNorse, norsefirePrice, _toRefund, flipPrize, diffFivePct); }",
        "vulnerability": "Unsafe use of send",
        "reason": "The function uses the `send` method for transferring Ether, which only forwards 2300 gas and may fail silently if the recipient is a contract with a fallback function that requires more gas. This could prevent refunds or payouts, especially if any of the recipients are contracts with complex fallback functions.",
        "file_name": "0x3ab4a46beae2a0b025eeed54db05819814ff287a.sol"
    },
    {
        "function_name": "sellIdeas",
        "code": "function sellIdeas() public { require(initialized); address _caller = msg.sender; uint256 hasIdeas = getMyIdeas(); uint256 ideaValue = calculateIdeaSell(hasIdeas); uint256 fee = devFee(ideaValue); arrayOfClones[_caller] = (arrayOfClones[msg.sender].div(4)).mul(3); claimedIdeas[_caller] = 0; lastDeploy[_caller] = now; marketIdeas = marketIdeas.add(hasIdeas); currentNorsefire.send(fee); _caller.send(ideaValue.sub(fee)); emit IdeasSold(_caller, hasIdeas); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function `send` is used without updating the state variables before the call, which could be exploited by a reentrant contract. An attacker could re-enter the function before the state change and drain Ether from the contract.",
        "file_name": "0x3ab4a46beae2a0b025eeed54db05819814ff287a.sol"
    },
    {
        "function_name": "releaseTheOriginal",
        "code": "function releaseTheOriginal(uint256 _ideas) public payable { require(msg.sender == currentNorsefire); require(marketIdeas == 0); initialized = true; marketIdeas = _ideas; boostCloneMarket(msg.value); }",
        "vulnerability": "Privilege escalation vulnerability",
        "reason": "This function allows the `currentNorsefire` to initialize the contract and set `marketIdeas` only if it is zero. If the contract is not initialized correctly or if `marketIdeas` is reset to zero, an attacker with control of `currentNorsefire` could exploit this function to reinitialize the contract in a manner beneficial to them.",
        "file_name": "0x3ab4a46beae2a0b025eeed54db05819814ff287a.sol"
    }
]