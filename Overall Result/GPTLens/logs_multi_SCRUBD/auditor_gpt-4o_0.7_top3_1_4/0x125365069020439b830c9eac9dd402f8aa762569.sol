[
    {
        "function_name": "withdraw",
        "code": "function withdraw() isActivated() isHuman() public {\n    uint256 _now = now;\n    uint256 _pID = pIDxAddr_[msg.sender];\n    uint256 _eth;\n    if (_now > round_.end && round_.ended == false && round_.plyr != 0) {\n        RSdatasets.EventReturns memory _eventData_;\n        round_.ended = true;\n        _eventData_ = endRound(_eventData_);\n        _eth = withdrawEarnings(_pID);\n        if (_eth > 0)\n            plyr_[_pID].addr.transfer(_eth);\n        _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);\n        _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;\n        emit RSEvents.onWithdrawAndDistribute (\n            msg.sender, \n            plyr_[_pID].name, \n            _eth, \n            _eventData_.compressedData, \n            _eventData_.compressedIDs, \n            _eventData_.winnerAddr, \n            _eventData_.winnerName, \n            _eventData_.amountWon, \n            _eventData_.newPot, \n            _eventData_.genAmount\n        );\n    } else {\n        _eth = withdrawEarnings(_pID);\n        if (_eth > 0)\n            plyr_[_pID].addr.transfer(_eth);\n        emit RSEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);\n    }\n}",
        "vulnerability": "Reentrancy attack",
        "reason": "The withdraw function transfers Ether to the player's address before updating their balance. This could be exploited by attackers using a fallback function to call withdraw again before the state is updated, potentially draining the contract of funds.",
        "file_name": "0x125365069020439b830c9eac9dd402f8aa762569.sol"
    },
    {
        "function_name": "airdrop",
        "code": "function airdrop() private view returns(bool) {\n    uint256 seed = uint256(keccak256(abi.encodePacked(\n        (block.timestamp).add \n        (block.difficulty).add \n        ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add \n        (block.gaslimit).add \n        ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add \n        (block.number) \n    )));\n    if((seed - ((seed / 1000) * 1000)) < airDropTracker_)\n        return(true);\n    else\n        return(false);\n}",
        "vulnerability": "Predictable randomness",
        "reason": "The airdrop function uses block attributes such as block.timestamp and block.difficulty to generate randomness. These can be manipulated by miners to influence the result, making the randomness predictable and allowing attackers to exploit the airdrop mechanism.",
        "file_name": "0x125365069020439b830c9eac9dd402f8aa762569.sol"
    },
    {
        "function_name": "distributeExternal",
        "code": "function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_) private returns(RSdatasets.EventReturns) {\n    uint256 _com = _eth * 5 / 100;\n    uint256 _aff = _eth / 10;\n    if (_affID != _pID && plyr_[_affID].name != '') {\n        plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);\n        emit RSEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _pID, _aff, now);\n    } else {\n        plyr_[_pID].aff = _aff.add(plyr_[_pID].aff);\n    }\n    if (!address(RatKingCorp).call.value(_com)(bytes4(keccak256(\"deposit()\")))) {\n    }\n    return(_eventData_);\n}",
        "vulnerability": "Unchecked external call",
        "reason": "The contract makes an external call to the RatKingCorp contract using low-level call without checking the success of the call. If the call fails, it could lead to unexpected behavior or loss of funds as the contract assumes the call was successful without verifying it.",
        "file_name": "0x125365069020439b830c9eac9dd402f8aa762569.sol"
    }
]