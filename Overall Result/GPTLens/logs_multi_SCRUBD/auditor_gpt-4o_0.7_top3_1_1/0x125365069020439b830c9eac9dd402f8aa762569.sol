[
    {
        "function_name": "withdraw",
        "code": "function withdraw() isActivated() isHuman() public { uint256 _now = now; uint256 _pID = pIDxAddr_[msg.sender]; uint256 _eth; if (_now > round_.end && round_.ended == false && round_.plyr != 0) { RSdatasets.EventReturns memory _eventData_; round_.ended = true; _eventData_ = endRound(_eventData_); _eth = withdrawEarnings(_pID); if (_eth > 0) plyr_[_pID].addr.transfer(_eth); _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000); _eventData_.compressedIDs = _eventData_.compressedIDs + _pID; emit RSEvents.onWithdrawAndDistribute ( msg.sender, plyr_[_pID].name, _eth, _eventData_.compressedData, _eventData_.compressedIDs, _eventData_.winnerAddr, _eventData_.winnerName, _eventData_.amountWon, _eventData_.newPot, _eventData_.genAmount ); } else { _eth = withdrawEarnings(_pID); if (_eth > 0) plyr_[_pID].addr.transfer(_eth); emit RSEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now); } }",
        "vulnerability": "Reentrancy",
        "reason": "The withdraw function allows for an external call to transfer funds (plyr_[_pID].addr.transfer(_eth)) before updating the player's balance. This could be exploited by attackers to re-enter the function and withdraw more funds before their balance is updated.",
        "file_name": "0x125365069020439b830c9eac9dd402f8aa762569.sol"
    },
    {
        "function_name": "distributeExternal",
        "code": "function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_) private returns(RSdatasets.EventReturns) { uint256 _com = _eth * 5 / 100; uint256 _aff = _eth / 10; if (_affID != _pID && plyr_[_affID].name != '') { plyr_[_affID].aff = _aff.add(plyr_[_affID].aff); emit RSEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now); } else { plyr_[_pID].aff = _aff.add(plyr_[_pID].aff); } if (!address(RatKingCorp).call.value(_com)(bytes4(keccak256(\"deposit()\")))) { } return(_eventData_); }",
        "vulnerability": "Unchecked External Call",
        "reason": "The function makes an external call to the RatKingCorp contract without checking its success. This can be exploited if the RatKingCorp contract is malicious or behaves unexpectedly, potentially leading to loss of funds or other unintended behaviors.",
        "file_name": "0x125365069020439b830c9eac9dd402f8aa762569.sol"
    },
    {
        "function_name": "airdrop",
        "code": "function airdrop() private view returns(bool) { uint256 seed = uint256(keccak256(abi.encodePacked( (block.timestamp).add (block.difficulty).add ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add (block.gaslimit).add ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add (block.number) ))); if((seed - ((seed / 1000) * 1000)) < airDropTracker_) return(true); else return(false); }",
        "vulnerability": "Predictable Randomness",
        "reason": "The randomness for the airdrop function is derived from block variables such as block timestamp and block difficulty, which can be influenced or predicted by miners. This makes the randomness predictable, allowing potential manipulation of the airdrop outcome.",
        "file_name": "0x125365069020439b830c9eac9dd402f8aa762569.sol"
    }
]