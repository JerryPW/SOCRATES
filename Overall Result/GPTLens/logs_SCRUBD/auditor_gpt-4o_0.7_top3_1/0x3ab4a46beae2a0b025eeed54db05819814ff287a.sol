[
    {
        "function_name": "becomeNorsefire",
        "code": "function becomeNorsefire() public payable { require(initialized); address oldNorseAddr = currentNorsefire; uint oldNorsePrice = norsefirePrice.mul(100).div(110); require(msg.value >= norsefirePrice); uint excess = msg.value.sub(norsefirePrice); uint diffFivePct = (norsefirePrice.sub(oldNorsePrice)).div(20); norsefirePrice = norsefirePrice.add(norsefirePrice.div(10)); uint flipPrize = diffFivePct.mul(10); uint marketBoost = diffFivePct.mul(9); address _newNorse = msg.sender; uint _toRefund = (oldNorsePrice.add(flipPrize)); currentNorsefire = _newNorse; oldNorseAddr.send(_toRefund); actualNorse.send(diffFivePct); if (excess > 0){ msg.sender.send(excess); } boostCloneMarket(marketBoost); emit NorsefireSwitch(oldNorseAddr, _newNorse, norsefirePrice, _toRefund, flipPrize, diffFivePct); }",
        "vulnerability": "Unsafe use of send for Ether transfer",
        "reason": "The function uses the .send() method for transferring Ether to the old Norsefire address, actualNorse, and refunding excess Ether. This can lead to reentrancy vulnerabilities because .send() only forwards 2300 gas and does not throw an error if the transfer fails. If the recipient is a contract with a fallback function consuming more than 2300 gas, it will prevent the transfer and could lead to stuck funds.",
        "file_name": "0x3ab4a46beae2a0b025eeed54db05819814ff287a.sol"
    },
    {
        "function_name": "sellIdeas",
        "code": "function sellIdeas() public { require(initialized); address _caller = msg.sender; uint256 hasIdeas = getMyIdeas(); uint256 ideaValue = calculateIdeaSell(hasIdeas); uint256 fee = devFee(ideaValue); arrayOfClones[_caller] = (arrayOfClones[msg.sender].div(4)).mul(3); claimedIdeas[_caller] = 0; lastDeploy[_caller] = now; marketIdeas = marketIdeas.add(hasIdeas); currentNorsefire.send(fee); _caller.send(ideaValue.sub(fee)); emit IdeasSold(_caller, hasIdeas); }",
        "vulnerability": "Unsafe Ether transfer using send",
        "reason": "Similar to the becomeNorsefire function, this function uses .send() for transferring Ether to the currentNorsefire and to the caller. This is dangerous due to the same reasons mentioned before: it could lead to reentrancy vulnerabilities and stuck Ether if the recipient is a contract and the transfer fails due to insufficient gas provided by .send().",
        "file_name": "0x3ab4a46beae2a0b025eeed54db05819814ff287a.sol"
    },
    {
        "function_name": "buyIdeas",
        "code": "function buyIdeas() public payable{ require(initialized); address _buyer = msg.sender; uint _sent = msg.value; uint256 ideasBought = calculateIdeaBuy(_sent, SafeMath.sub(address(this).balance,_sent)); ideasBought = ideasBought.sub(devFee(ideasBought)); currentNorsefire.send(devFee(_sent)); claimedIdeas[_buyer] = claimedIdeas[_buyer].add(ideasBought); emit IdeasBought(_buyer, ideasBought); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function sends a fee to currentNorsefire using .send(), which may allow the currentNorsefire to execute a reentrant call back into the contract before the state update occurs, potentially manipulating the contract state. This is a classic reentrancy vulnerability and could be exploited if the currentNorsefire address is a contract with a fallback function.",
        "file_name": "0x3ab4a46beae2a0b025eeed54db05819814ff287a.sol"
    }
]