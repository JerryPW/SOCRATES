[
    {
        "function_name": "distributeExternal",
        "vulnerability": "Improper Ether Transfer",
        "criticism": "The reasoning is correct. The function uses `call.value()` for Ether transfers, which is unsafe and can lead to reentrancy attacks. Additionally, there are no checks for successful transfers, which could result in lost funds if the recipient contract does not handle Ether correctly or if the transfer fails. The severity is high because it can lead to loss of funds, and the profitability is moderate because an attacker could potentially exploit this to drain funds.",
        "correctness": 9,
        "severity": 7,
        "profitability": 5,
        "reason": "The `distributeExternal` function uses `call.value()` to transfer Ether, which is unsafe and can lead to reentrancy attacks. Additionally, there are no checks for successful transfers, meaning funds could be lost if the recipient contract does not handle Ether correctly or if the transfer fails for another reason.",
        "code": "function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, LDdatasets.EventReturns memory _eventData_) private returns(LDdatasets.EventReturns) {\n    uint256 _com = _eth * 15 / 100;\n    uint256 _aff = _eth*25 / 100;\n    uint256 _toqueen = 0;\n    if (_affID != _pID && plyr_[_affID].name != '') {\n        plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);\n        emit MonkeyEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now);\n    } else {\n        _com += (_aff*80/100);\n        _toqueen += (_aff*20/100);\n    }\n    if (_toqueen > 0) {\n        if(!address(monkeyQueue).call.value(_toqueen)()) {\n        }\n    }\n    if (!address(monkeyKing).call.value(_com)()) {\n    }\n    return(_eventData_);\n}",
        "file_name": "0x09ab651217b86d1ee7236e0fad1ebb19185fe769.sol",
        "final_score": 7.5
    },
    {
        "function_name": "airdrop",
        "vulnerability": "Predictable Randomness",
        "criticism": "The reasoning is correct. The airdrop function relies on block attributes such as timestamp, difficulty, and block number, which are not truly random and can be influenced by miners. This makes the randomness predictable and exploitable, allowing attackers to potentially manipulate the function's outcome. The severity is moderate because it affects the fairness of the airdrop, and the profitability is moderate as well, since an attacker could potentially gain more airdrop rewards.",
        "correctness": 8,
        "severity": 5,
        "profitability": 5,
        "reason": "The randomness for the airdrop function relies on block attributes such as timestamp, difficulty, and block number, which can be influenced by miners. This makes the airdrop mechanism predictable and exploitable, potentially allowing attackers to manipulate the function's outcome.",
        "code": "function airdrop() private view returns(bool) {\n    uint256 seed = uint256(keccak256(abi.encodePacked(\n        (block.timestamp).add\n        (block.difficulty).add\n        ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add\n        (block.gaslimit).add\n        ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add\n        (block.number)\n    )));\n    if((seed - ((seed / 1000) * 1000)) < airDropTracker_)\n        return(true);\n    else\n        return(false);\n}",
        "file_name": "0x09ab651217b86d1ee7236e0fad1ebb19185fe769.sol",
        "final_score": 6.5
    },
    {
        "function_name": "endRound",
        "vulnerability": "Use of Deprecated `call.value()`",
        "criticism": "The reasoning is correct. The use of `call.value()` is indeed deprecated and considered unsafe due to its potential to introduce reentrancy vulnerabilities. However, the function does not seem to have any state changes after the call, which reduces the risk of reentrancy. The severity is moderate because it uses an outdated method, and the profitability is low because the specific implementation does not seem to allow for easy exploitation.",
        "correctness": 8,
        "severity": 4,
        "profitability": 2,
        "reason": "The `endRound` function uses `call.value()` for transfers, which is a deprecated and unsafe way to transfer Ether. This makes the contract vulnerable to reentrancy attacks, where an attacker can execute a fallback function and re-enter the contract, potentially draining funds.",
        "code": "function endRound(LDdatasets.EventReturns memory _eventData_) private returns (LDdatasets.EventReturns) {\n    uint256 _winPID = round_.plyr;\n    uint256 _pot = round_.pot + airDropPot_;\n    uint256 _win = (_pot.mul(40)) / 100;\n    uint256 _com = (_pot.mul(30)) / 100;\n    uint256 _queen = (_pot.mul(10)) / 100;\n    uint256 _gen = (_pot.mul(20)) / 100;\n    uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys);\n    uint256 _dust = _gen.sub((_ppt.mul(round_.keys)) / 1000000000000000000);\n    if (_dust > 0) {\n        _gen = _gen.sub(_dust);\n        _com = _com.add(_dust);\n    }\n    plyr_[_winPID].win = _win.add(plyr_[_winPID].win);\n    if (!address(monkeyKing).call.value(_com)()) {\n        _gen = _gen.add(_com);\n        _com = 0;\n    }\n    if (!address(monkeyQueue).call.value(_queen)()) {\n        _gen = _gen.add(_queen);\n        _queen = 0;\n    }\n    round_.mask = _ppt.add(round_.mask);\n    _eventData_.compressedData = _eventData_.compressedData + (round_.end * 1000000);\n    _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000);\n    _eventData_.winnerAddr = plyr_[_winPID].addr;\n    _eventData_.winnerName = plyr_[_winPID].name;\n    _eventData_.amountWon = _win;\n    _eventData_.genAmount = _gen;\n    _eventData_.newPot = 0;\n    return(_eventData_);\n}",
        "file_name": "0x09ab651217b86d1ee7236e0fad1ebb19185fe769.sol",
        "final_score": 5.5
    }
]