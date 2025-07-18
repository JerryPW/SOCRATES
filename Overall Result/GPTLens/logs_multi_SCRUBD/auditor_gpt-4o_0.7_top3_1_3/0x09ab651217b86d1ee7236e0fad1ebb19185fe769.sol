[
    {
        "function_name": "endRound",
        "code": "function endRound(LDdatasets.EventReturns memory _eventData_) private returns (LDdatasets.EventReturns) { uint256 _winPID = round_.plyr; uint256 _pot = round_.pot + airDropPot_; uint256 _win = (_pot.mul(40)) / 100; uint256 _com = (_pot.mul(30)) / 100; uint256 _queen = (_pot.mul(10)) / 100; uint256 _gen = (_pot.mul(20)) / 100; uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys); uint256 _dust = _gen.sub((_ppt.mul(round_.keys)) / 1000000000000000000); if (_dust > 0) { _gen = _gen.sub(_dust); _com = _com.add(_dust); } plyr_[_winPID].win = _win.add(plyr_[_winPID].win); if (!address(monkeyKing).call.value(_com)()) { _gen = _gen.add(_com); _com = 0; } if (!address(monkeyQueue).call.value(_queen)()) { _gen = _gen.add(_queen); _queen = 0; } round_.mask = _ppt.add(round_.mask); _eventData_.compressedData = _eventData_.compressedData + (round_.end * 1000000); _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000); _eventData_.winnerAddr = plyr_[_winPID].addr; _eventData_.winnerName = plyr_[_winPID].name; _eventData_.amountWon = _win; _eventData_.genAmount = _gen; _eventData_.newPot = 0; return(_eventData_); }",
        "vulnerability": "Unprotected External Call",
        "reason": "The function makes calls to external addresses using 'call.value', which is unsafe as it could lead to reentrancy attacks and unhandled failures. If the call fails, the contract does not revert and instead adjusts the gen amount, leading to potential loss of funds.",
        "file_name": "0x09ab651217b86d1ee7236e0fad1ebb19185fe769.sol"
    },
    {
        "function_name": "distributeExternal",
        "code": "function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, LDdatasets.EventReturns memory _eventData_) private returns(LDdatasets.EventReturns) { uint256 _com = _eth * 15 / 100; uint256 _aff = _eth*25 / 100; uint256 _toqueen = 0; if (_affID != _pID && plyr_[_affID].name != '') { plyr_[_affID].aff = _aff.add(plyr_[_affID].aff); emit MonkeyEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now); } else { _com += (_aff*80/100); _toqueen += (_aff*20/100); } if (_toqueen > 0) { if(!address(monkeyQueue).call.value(_toqueen)()) { } } if (!address(monkeyKing).call.value(_com)()) { } return(_eventData_); }",
        "vulnerability": "Unprotected External Call",
        "reason": "The function makes external calls using 'call.value' without checking for reentrancy or handling failures, which could lead to loss of funds or unintended behavior if the call fails or is exploited by reentrancy.",
        "file_name": "0x09ab651217b86d1ee7236e0fad1ebb19185fe769.sol"
    },
    {
        "function_name": "airdrop",
        "code": "function airdrop() private view returns(bool) { uint256 seed = uint256(keccak256(abi.encodePacked( (block.timestamp).add (block.difficulty).add ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add (block.gaslimit).add ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add (block.number) ))); if((seed - ((seed / 1000) * 1000)) < airDropTracker_) return(true); else return(false); }",
        "vulnerability": "Predictable Randomness",
        "reason": "The airdrop function uses block variables for randomness, which can be predicted or manipulated by miners. This makes the random outcome predictable and could be exploited for unfair advantage in the airdrop distribution.",
        "file_name": "0x09ab651217b86d1ee7236e0fad1ebb19185fe769.sol"
    }
]