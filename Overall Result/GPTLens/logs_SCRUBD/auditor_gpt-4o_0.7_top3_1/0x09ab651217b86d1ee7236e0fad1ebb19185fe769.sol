[
    {
        "function_name": "endRound",
        "code": "function endRound(LDdatasets.EventReturns memory _eventData_) private returns (LDdatasets.EventReturns) { uint256 _winPID = round_.plyr; uint256 _pot = round_.pot + airDropPot_; uint256 _win = (_pot.mul(40)) / 100; uint256 _com = (_pot.mul(30)) / 100; uint256 _queen = (_pot.mul(10)) / 100; uint256 _gen = (_pot.mul(20)) / 100; uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys); uint256 _dust = _gen.sub((_ppt.mul(round_.keys)) / 1000000000000000000); if (_dust > 0) { _gen = _gen.sub(_dust); _com = _com.add(_dust); } plyr_[_winPID].win = _win.add(plyr_[_winPID].win); if (!address(monkeyKing).call.value(_com)()) { _gen = _gen.add(_com); _com = 0; } if (!address(monkeyQueue).call.value(_queen)()) { _gen = _gen.add(_queen); _queen = 0; } round_.mask = _ppt.add(round_.mask); _eventData_.compressedData = _eventData_.compressedData + (round_.end * 1000000); _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000); _eventData_.winnerAddr = plyr_[_winPID].addr; _eventData_.winnerName = plyr_[_winPID].name; _eventData_.amountWon = _win; _eventData_.genAmount = _gen; _eventData_.newPot = 0; return(_eventData_); }",
        "vulnerability": "Unrestricted Call to External Address",
        "reason": "The function uses low-level call to transfer the '_com' and '_queen' amounts to the 'monkeyKing' and 'monkeyQueue' addresses respectively without checking if the call was successful. This can lead to loss of funds if the call fails or is intercepted by a malicious contract.",
        "file_name": "0x09ab651217b86d1ee7236e0fad1ebb19185fe769.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() isActivated() isHuman() public { uint256 _now = now; uint256 _pID = pIDxAddr_[msg.sender]; uint256 _eth; if (_now > round_.end && round_.ended == false && round_.plyr != 0) { LDdatasets.EventReturns memory _eventData_; round_.ended = true; _eventData_ = endRound(_eventData_); _eth = withdrawEarnings(_pID); if (_eth > 0) plyr_[_pID].addr.transfer(_eth); _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000); _eventData_.compressedIDs = _eventData_.compressedIDs + _pID; emit MonkeyEvents.onWithdrawAndDistribute ( msg.sender, plyr_[_pID].name, _eth, _eventData_.compressedData, _eventData_.compressedIDs, _eventData_.winnerAddr, _eventData_.winnerName, _eventData_.amountWon, _eventData_.newPot, _eventData_.genAmount ); } else { _eth = withdrawEarnings(_pID); if (_eth > 0) plyr_[_pID].addr.transfer(_eth); emit MonkeyEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now); } }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The 'withdraw' function uses 'transfer', which provides some protection against reentrancy, but if any future changes are made using 'call' or 'send', it could become vulnerable. The function first calls 'endRound', which could potentially allow reentrant calls if the state is manipulated.",
        "file_name": "0x09ab651217b86d1ee7236e0fad1ebb19185fe769.sol"
    },
    {
        "function_name": "distributeExternal",
        "code": "function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, LDdatasets.EventReturns memory _eventData_) private returns(LDdatasets.EventReturns) { uint256 _com = _eth * 15 / 100; uint256 _aff = _eth*25 / 100; uint256 _toqueen = 0; if (_affID != _pID && plyr_[_affID].name != '') { plyr_[_affID].aff = _aff.add(plyr_[_affID].aff); emit MonkeyEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now); } else { _com += (_aff*80/100); _toqueen += (_aff*20/100); } if (_toqueen > 0) { if(!address(monkeyQueue).call.value(_toqueen)()) { } } if (!address(monkeyKing).call.value(_com)()) { } return(_eventData_); }",
        "vulnerability": "Unchecked External Call Return Value",
        "reason": "The function makes calls to external addresses using 'call', but it does not properly handle the case where the call fails, potentially causing funds to be trapped or misallocated.",
        "file_name": "0x09ab651217b86d1ee7236e0fad1ebb19185fe769.sol"
    }
]