[
    {
        "function_name": "buyByAddress",
        "code": "function buyByAddress(address referee) external payable { uint8 rate = 1; if (msg.value == PRICE) { rate = 1; } else if (msg.value == PRICE * 5) { rate = 5; } else if (msg.value == PRICE * 10) { rate = 10; } else { require(false); } resetStage(rate); buy(rate); overStage(rate); if (_addressMap[msg.sender] == 0) { if (referee != 0x0000000000000000000000000000000000000000 && referee != msg.sender && _valueMap[referee] >= 0) { _addressMap[msg.sender] = referee; } else { _addressMap[msg.sender] = OFFICIAL; } } emit BraveReferrer(_addressMap[msg.sender],msg.sender,rate); }",
        "vulnerability": "Reentrancy Attack",
        "reason": "The function does not use any reentrancy guard when interacting with the external contract HourglassInterface. This could allow an attacker to exploit the contract by performing a reentrancy attack, especially if the external contract calls back into this contract before state variables are updated, leading to potential double spending or manipulation of ether transfers.",
        "file_name": "0x132e2b67e91bf0294536b16d772e8dee099fc40c.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() external hasEarnings { uint256 amount = _valueMap[msg.sender]; _valueMap[msg.sender] = 0; emit BraveWithdraw(msg.sender, amount); msg.sender.transfer(amount); overStage(1); overStage(5); overStage(10); }",
        "vulnerability": "Reentrancy Attack",
        "reason": "The withdraw function performs an ether transfer to msg.sender without using the Checks-Effects-Interactions pattern. This allows an attacker to exploit the function by re-entering the contract before _valueMap[msg.sender] is set to 0, potentially allowing them to withdraw more funds than they are entitled to.",
        "file_name": "0x132e2b67e91bf0294536b16d772e8dee099fc40c.sol"
    },
    {
        "function_name": "overStage",
        "code": "function overStage(uint8 rate) private { uint256 curStageIndex = _currentMap[rate]; uint256 finishStageIndex = _finishMap[rate]; assert(curStageIndex >= finishStageIndex); if (curStageIndex == finishStageIndex) {return;} Stage storage finishStage = _stageMap[rate][finishStageIndex]; assert(!finishStage.isFinish); if (finishStage.cnt < MAX_PLAYERS) {return;} assert(finishStage.blocknumber != 0); if (block.number - 256 <= finishStage.blocknumber) { if (block.number == finishStage.blocknumber) {return;} uint8 deadIndex = uint8(blockhash(finishStage.blocknumber)) % MAX_PLAYERS; address deadPlayer = finishStage.playerMap[deadIndex]; emit BraveDeadPlayer(deadPlayer,finishStageIndex,deadIndex, rate); finishStage.deadIndex = deadIndex; for (uint8 i = 0; i < MAX_PLAYERS; i++) { address player = finishStage.playerMap[i]; if (deadIndex != i) { _valueMap[player] += WIN_VALUE * rate; } address referee = _addressMap[player]; _valueMap[referee] += REFEREE_VALUE * rate; _referredMap[referee] += REFEREE_VALUE * rate; } uint256 dividends = p3dContract.myDividends(true); if (dividends > 0) { p3dContract.withdraw(); _valueMap[deadPlayer] += dividends; } p3dContract.buy.value(P3D_VALUE * rate)(address(OFFICIAL_P3D)); } else { for (uint8 j = 0; j < MAX_PLAYERS; j++) { _valueMap[finishStage.playerMap[j]] += PRICE * rate; } emit BraveInvalidateStage(finishStageIndex, rate); } finishStage.isFinish = true; finishStageIndex++; _finishMap[rate] = finishStageIndex; }",
        "vulnerability": "Blockhash Usage for Randomness",
        "reason": "The function uses blockhash for determining the deadIndex, which is used to decide payouts. This is insecure because blockhash can be manipulated by miners, especially if the blockhash is of a recent block. This could allow miners to exploit the randomness to their advantage.",
        "file_name": "0x132e2b67e91bf0294536b16d772e8dee099fc40c.sol"
    }
]