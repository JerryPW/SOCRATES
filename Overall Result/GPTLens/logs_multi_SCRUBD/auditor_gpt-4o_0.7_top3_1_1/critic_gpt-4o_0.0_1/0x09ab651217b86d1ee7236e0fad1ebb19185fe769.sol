[
    {
        "function_name": "endRound",
        "vulnerability": "Untrusted call to external contract",
        "criticism": "The reasoning is correct. The function does make calls to two external addresses without checking if they are trusted contracts or if they have fallback functions that consume all gas. This could potentially allow reentrancy or denial-of-service attacks. The severity is high because it could lead to loss of funds or service disruption. The profitability is also high because an attacker could potentially drain the contract's funds.",
        "correctness": 9,
        "severity": 8,
        "profitability": 8,
        "reason": "The function makes calls to two external addresses (`monkeyKing` and `monkeyQueue`) without checking if they are trusted contracts or if they have fallback functions that consume all gas, potentially allowing reentrancy or denial-of-service attacks.",
        "code": "function endRound(LDdatasets.EventReturns memory _eventData_) private returns (LDdatasets.EventReturns) { uint256 _winPID = round_.plyr; uint256 _pot = round_.pot + airDropPot_; uint256 _win = (_pot.mul(40)) / 100; uint256 _com = (_pot.mul(30)) / 100; uint256 _queen = (_pot.mul(10)) / 100; uint256 _gen = (_pot.mul(20)) / 100; uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys); uint256 _dust = _gen.sub((_ppt.mul(round_.keys)) / 1000000000000000000); if (_dust > 0) { _gen = _gen.sub(_dust); _com = _com.add(_dust); } plyr_[_winPID].win = _win.add(plyr_[_winPID].win); if (!address(monkeyKing).call.value(_com)()) { _gen = _gen.add(_com); _com = 0; } if (!address(monkeyQueue).call.value(_queen)()) { _gen = _gen.add(_queen); _queen = 0; } round_.mask = _ppt.add(round_.mask); _eventData_.compressedData = _eventData_.compressedData + (round_.end * 1000000); _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000); _eventData_.winnerAddr = plyr_[_winPID].addr; _eventData_.winnerName = plyr_[_winPID].name; _eventData_.amountWon = _win; _eventData_.genAmount = _gen; _eventData_.newPot = 0; return(_eventData_); }",
        "file_name": "0x09ab651217b86d1ee7236e0fad1ebb19185fe769.sol"
    },
    {
        "function_name": "airdrop",
        "vulnerability": "Predictable randomness",
        "criticism": "The reasoning is correct. The seed for the random number generation does use block attributes that can be manipulated by miners to influence the outcome of the airdrop. This could potentially benefit certain players. However, the severity and profitability are moderate because it requires significant resources to manipulate these attributes and the benefit is not guaranteed.",
        "correctness": 9,
        "severity": 5,
        "profitability": 5,
        "reason": "The seed for the random number generation uses block attributes such as `block.timestamp`, `block.difficulty`, and others that can be manipulated by miners to influence the outcome of the airdrop, potentially benefiting certain players.",
        "code": "function airdrop() private view returns(bool) { uint256 seed = uint256(keccak256(abi.encodePacked( (block.timestamp).add (block.difficulty).add ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add (block.gaslimit).add ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add (block.number) ))); if((seed - ((seed / 1000) * 1000)) < airDropTracker_) return(true); else return(false); }",
        "file_name": "0x09ab651217b86d1ee7236e0fad1ebb19185fe769.sol"
    },
    {
        "function_name": "withdraw",
        "vulnerability": "Reentrancy vulnerability",
        "criticism": "The reasoning is partially correct. The function does use a low-level call to send ether to the player's address. However, it does update the player's balance before the transfer, which mitigates the risk of a reentrancy attack. The severity and profitability are low because the function is not vulnerable to a reentrancy attack as stated.",
        "correctness": 4,
        "severity": 2,
        "profitability": 2,
        "reason": "The function uses a low-level call (`transfer`) to send ether to the player's address without updating the player's balance before the transfer, which can be exploited by a reentrancy attack if the player address is a contract with a fallback function.",
        "code": "function withdraw() isActivated() isHuman() public { uint256 _now = now; uint256 _pID = pIDxAddr_[msg.sender]; uint256 _eth; if (_now > round_.end && round_.ended == false && round_.plyr != 0) { LDdatasets.EventReturns memory _eventData_; round_.ended = true; _eventData_ = endRound(_eventData_); _eth = withdrawEarnings(_pID); if (_eth > 0) plyr_[_pID].addr.transfer(_eth); _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000); _eventData_.compressedIDs = _eventData_.compressedIDs + _pID; emit MonkeyEvents.onWithdrawAndDistribute ( msg.sender, plyr_[_pID].name, _eth, _eventData_.compressedData, _eventData_.compressedIDs, _eventData_.winnerAddr, _eventData_.winnerName, _eventData_.amountWon, _eventData_.newPot, _eventData_.genAmount ); } else { _eth = withdrawEarnings(_pID); if (_eth > 0) plyr_[_pID].addr.transfer(_eth); emit MonkeyEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now); } }",
        "file_name": "0x09ab651217b86d1ee7236e0fad1ebb19185fe769.sol"
    }
]