[
    {
        "function_name": "distributeExternal",
        "code": "function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, POOHMODatasets.EventReturns memory _eventData_) private returns(POOHMODatasets.EventReturns) { uint256 _dev = _eth / 100; uint256 _POOH = 0; if (!address(admin).call.value(_dev)()) { _POOH = _dev; _dev = 0; } uint256 _aff = _eth / 10; if (_affID != _pID && plyr_[_affID].name != '') { plyr_[_affID].aff = _aff.add(plyr_[_affID].aff); emit POOHMOevents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now); } else { _POOH = _POOH.add(_aff); } _POOH = _POOH.add((_eth.mul(fees_[_team].pooh)) / (100)); if (_POOH > 0) { flushDivs.call.value(_POOH)(bytes4(keccak256(\"donate()\"))); _eventData_.POOHAmount = _POOH.add(_eventData_.POOHAmount); } return(_eventData_); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function uses low-level call to transfer funds to the admin without proper checks for reentrancy. If the admin address is a contract with a fallback function that reenters the contract, it can cause unexpected behavior and potentially drain funds.",
        "file_name": "0x1a050d77003caee532df18d04d86b99ca15bf9e8.sol"
    },
    {
        "function_name": "endRound",
        "code": "function endRound(POOHMODatasets.EventReturns memory _eventData_) private returns (POOHMODatasets.EventReturns) { uint256 _rID = rID_; uint256 _winPID = round_[_rID].plyr; uint256 _winTID = round_[_rID].team; uint256 _pot = round_[_rID].pot; uint256 _win = (_pot.mul(48)) / 100; uint256 _dev = (_pot / 50); uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100; uint256 _POOH = (_pot.mul(potSplit_[_winTID].pooh)) / 100; uint256 _res = (((_pot.sub(_win)).sub(_dev)).sub(_gen)).sub(_POOH); uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys); uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000); if (_dust > 0) { _gen = _gen.sub(_dust); _res = _res.add(_dust); } plyr_[_winPID].win = _win.add(plyr_[_winPID].win); admin.transfer(_dev); flushDivs.call.value(_POOH)(bytes4(keccak256(\"donate()\"))); round_[_rID].mask = _ppt.add(round_[_rID].mask); _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000); _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000); _eventData_.winnerAddr = plyr_[_winPID].addr; _eventData_.winnerName = plyr_[_winPID].name; _eventData_.amountWon = _win; _eventData_.genAmount = _gen; _eventData_.POOHAmount = _POOH; _eventData_.newPot = _res; rID_++; _rID++; round_[_rID].strt = now; rndMax_ = timerLengths[determineNextRoundLength()]; round_[_rID].end = now.add(rndMax_); round_[_rID].pot = _res; return(_eventData_); }",
        "vulnerability": "Unrestricted access vulnerability",
        "reason": "The function does not have any access control to prevent unauthorized calls. If the function is called by anyone other than the intended caller, it can prematurely end the round, manipulating the round logic and affecting the distribution of the pot.",
        "file_name": "0x1a050d77003caee532df18d04d86b99ca15bf9e8.sol"
    },
    {
        "function_name": "withdrawEarnings",
        "code": "function withdrawEarnings(uint256 _pID) private returns(uint256) { updateGenVault(_pID, plyr_[_pID].lrnd); uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff); if (_earnings > 0) { plyr_[_pID].win = 0; plyr_[_pID].gen = 0; plyr_[_pID].aff = 0; } return(_earnings); }",
        "vulnerability": "Lack of withdrawal limit",
        "reason": "The function does not account for potential double withdrawal scenarios or limit the amount that can be withdrawn in a single transaction, which could lead to an attacker repeatedly calling the function to drain funds.",
        "file_name": "0x1a050d77003caee532df18d04d86b99ca15bf9e8.sol"
    }
]