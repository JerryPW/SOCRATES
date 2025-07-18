[
    {
        "function_name": "withdraw",
        "code": "function withdraw() isActivated() isHuman() public { uint256 _now = now; uint256 _pID = pIDxAddr_[msg.sender]; uint256 _eth; if (_now > round_.end && round_.ended == false && round_.plyr != 0) { RSdatasets.EventReturns memory _eventData_; round_.ended = true; _eventData_ = endRound(_eventData_); _eth = withdrawEarnings(_pID); if (_eth > 0) plyr_[_pID].addr.transfer(_eth); _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000); _eventData_.compressedIDs = _eventData_.compressedIDs + _pID; emit RSEvents.onWithdrawAndDistribute ( msg.sender, plyr_[_pID].name, _eth, _eventData_.compressedData, _eventData_.compressedIDs, _eventData_.winnerAddr, _eventData_.winnerName, _eventData_.amountWon, _eventData_.newPot, _eventData_.genAmount ); } else { _eth = withdrawEarnings(_pID); if (_eth > 0) plyr_[_pID].addr.transfer(_eth); emit RSEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now); } }",
        "vulnerability": "Reentrancy",
        "reason": "The withdraw function allows users to withdraw their earnings, and the transfer method is used for sending Ether, which is vulnerable to reentrancy attacks. An attacker could potentially exploit this by recursively calling the withdraw function, draining the contract's funds.",
        "file_name": "0x125365069020439b830c9eac9dd402f8aa762569.sol"
    },
    {
        "function_name": "endRound",
        "code": "function endRound(RSdatasets.EventReturns memory _eventData_) private returns (RSdatasets.EventReturns) { uint256 _winPID = round_.plyr; uint256 _pot = round_.pot + airDropPot_; uint256 _win = (_pot.mul(45)) / 100; uint256 _com = (_pot / 10); uint256 _gen = (_pot.mul(potSplit_)) / 100; uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys); uint256 _dust = _gen.sub((_ppt.mul(round_.keys)) / 1000000000000000000); if (_dust > 0) { _gen = _gen.sub(_dust); _com = _com.add(_dust); } plyr_[_winPID].win = _win.add(plyr_[_winPID].win); if (!address(RatKingCorp).call.value(_com)(bytes4(keccak256(\"deposit()\")))) { _gen = _gen.add(_com); _com = 0; } round_.mask = _ppt.add(round_.mask); _eventData_.compressedData = _eventData_.compressedData + (round_.end * 1000000); _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000); _eventData_.winnerAddr = plyr_[_winPID].addr; _eventData_.winnerName = plyr_[_winPID].name; _eventData_.amountWon = _win; _eventData_.genAmount = _gen; _eventData_.newPot = 0; return(_eventData_); }",
        "vulnerability": "Unchecked External Call",
        "reason": "In the endRound function, the contract makes a low-level call to the RatKingCorp address without checking for an error. This can be exploited by an attacker to use a malicious contract that fails the call, potentially causing incorrect state updates or fund transfers to fail silently.",
        "file_name": "0x125365069020439b830c9eac9dd402f8aa762569.sol"
    },
    {
        "function_name": "airdrop",
        "code": "function airdrop() private view returns(bool) { uint256 seed = uint256(keccak256(abi.encodePacked( (block.timestamp).add (block.difficulty).add ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add (block.gaslimit).add ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add (block.number) ))); if((seed - ((seed / 1000) * 1000)) < airDropTracker_) return(true); else return(false); }",
        "vulnerability": "Predictable Randomness",
        "reason": "The airdrop function uses block attributes such as timestamp and block number to generate a random seed, which are predictable and can be manipulated by miners. This allows an attacker to predict the outcome of the airdrop and exploit it to their advantage.",
        "file_name": "0x125365069020439b830c9eac9dd402f8aa762569.sol"
    }
]