[
    {
        "function_name": "distributeExternal",
        "code": "function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, LDdatasets.EventReturns memory _eventData_) private returns(LDdatasets.EventReturns) {\n    uint256 _com = _eth * 15 / 100;\n    uint256 _aff = _eth*25 / 100;\n    uint256 _toqueen = 0;\n    if (_affID != _pID && plyr_[_affID].name != '') {\n        plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);\n        emit MonkeyEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now);\n    } else {\n        _com += (_aff*80/100);\n        _toqueen += (_aff*20/100);\n    }\n    if (_toqueen > 0) {\n        if(!address(monkeyQueue).call.value(_toqueen)()) {\n        }\n    }\n    if (!address(monkeyKing).call.value(_com)()) {\n    }\n    return(_eventData_);\n}",
        "vulnerability": "Unchecked call return value",
        "reason": "The function transfers ether to external addresses using .call.value(), but it doesn't check if the transfer was successful. This can lead to locked ether if the transfer fails.",
        "file_name": "0x09ab651217b86d1ee7236e0fad1ebb19185fe769.sol"
    },
    {
        "function_name": "endRound",
        "code": "function endRound(LDdatasets.EventReturns memory _eventData_) private returns (LDdatasets.EventReturns) {\n    uint256 _winPID = round_.plyr;\n    uint256 _pot = round_.pot + airDropPot_;\n    uint256 _win = (_pot.mul(40)) / 100;\n    uint256 _com = (_pot.mul(30)) / 100;\n    uint256 _queen = (_pot.mul(10)) / 100;\n    uint256 _gen = (_pot.mul(20)) / 100;\n    uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys);\n    uint256 _dust = _gen.sub((_ppt.mul(round_.keys)) / 1000000000000000000);\n    if (_dust > 0) {\n        _gen = _gen.sub(_dust);\n        _com = _com.add(_dust);\n    }\n    plyr_[_winPID].win = _win.add(plyr_[_winPID].win);\n    if (!address(monkeyKing).call.value(_com)()) {\n        _gen = _gen.add(_com);\n        _com = 0;\n    }\n    if (!address(monkeyQueue).call.value(_queen)()) {\n        _gen = _gen.add(_queen);\n        _queen = 0;\n    }\n    round_.mask = _ppt.add(round_.mask);\n    _eventData_.compressedData = _eventData_.compressedData + (round_.end * 1000000);\n    _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000);\n    _eventData_.winnerAddr = plyr_[_winPID].addr;\n    _eventData_.winnerName = plyr_[_winPID].name;\n    _eventData_.amountWon = _win;\n    _eventData_.genAmount = _gen;\n    _eventData_.newPot = 0;\n    return(_eventData_);\n}",
        "vulnerability": "Unchecked call return value",
        "reason": "The function uses .call.value() to transfer ether without checking if the call was successful. This can lead to ether being stuck if the transfer fails.",
        "file_name": "0x09ab651217b86d1ee7236e0fad1ebb19185fe769.sol"
    },
    {
        "function_name": "airdrop",
        "code": "function airdrop() private view returns(bool) {\n    uint256 seed = uint256(keccak256(abi.encodePacked(\n        (block.timestamp).add\n        (block.difficulty).add\n        ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add\n        (block.gaslimit).add\n        ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add\n        (block.number)\n    )));\n    if((seed - ((seed / 1000) * 1000)) < airDropTracker_)\n        return(true);\n    else\n        return(false);\n}",
        "vulnerability": "Insecure randomness",
        "reason": "The randomness used in the airdrop function is predictable as it relies on block attributes like timestamp and difficulty, making it vulnerable to manipulation by miners or attackers.",
        "file_name": "0x09ab651217b86d1ee7236e0fad1ebb19185fe769.sol"
    }
]