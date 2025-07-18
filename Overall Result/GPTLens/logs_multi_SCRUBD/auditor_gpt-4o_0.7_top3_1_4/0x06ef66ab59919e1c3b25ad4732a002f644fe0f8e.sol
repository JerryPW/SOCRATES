[
    {
        "function_name": "withdraw",
        "code": "function withdraw() isActivated() isHuman() public {\n    uint256 _now = now;\n    uint256 _pID = pIDxAddr_[msg.sender];\n    uint256 _eth;\n    if (_now > round_.end && round_.ended == false && round_.plyr != 0) {\n        LDdatasets.EventReturns memory _eventData_;\n        round_.ended = true;\n        _eventData_ = endRound(_eventData_);\n        _eth = withdrawEarnings(_pID);\n        if (_eth > 0)\n            plyr_[_pID].addr.transfer(_eth);\n        _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);\n        _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;\n        emit MonkeyEvents.onWithdrawAndDistribute (\n            msg.sender,\n            plyr_[_pID].name,\n            _eth,\n            _eventData_.compressedData,\n            _eventData_.compressedIDs,\n            _eventData_.winnerAddr,\n            _eventData_.winnerName,\n            _eventData_.amountWon,\n            _eventData_.newPot,\n            _eventData_.genAmount\n        );\n    } else {\n        _eth = withdrawEarnings(_pID);\n        if (_eth > 0)\n            plyr_[_pID].addr.transfer(_eth);\n        emit MonkeyEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);\n    }\n}",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The contract uses a transfer call to send Ether to the player's address without using a reentrancy guard. An attacker could exploit this by reentering the contract through a fallback function, potentially draining funds or causing inconsistent state.",
        "file_name": "0x06ef66ab59919e1c3b25ad4732a002f644fe0f8e.sol"
    },
    {
        "function_name": "distributeExternal",
        "code": "function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, LDdatasets.EventReturns memory _eventData_) private returns(LDdatasets.EventReturns) {\n    uint256 _com = _eth * 5 / 100;\n    uint256 _aff = _eth / 10;\n    if (_affID != _pID && plyr_[_affID].name != '') {\n        plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);\n        emit MonkeyEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now);\n    } else {\n        _com += _aff;\n    }\n    if (!address(MonkeyKingCorp).call.value(_com)(bytes4(keccak256(\"deposit()\")))) {\n    }\n    return(_eventData_);\n}",
        "vulnerability": "Unsafe external call",
        "reason": "The function makes an external call to MonkeyKingCorp via .call without checking the result or using a reentrancy guard. This could lead to unexpected behavior if the call fails or if the target contract has malicious intent.",
        "file_name": "0x06ef66ab59919e1c3b25ad4732a002f644fe0f8e.sol"
    },
    {
        "function_name": "airdrop",
        "code": "function airdrop() private view returns(bool) {\n    uint256 seed = uint256(keccak256(abi.encodePacked(\n        (block.timestamp).add\n        (block.difficulty).add\n        ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add\n        (block.gaslimit).add\n        ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add\n        (block.number)\n    )));\n    if((seed - ((seed / 1000) * 1000)) < airDropTracker_)\n        return(true);\n    else\n        return(false);\n}",
        "vulnerability": "Predictable randomness",
        "reason": "The randomness logic in the airdrop function uses publicly available block variables which can be predicted and manipulated by miners, leading to potential exploitation by adversaries who can control the outcome of the random number generation.",
        "file_name": "0x06ef66ab59919e1c3b25ad4732a002f644fe0f8e.sol"
    }
]