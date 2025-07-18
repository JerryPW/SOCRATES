[
    {
        "function_name": "distributeExternal",
        "vulnerability": "Reentrancy",
        "criticism": "The reasoning correctly identifies the use of low-level calls, which can indeed be a vector for reentrancy attacks. However, the function does not seem to have any state changes after the call, which reduces the risk of reentrancy. The severity is moderate because the funds are being transferred, but the profitability is low as the function is private and an external attacker cannot directly exploit it.",
        "correctness": 6,
        "severity": 4,
        "profitability": 2,
        "reason": "The function uses low-level call to transfer funds to external addresses without checking the return value effectively. This can lead to reentrancy attacks if an attacker crafts a malicious contract to exploit this call.",
        "code": "function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, BATMODatasets.EventReturns memory _eventData_) private returns(BATMODatasets.EventReturns) { uint256 _p1 = _eth / 100; uint256 _dev = _eth / 50; _dev = _dev.add(_p1); uint256 _OBOK; if (!address(admin).call.value(_dev/2)() && !address(admin2).call.value(_dev/2)()) { _OBOK = _dev; _dev = 0; } uint256 _aff = _eth / 10; if (_affID != _pID && plyr_[_affID].name != '') { plyr_[_affID].aff = _aff.add(plyr_[_affID].aff); emit FOMOEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now); } else { _OBOK = _aff; } _OBOK = _OBOK.add((_eth.mul(fees_[_team].obok)) / (100)); if (_OBOK > 0) { uint256 _potAmount = _OBOK / 2; address(ObokContract).call.value(_OBOK.sub(_potAmount))(bytes4(keccak256(\"donateDivs()\"))); round_[_rID].pot = round_[_rID].pot.add(_potAmount); _eventData_.tokenAmount = _OBOK.add(_eventData_.tokenAmount); } return(_eventData_); }",
        "file_name": "0x37238583c041a2f51964f23fde2710c4fbd29e9e.sol",
        "final_score": 4.5
    },
    {
        "function_name": "endRound",
        "vulnerability": "Reentrancy",
        "criticism": "The reasoning is correct in identifying the use of low-level calls, which can be exploited for reentrancy. However, the function does not perform any state changes after the call, which mitigates the risk. The severity is moderate due to the potential for fund manipulation, but the profitability is low as the function is private and not directly exploitable by an external attacker.",
        "correctness": 6,
        "severity": 4,
        "profitability": 2,
        "reason": "The function uses low-level call to transfer funds to external addresses without checking the return value effectively. This can lead to reentrancy attacks if an attacker crafts a malicious contract to exploit this call.",
        "code": "function endRound(BATMODatasets.EventReturns memory _eventData_) private returns (BATMODatasets.EventReturns) { uint256 _rID = rID_; uint256 _winPID = round_[_rID].plyr; uint256 _winTID = round_[_rID].team; uint256 _pot = round_[_rID].pot; uint256 _win = (_pot.mul(48)) / 100; uint256 _dev = (_pot / 50); uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100; uint256 _OBOK = (_pot.mul(potSplit_[_winTID].obok)) / 100; uint256 _res = (((_pot.sub(_win)).sub(_dev)).sub(_gen)).sub(_OBOK); uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys); uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000); if (_dust > 0) { _gen = _gen.sub(_dust); _res = _res.add(_dust); } plyr_[_winPID].win = _win.add(plyr_[_winPID].win); admin.transfer(_dev / 2); admin2.transfer(_dev / 2); address(ObokContract).call.value(_OBOK.sub((_OBOK / 3).mul(2)))(bytes4(keccak256(\"donateDivs()\"))); round_[_rID].pot = _pot.add(_OBOK / 3); round_[_rID].mask = _ppt.add(round_[_rID].mask); _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000); _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000); _eventData_.winnerAddr = plyr_[_winPID].addr; _eventData_.winnerName = plyr_[_winPID].name; _eventData_.amountWon = _win; _eventData_.genAmount = _gen; _eventData_.tokenAmount = _OBOK; _eventData_.newPot = _res; rID_++; _rID++; round_[_rID].strt = now; round_[_rID].end = now.add(rndInit_).add(rndGap_); round_[_rID].pot += _res; return(_eventData_); }",
        "file_name": "0x37238583c041a2f51964f23fde2710c4fbd29e9e.sol",
        "final_score": 4.5
    },
    {
        "function_name": "withdraw",
        "vulnerability": "Reentrancy",
        "criticism": "The reasoning is incorrect in identifying reentrancy as a vulnerability here. The function uses transfer, which sends a fixed amount of gas, making it safe from reentrancy attacks. However, the concern about denial of service due to costly fallback functions is valid. The severity is low because the use of transfer mitigates reentrancy, but the profitability is also low as it does not allow for direct exploitation.",
        "correctness": 4,
        "severity": 2,
        "profitability": 1,
        "reason": "The function uses transfer to send funds to an external address. If the fallback function of the receiving address is costly, it can block the execution, causing a denial of service. Furthermore, this is susceptible to reentrancy if the state changes are not handled carefully.",
        "code": "function withdraw() isActivated() isHuman() public { uint256 _rID = rID_; uint256 _now = now; uint256 _pID = pIDxAddr_[msg.sender]; uint256 _eth; if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0) { BATMODatasets.EventReturns memory _eventData_; round_[_rID].ended = true; _eventData_ = endRound(_eventData_); _eth = withdrawEarnings(_pID); if (_eth > 0) plyr_[_pID].addr.transfer(_eth); _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000); _eventData_.compressedIDs = _eventData_.compressedIDs + _pID; emit FOMOEvents.onWithdrawAndDistribute ( msg.sender, plyr_[_pID].name, _eth, _eventData_.compressedData, _eventData_.compressedIDs, _eventData_.winnerAddr, _eventData_.winnerName, _eventData_.amountWon, _eventData_.newPot, _eventData_.tokenAmount, _eventData_.genAmount ); } else { _eth = withdrawEarnings(_pID); if (_eth > 0) plyr_[_pID].addr.transfer(_eth); emit FOMOEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now); } }",
        "file_name": "0x37238583c041a2f51964f23fde2710c4fbd29e9e.sol",
        "final_score": 2.75
    }
]