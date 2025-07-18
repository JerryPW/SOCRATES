[
    {
        "function_name": "distributeExternal",
        "vulnerability": "Unchecked External Call",
        "criticism": "The reasoning is correct in identifying that the external call to 'MonkeyKingCorp' using 'call' is unchecked. This could lead to failed transactions without reverting, potentially causing a loss of Ether. The severity is moderate because it could lead to unexpected behavior if the call fails. The profitability is low because an attacker cannot directly profit from this vulnerability, but it could lead to loss of funds.",
        "correctness": 8,
        "severity": 5,
        "profitability": 2,
        "reason": "The contract calls an external contract 'MonkeyKingCorp' using 'call' without checking the return value. This could lead to failed transactions without reverting, potentially causing a loss of Ether if the call fails.",
        "code": "function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, LDdatasets.EventReturns memory _eventData_) private returns(LDdatasets.EventReturns) {\n    uint256 _com = _eth * 5 / 100;\n    uint256 _aff = _eth / 10;\n    if (_affID != _pID && plyr_[_affID].name != '') {\n        plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);\n        emit MonkeyEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now);\n    } else {\n        _com += _aff;\n    }\n    if (!address(MonkeyKingCorp).call.value(_com)(bytes4(keccak256(\"deposit()\")))) {\n    }\n    return(_eventData_);\n}",
        "file_name": "0x06ef66ab59919e1c3b25ad4732a002f644fe0f8e.sol",
        "final_score": 5.75
    },
    {
        "function_name": "endRound",
        "vulnerability": "Unchecked External Call",
        "criticism": "The reasoning is correct in identifying the unchecked external call to 'MonkeyKingCorp'. This could lead to unexpected behavior if the called contract is malicious or has bugs. The severity is moderate because it could lead to unexpected behavior or loss of funds. The profitability is low because an attacker cannot directly profit from this vulnerability, but it could lead to loss of funds.",
        "correctness": 8,
        "severity": 5,
        "profitability": 2,
        "reason": "The function makes an unchecked external call to 'MonkeyKingCorp'. This unchecked call could lead to unexpected behavior if the called contract is malicious or has bugs.",
        "code": "function endRound(LDdatasets.EventReturns memory _eventData_) private returns (LDdatasets.EventReturns) {\n    uint256 _winPID = round_.plyr;\n    uint256 _pot = round_.pot + airDropPot_;\n    uint256 _win = (_pot.mul(45)) / 100;\n    uint256 _com = (_pot / 10);\n    uint256 _gen = (_pot.mul(potSplit_)) / 100;\n    uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys);\n    uint256 _dust = _gen.sub((_ppt.mul(round_.keys)) / 1000000000000000000);\n    if (_dust > 0) {\n        _gen = _gen.sub(_dust);\n        _com = _com.add(_dust);\n    }\n    plyr_[_winPID].win = _win.add(plyr_[_winPID].win);\n    if (!address(MonkeyKingCorp).call.value(_com)(bytes4(keccak256(\"deposit()\")))) {\n        _gen = _gen.add(_com);\n        _com = 0;\n    }\n    round_.mask = _ppt.add(round_.mask);\n    _eventData_.compressedData = _eventData_.compressedData + (round_.end * 1000000);\n    _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000);\n    _eventData_.winnerAddr = plyr_[_winPID].addr;\n    _eventData_.winnerName = plyr_[_winPID].name;\n    _eventData_.amountWon = _win;\n    _eventData_.genAmount = _gen;\n    _eventData_.newPot = 0;\n    return(_eventData_);\n}",
        "file_name": "0x06ef66ab59919e1c3b25ad4732a002f644fe0f8e.sol",
        "final_score": 5.75
    },
    {
        "function_name": "withdraw",
        "vulnerability": "Reentrancy",
        "criticism": "The reasoning is correct in identifying a potential reentrancy vulnerability due to the use of 'transfer'. However, 'transfer' is generally considered safe against reentrancy because it only forwards 2300 gas, which is not enough to perform a reentrant call. The severity is low because the use of 'transfer' mitigates the risk of reentrancy. The profitability is also low because an attacker would not be able to exploit this vulnerability effectively.",
        "correctness": 6,
        "severity": 2,
        "profitability": 1,
        "reason": "The function uses 'transfer' to send Ether to an address, making it vulnerable to reentrancy attacks. An attacker could exploit this by recursively calling the 'withdraw' function before the balance is updated.",
        "code": "function withdraw() isActivated() isHuman() public {\n    uint256 _now = now;\n    uint256 _pID = pIDxAddr_[msg.sender];\n    uint256 _eth;\n    if (_now > round_.end && round_.ended == false && round_.plyr != 0) {\n        LDdatasets.EventReturns memory _eventData_;\n        round_.ended = true;\n        _eventData_ = endRound(_eventData_);\n        _eth = withdrawEarnings(_pID);\n        if (_eth > 0)\n            plyr_[_pID].addr.transfer(_eth);\n        _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);\n        _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;\n        emit MonkeyEvents.onWithdrawAndDistribute (\n            msg.sender,\n            plyr_[_pID].name,\n            _eth,\n            _eventData_.compressedData,\n            _eventData_.compressedIDs,\n            _eventData_.winnerAddr,\n            _eventData_.winnerName,\n            _eventData_.amountWon,\n            _eventData_.newPot,\n            _eventData_.genAmount\n        );\n    } else {\n        _eth = withdrawEarnings(_pID);\n        if (_eth > 0)\n            plyr_[_pID].addr.transfer(_eth);\n        emit MonkeyEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);\n    }\n}",
        "file_name": "0x06ef66ab59919e1c3b25ad4732a002f644fe0f8e.sol",
        "final_score": 3.75
    }
]