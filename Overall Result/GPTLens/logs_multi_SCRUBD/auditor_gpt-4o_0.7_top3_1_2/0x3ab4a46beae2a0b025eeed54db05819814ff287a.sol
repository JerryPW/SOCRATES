[
    {
        "function_name": "becomeNorsefire",
        "code": "function becomeNorsefire() public payable { require(initialized); address oldNorseAddr = currentNorsefire; uint oldNorsePrice = norsefirePrice.mul(100).div(110); require(msg.value >= norsefirePrice); uint excess = msg.value.sub(norsefirePrice); uint diffFivePct = (norsefirePrice.sub(oldNorsePrice)).div(20); norsefirePrice = norsefirePrice.add(norsefirePrice.div(10)); uint flipPrize = diffFivePct.mul(10); uint marketBoost = diffFivePct.mul(9); address _newNorse = msg.sender; uint _toRefund = (oldNorsePrice.add(flipPrize)); currentNorsefire = _newNorse; oldNorseAddr.send(_toRefund); actualNorse.send(diffFivePct); if (excess > 0){ msg.sender.send(excess); } boostCloneMarket(marketBoost); emit NorsefireSwitch(oldNorseAddr, _newNorse, norsefirePrice, _toRefund, flipPrize, diffFivePct); }",
        "vulnerability": "Unsafe use of send()",
        "reason": "The function uses send() to transfer Ether, which only forwards 2300 gas, potentially causing the transaction to fail if the recipient's fallback function requires more gas. This can result in Ether being locked in the contract or unexpected behavior.",
        "file_name": "0x3ab4a46beae2a0b025eeed54db05819814ff287a.sol"
    },
    {
        "function_name": "sellIdeas",
        "code": "function sellIdeas() public { require(initialized); address _caller = msg.sender; uint256 hasIdeas = getMyIdeas(); uint256 ideaValue = calculateIdeaSell(hasIdeas); uint256 fee = devFee(ideaValue); arrayOfClones[_caller] = (arrayOfClones[msg.sender].div(4)).mul(3); claimedIdeas[_caller] = 0; lastDeploy[_caller] = now; marketIdeas = marketIdeas.add(hasIdeas); currentNorsefire.send(fee); _caller.send(ideaValue.sub(fee)); emit IdeasSold(_caller, hasIdeas); }",
        "vulnerability": "Potential reentrancy attack",
        "reason": "The function updates the state after sending Ether to the caller. This allows a reentrancy attack where the attacker can recursively call sellIdeas to drain the contract before the state is updated.",
        "file_name": "0x3ab4a46beae2a0b025eeed54db05819814ff287a.sol"
    },
    {
        "function_name": "buyIdeas",
        "code": "function buyIdeas() public payable{ require(initialized); address _buyer = msg.sender; uint _sent = msg.value; uint256 ideasBought = calculateIdeaBuy(_sent, SafeMath.sub(address(this).balance,_sent)); ideasBought = ideasBought.sub(devFee(ideasBought)); currentNorsefire.send(devFee(_sent)); claimedIdeas[_buyer] = claimedIdeas[_buyer].add(ideasBought); emit IdeasBought(_buyer, ideasBought); }",
        "vulnerability": "Integer underflow in calculateIdeaBuy",
        "reason": "The function uses SafeMath.sub with address(this).balance and _sent. If _sent is greater than the contract's balance, it may cause an underflow, leading to incorrect calculations and potential exploitation by malicious actors.",
        "file_name": "0x3ab4a46beae2a0b025eeed54db05819814ff287a.sol"
    }
]