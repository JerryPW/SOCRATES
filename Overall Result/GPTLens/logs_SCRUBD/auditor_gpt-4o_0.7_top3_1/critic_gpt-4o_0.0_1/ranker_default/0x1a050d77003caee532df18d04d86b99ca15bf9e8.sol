[
    {
        "function_name": "withdraw",
        "vulnerability": "Reentrancy vulnerability",
        "criticism": "The reasoning correctly identifies a potential reentrancy vulnerability due to the sequence of function calls and the subsequent transfer of ether. The severity is high because reentrancy can lead to significant financial loss if exploited. The profitability is also high because an attacker could potentially drain the contract by repeatedly calling withdraw.",
        "correctness": 9,
        "severity": 8,
        "profitability": 8,
        "reason": "The function calls endRound and withdrawEarnings before transferring ether. If an attacker can re-enter the contract after the ether transfer, they could potentially call withdraw multiple times, draining the contract.",
        "code": "function withdraw() isActivated() isHuman() public { uint256 _rID = rID_; uint256 _now = now; uint256 _pID = pIDxAddr_[msg.sender]; uint256 _eth; if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0) { POOHMODatasets.EventReturns memory _eventData_; round_[_rID].ended = true; _eventData_ = endRound(_eventData_); _eth = withdrawEarnings(_pID); if (_eth > 0) plyr_[_pID].addr.transfer(_eth); _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000); _eventData_.compressedIDs = _eventData_.compressedIDs + _pID; emit POOHMOevents.onWithdrawAndDistribute ( msg.sender, plyr_[_pID].name, _eth, _eventData_.compressedData, _eventData_.compressedIDs, _eventData_.winnerAddr, _eventData_.winnerName, _eventData_.amountWon, _eventData_.newPot, _eventData_.POOHAmount, _eventData_.genAmount ); } else { _eth = withdrawEarnings(_pID); if (_eth > 0) plyr_[_pID].addr.transfer(_eth); emit POOHMOevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now); } }",
        "file_name": "0x1a050d77003caee532df18d04d86b99ca15bf9e8.sol",
        "final_score": 8.5
    },
    {
        "function_name": "distributeExternal",
        "vulnerability": "Unsafe external call",
        "criticism": "The reasoning is correct in identifying the use of a low-level call to transfer ETH to the admin address. This can indeed lead to a loss of funds if the call fails, as the transaction will not revert. The severity is moderate because it can lead to a loss of funds, but it is not easily exploitable by an external attacker. The profitability is low because an attacker cannot directly profit from this vulnerability unless they control the admin address.",
        "correctness": 8,
        "severity": 5,
        "profitability": 2,
        "reason": "The function uses a low-level call to transfer ETH to the admin address. If the admin contract fails to receive the funds, the transaction will not revert, potentially leading to loss of funds.",
        "code": "function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, POOHMODatasets.EventReturns memory _eventData_) private returns(POOHMODatasets.EventReturns) { uint256 _dev = _eth / 100; uint256 _POOH = 0; if (!address(admin).call.value(_dev)()) { _POOH = _dev; _dev = 0; } uint256 _aff = _eth / 10; if (_affID != _pID && plyr_[_affID].name != '') { plyr_[_affID].aff = _aff.add(plyr_[_affID].aff); emit POOHMOevents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now); } else { _POOH = _POOH.add(_aff); } _POOH = _POOH.add((_eth.mul(fees_[_team].pooh)) / (100)); if (_POOH > 0) { flushDivs.call.value(_POOH)(bytes4(keccak256(\"donate()\"))); _eventData_.POOHAmount = _POOH.add(_eventData_.POOHAmount); } return(_eventData_); }",
        "file_name": "0x1a050d77003caee532df18d04d86b99ca15bf9e8.sol",
        "final_score": 5.75
    },
    {
        "function_name": "endRound",
        "vulnerability": "Unsafe transfer to admin",
        "criticism": "The reasoning correctly identifies the use of the transfer function, which can fail if the admin contract requires more than 2300 gas. However, the severity is lower than stated because the transfer function will revert the transaction if it fails, preventing a loss of funds. The profitability is low because an attacker cannot exploit this directly for profit.",
        "correctness": 8,
        "severity": 3,
        "profitability": 1,
        "reason": "The function directly transfers a portion of the pot to the admin using transfer. If the admin contract is a smart contract with a fallback function that requires more than the provided gas (2300 gas), this could fail, leading to loss of funds.",
        "code": "function endRound(POOHMODatasets.EventReturns memory _eventData_) private returns (POOHMODatasets.EventReturns) { uint256 _rID = rID_; uint256 _winPID = round_[_rID].plyr; uint256 _winTID = round_[_rID].team; uint256 _pot = round_[_rID].pot; uint256 _win = (_pot.mul(48)) / 100; uint256 _dev = (_pot / 50); uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100; uint256 _POOH = (_pot.mul(potSplit_[_winTID].pooh)) / 100; uint256 _res = (((_pot.sub(_win)).sub(_dev)).sub(_gen)).sub(_POOH); uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys); uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000); if (_dust > 0) { _gen = _gen.sub(_dust); _res = _res.add(_dust); } plyr_[_winPID].win = _win.add(plyr_[_winPID].win); admin.transfer(_dev); flushDivs.call.value(_POOH)(bytes4(keccak256(\"donate()\"))); round_[_rID].mask = _ppt.add(round_[_rID].mask); _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000); _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000); _eventData_.winnerAddr = plyr_[_winPID].addr; _eventData_.winnerName = plyr_[_winPID].name; _eventData_.amountWon = _win; _eventData_.genAmount = _gen; _eventData_.POOHAmount = _POOH; _eventData_.newPot = _res; rID_++; _rID++; round_[_rID].strt = now; rndMax_ = timerLengths[determineNextRoundLength()]; round_[_rID].end = now.add(rndMax_); round_[_rID].pot = _res; return(_eventData_); }",
        "file_name": "0x1a050d77003caee532df18d04d86b99ca15bf9e8.sol",
        "final_score": 5.0
    }
]