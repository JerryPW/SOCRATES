[
    {
        "function_name": "distributeExternal",
        "code": "function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_) private returns(RSdatasets.EventReturns) { uint256 _com = _eth * 5 / 100; uint256 _aff = _eth / 10; if (_affID != _pID && plyr_[_affID].name != '') { plyr_[_affID].aff = _aff.add(plyr_[_affID].aff); emit RSEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now); } else { plyr_[_pID].aff = _aff.add(plyr_[_pID].aff); } if (!address(RatKingCorp).call.value(_com)(bytes4(keccak256(\"deposit()\")))) { } return(_eventData_); }",
        "vulnerability": "Unsecured External Call",
        "reason": "The function makes an unprotected external call to the RatKingCorp contract using `.call`. This can lead to reentrancy attacks if the external contract is malicious or compromised. The call is not secured by any reentrancy guard or followed by any checks to handle the case where the call fails, making it a potential target for attackers to exploit.",
        "file_name": "0x125365069020439b830c9eac9dd402f8aa762569.sol"
    },
    {
        "function_name": "endRound",
        "code": "function endRound(RSdatasets.EventReturns memory _eventData_) private returns (RSdatasets.EventReturns) { uint256 _winPID = round_.plyr; uint256 _pot = round_.pot + airDropPot_; uint256 _win = (_pot.mul(45)) / 100; uint256 _com = (_pot / 10); uint256 _gen = (_pot.mul(potSplit_)) / 100; uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys); uint256 _dust = _gen.sub((_ppt.mul(round_.keys)) / 1000000000000000000); if (_dust > 0) { _gen = _gen.sub(_dust); _com = _com.add(_dust); } plyr_[_winPID].win = _win.add(plyr_[_winPID].win); if (!address(RatKingCorp).call.value(_com)(bytes4(keccak256(\"deposit()\")))) { _gen = _gen.add(_com); _com = 0; } round_.mask = _ppt.add(round_.mask); _eventData_.compressedData = _eventData_.compressedData + (round_.end * 1000000); _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000); _eventData_.winnerAddr = plyr_[_winPID].addr; _eventData_.winnerName = plyr_[_winPID].name; _eventData_.amountWon = _win; _eventData_.genAmount = _gen; _eventData_.newPot = 0; return(_eventData_); }",
        "vulnerability": "Unsecured External Call",
        "reason": "Similar to `distributeExternal`, this function also makes an external call to the RatKingCorp contract using `.call` without any security measures such as reentrancy guards or success-checks. This can lead to reentrancy attacks where a malicious contract can manipulate the state before the function completes, especially since this function handles critical operations like distributing the pot.",
        "file_name": "0x125365069020439b830c9eac9dd402f8aa762569.sol"
    },
    {
        "function_name": "airdrop",
        "code": "function airdrop() private view returns(bool) { uint256 seed = uint256(keccak256(abi.encodePacked( (block.timestamp).add (block.difficulty).add ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add (block.gaslimit).add ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add (block.number) ))); if((seed - ((seed / 1000) * 1000)) < airDropTracker_) return(true); else return(false); }",
        "vulnerability": "Predictable Randomness",
        "reason": "The `airdrop` function uses several block properties to generate randomness. However, these properties (block.timestamp, block.difficulty, block.gaslimit, etc.) are predictable and can be manipulated by miners, leading to potential exploitation. An attacker can influence the outcome of the airdrop by controlling or predicting these properties.",
        "file_name": "0x125365069020439b830c9eac9dd402f8aa762569.sol"
    }
]