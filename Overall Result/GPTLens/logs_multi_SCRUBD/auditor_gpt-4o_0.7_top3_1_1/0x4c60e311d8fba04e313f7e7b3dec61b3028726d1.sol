[
    {
        "function_name": "concludeTournament",
        "code": "function concludeTournament(address _first , address _second , address _third , address _fourth) isAdministrator public { require(gameFinished[64] && playerIsRegistered(_first) && playerIsRegistered(_second) && playerIsRegistered(_third) && playerIsRegistered(_fourth)); givethAddress.send(givethPool); uint tenth = prizePool.div(10); _first.send (tenth.mul(4)); _second.send(tenth.mul(3)); _third.send (tenth.mul(2)); _fourth.send(address(this).balance); selfdestruct(administrator); }",
        "vulnerability": "Improper use of send function and lack of proper error handling",
        "reason": "The send function is used to transfer ether, which only forwards 2300 gas and does not throw an error if the transaction fails. This may lead to failed transactions if the recipient address has a fallback function that consumes more than 2300 gas. Moreover, selfdestruct is called without ensuring that all funds have been properly distributed, potentially leaving funds locked in the contract if any send operation fails.",
        "file_name": "0x4c60e311d8fba04e313f7e7b3dec61b3028726d1.sol"
    },
    {
        "function_name": "pullRipCord",
        "code": "function pullRipCord() isAdministrator public { uint players = playerList.length; for (uint i = 0; i < players; i++) { address _toRefund = playerList[i]; _toRefund.send(0.19171 ether); emit RipcordRefund(_toRefund); } selfdestruct(administrator); }",
        "vulnerability": "Improper use of send function and risk of Ether loss",
        "reason": "Similar to concludeTournament, the send function is used, which does not throw an error on failure and only forwards limited gas. If any refund fails, the Ether could remain locked in the contract and the error will go unnoticed. Additionally, calling selfdestruct without checking if all refunds were successful can result in loss of remaining Ether in the contract.",
        "file_name": "0x4c60e311d8fba04e313f7e7b3dec61b3028726d1.sol"
    },
    {
        "function_name": "makePrediction",
        "code": "function makePrediction(int8 _gameID, string _prediction) public { address _customerAddress = msg.sender; uint predictionTime = now; require(playerRegistered[_customerAddress] && !gameFinished[_gameID] && predictionTime < gameLocked[_gameID]); if (_gameID > 48 && equalStrings(_prediction, \"DRAW\")) { revert(); } else { playerPredictions[_customerAddress][_gameID] = _prediction; playerMadePrediction[_customerAddress][_gameID] = true; emit PlayerLoggedPrediction(_customerAddress, _gameID, _prediction); } }",
        "vulnerability": "Potential denial of service due to string comparison",
        "reason": "The function uses the equalStrings method to compare strings, which could be a potential vector for a denial of service attack by providing inputs that cause extensive string comparisons. Additionally, strings in Solidity are less efficient, and using bytes32 for fixed size strings would be more optimal.",
        "file_name": "0x4c60e311d8fba04e313f7e7b3dec61b3028726d1.sol"
    }
]