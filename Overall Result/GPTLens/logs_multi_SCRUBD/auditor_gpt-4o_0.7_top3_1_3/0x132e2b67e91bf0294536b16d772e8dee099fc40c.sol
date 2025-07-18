[
    {
        "function_name": "withdraw",
        "code": "function withdraw() external hasEarnings { uint256 amount = _valueMap[msg.sender]; _valueMap[msg.sender] = 0; emit BraveWithdraw(msg.sender, amount); msg.sender.transfer(amount); overStage(1); overStage(5); overStage(10); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The withdraw function transfers Ether to the caller before updating any state variables related to the caller's balance, specifically _valueMap[msg.sender]. This leaves the contract open to a reentrancy attack, where an attacker could call withdraw again before the initial call finishes, allowing them to drain funds beyond their balance.",
        "file_name": "0x132e2b67e91bf0294536b16d772e8dee099fc40c.sol"
    },
    {
        "function_name": "buyByAddress",
        "code": "function buyByAddress(address referee) external payable { uint8 rate = 1; if (msg.value == PRICE) { rate = 1; } else if (msg.value == PRICE * 5) { rate = 5; } else if (msg.value == PRICE * 10) { rate = 10; } else { require(false); } resetStage(rate); buy(rate); overStage(rate); if (_addressMap[msg.sender] == 0) { if (referee != 0x0000000000000000000000000000000000000000 && referee != msg.sender && _valueMap[referee] >= 0) { _addressMap[msg.sender] = referee; } else { _addressMap[msg.sender] = OFFICIAL; } } emit BraveReferrer(_addressMap[msg.sender],msg.sender,rate); }",
        "vulnerability": "Arbitrary Ether acceptance",
        "reason": "The buyByAddress function accepts ether and requires exact amounts to match specific rates. However, it does not handle situations where msg.value is neither PRICE, PRICE * 5, or PRICE * 10, leading to a condition where require(false) is triggered, causing a revert without any informative error message. This could also lead to potential loss of funds if the external call logic is not thoroughly tested or handled.",
        "file_name": "0x132e2b67e91bf0294536b16d772e8dee099fc40c.sol"
    },
    {
        "function_name": "overStage",
        "code": "function overStage(uint8 rate) private { uint256 curStageIndex = _currentMap[rate]; uint256 finishStageIndex = _finishMap[rate]; assert(curStageIndex >= finishStageIndex); if (curStageIndex == finishStageIndex) {return;} Stage storage finishStage = _stageMap[rate][finishStageIndex]; assert(!finishStage.isFinish); if (finishStage.cnt < MAX_PLAYERS) {return;} assert(finishStage.blocknumber != 0); if (block.number - 256 <= finishStage.blocknumber) { if (block.number == finishStage.blocknumber) {return;} uint8 deadIndex = uint8(blockhash(finishStage.blocknumber)) % MAX_PLAYERS; address deadPlayer = finishStage.playerMap[deadIndex]; emit BraveDeadPlayer(deadPlayer,finishStageIndex,deadIndex, rate); finishStage.deadIndex = deadIndex; for (uint8 i = 0; i < MAX_PLAYERS; i++) { address player = finishStage.playerMap[i]; if (deadIndex != i) { _valueMap[player] += WIN_VALUE * rate; } address referee = _addressMap[player]; _valueMap[referee] += REFEREE_VALUE * rate; _referredMap[referee] += REFEREE_VALUE * rate; } uint256 dividends = p3dContract.myDividends(true); if (dividends > 0) { p3dContract.withdraw(); _valueMap[deadPlayer] += dividends; } p3dContract.buy.value(P3D_VALUE * rate)(address(OFFICIAL_P3D)); } else { for (uint8 j = 0; j < MAX_PLAYERS; j++) { _valueMap[finishStage.playerMap[j]] += PRICE * rate; } emit BraveInvalidateStage(finishStageIndex, rate); } finishStage.isFinish = true; finishStageIndex++; _finishMap[rate] = finishStageIndex; }",
        "vulnerability": "Blockhash dependency",
        "reason": "The overStage function uses blockhash of a past block to determine the `deadIndex`, which is used to decide player eliminations. Ethereum blockhashes can only be reliably retrieved for the last 256 blocks, meaning the function will fail if the current block number is more than 256 blocks past the recorded block number, potentially causing the stage to hang indefinitely.",
        "file_name": "0x132e2b67e91bf0294536b16d772e8dee099fc40c.sol"
    }
]