[
    {
        "function_name": "withdraw",
        "code": "function withdraw() isActivated() isHuman() public { uint256 _now = now; uint256 _pID = pIDxAddr_[msg.sender]; uint256 _eth; if (_now > round_.end && round_.ended == false && round_.plyr != 0) { LDdatasets.EventReturns memory _eventData_; round_.ended = true; _eventData_ = endRound(_eventData_); _eth = withdrawEarnings(_pID); if (_eth > 0) plyr_[_pID].addr.transfer(_eth); _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000); _eventData_.compressedIDs = _eventData_.compressedIDs + _pID; emit MonkeyEvents.onWithdrawAndDistribute ( msg.sender, plyr_[_pID].name, _eth, _eventData_.compressedData, _eventData_.compressedIDs, _eventData_.winnerAddr, _eventData_.winnerName, _eventData_.amountWon, _eventData_.newPot, _eventData_.genAmount ); } else { _eth = withdrawEarnings(_pID); if (_eth > 0) plyr_[_pID].addr.transfer(_eth); emit MonkeyEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The withdraw function transfers Ether to a player's address before updating the player's state. If the player is a contract, it can re-enter the withdraw function and withdraw more funds than intended, leading to potential loss of funds.",
        "file_name": "0x06ef66ab59919e1c3b25ad4732a002f644fe0f8e.sol"
    },
    {
        "function_name": "distributeExternal",
        "code": "function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, LDdatasets.EventReturns memory _eventData_) private returns(LDdatasets.EventReturns) { uint256 _com = _eth * 5 / 100; uint256 _aff = _eth / 10; if (_affID != _pID && plyr_[_affID].name != '') { plyr_[_affID].aff = _aff.add(plyr_[_affID].aff); emit MonkeyEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now); } else { _com += _aff; } if (!address(MonkeyKingCorp).call.value(_com)(bytes4(keccak256(\"deposit()\")))) { } return(_eventData_); }",
        "vulnerability": "Unchecked external call",
        "reason": "The function makes an external call to the MonkeyKingCorp contract using low-level call. The call's success is not properly checked, allowing potential failure scenarios to go unnoticed, which could lead to unexpected behavior or fund loss.",
        "file_name": "0x06ef66ab59919e1c3b25ad4732a002f644fe0f8e.sol"
    },
    {
        "function_name": "airdrop",
        "code": "function airdrop() private view returns(bool) { uint256 seed = uint256(keccak256(abi.encodePacked( (block.timestamp).add (block.difficulty).add ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add (block.gaslimit).add ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add (block.number) ))); if((seed - ((seed / 1000) * 1000)) < airDropTracker_) return(true); else return(false); }",
        "vulnerability": "Predictable randomness",
        "reason": "The airdrop function uses block properties to generate randomness, which are predictable and can be manipulated by miners. This makes the outcome of the airdrop susceptible to manipulation, allowing attackers to exploit the system for personal gain.",
        "file_name": "0x06ef66ab59919e1c3b25ad4732a002f644fe0f8e.sol"
    }
]