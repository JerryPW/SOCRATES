[
    {
        "function_name": "determineNextRoundLength",
        "vulnerability": "Predictable randomness",
        "criticism": "The reasoning is correct. The use of 'blockhash' and 'keccak256' for randomness is predictable and can be influenced by miners, making it insecure for generating random values. This can lead to exploitation if the randomness is used in critical game mechanics. The severity is moderate as it depends on how the randomness is used in the contract. The profitability is moderate because an attacker could potentially exploit this to gain an advantage in the game.",
        "correctness": 8,
        "severity": 5,
        "profitability": 5,
        "reason": "The function 'determineNextRoundLength' uses 'blockhash' and 'keccak256' to generate pseudo-randomness, which can be manipulated by miners. This allows an attacker to predict or influence the outcome of the function, potentially leading to exploitation of the game's mechanics.",
        "code": "function determineNextRoundLength() internal view returns(uint256 time) { uint256 roundTime = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1)))) % 6; return roundTime; }",
        "file_name": "0x1a050d77003caee532df18d04d86b99ca15bf9e8.sol"
    },
    {
        "function_name": "distributeExternal",
        "vulnerability": "Unsafe external call",
        "criticism": "The reasoning is correct. The use of 'call.value()' for external calls can indeed lead to reentrancy vulnerabilities. However, the function does not update any state variables after the call, which reduces the risk of reentrancy. The severity is moderate because the function could still be exploited if the external call is manipulated. The profitability is moderate as an attacker could potentially redirect funds.",
        "correctness": 8,
        "severity": 5,
        "profitability": 5,
        "reason": "The 'distributeExternal' function makes external calls using 'call.value()', which can lead to reentrancy vulnerabilities. An attacker could exploit this by creating a contract that uses reentrancy techniques to manipulate the flow of the function, potentially stealing funds.",
        "code": "function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, POOHMODatasets.EventReturns memory _eventData_) private returns(POOHMODatasets.EventReturns) { uint256 _dev = _eth / 100; uint256 _POOH = 0; if (!address(admin).call.value(_dev)()) { _POOH = _dev; _dev = 0; } uint256 _aff = _eth / 10; if (_affID != _pID && plyr_[_affID].name != '') { plyr_[_affID].aff = _aff.add(plyr_[_affID].aff); emit POOHMOevents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now); } else { _POOH = _POOH.add(_aff); } _POOH = _POOH.add((_eth.mul(fees_[_team].pooh)) / (100)); if (_POOH > 0) { flushDivs.call.value(_POOH)(bytes4(keccak256(\"donate()\"))); _eventData_.POOHAmount = _POOH.add(_eventData_.POOHAmount); } return(_eventData_); }",
        "file_name": "0x1a050d77003caee532df18d04d86b99ca15bf9e8.sol"
    },
    {
        "function_name": "withdraw",
        "vulnerability": "Reentrancy vulnerability",
        "criticism": "The reasoning is correct. The 'withdraw' function transfers Ether before updating the state, which is a classic pattern for reentrancy vulnerabilities. This can be exploited by malicious contracts to repeatedly call the function and drain funds. The severity is high because it can lead to significant financial loss. The profitability is high as an attacker could potentially drain the contract of its funds.",
        "correctness": 9,
        "severity": 8,
        "profitability": 8,
        "reason": "The 'withdraw' function transfers Ether to the player's address before updating internal state variables. This sequence can be exploited by malicious contracts to perform a reentrancy attack, potentially draining the contract of funds.",
        "code": "function withdraw() isActivated() isHuman() public { uint256 _rID = rID_; uint256 _now = now; uint256 _pID = pIDxAddr_[msg.sender]; uint256 _eth; if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0) { POOHMODatasets.EventReturns memory _eventData_; round_[_rID].ended = true; _eventData_ = endRound(_eventData_); _eth = withdrawEarnings(_pID); if (_eth > 0) plyr_[_pID].addr.transfer(_eth); _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000); _eventData_.compressedIDs = _eventData_.compressedIDs + _pID; emit POOHMOevents.onWithdrawAndDistribute ( msg.sender, plyr_[_pID].name, _eth, _eventData_.compressedData, _eventData_.compressedIDs, _eventData_.winnerAddr, _eventData_.winnerName, _eventData_.amountWon, _eventData_.newPot, _eventData_.POOHAmount, _eventData_.genAmount ); } else { _eth = withdrawEarnings(_pID); if (_eth > 0) plyr_[_pID].addr.transfer(_eth); emit POOHMOevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now); } }",
        "file_name": "0x1a050d77003caee532df18d04d86b99ca15bf9e8.sol"
    }
]