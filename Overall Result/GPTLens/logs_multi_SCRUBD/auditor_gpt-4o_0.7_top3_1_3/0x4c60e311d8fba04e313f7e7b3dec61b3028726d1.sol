[
    {
        "function_name": "register",
        "code": "function register() public payable {\n    address _customerAddress = msg.sender;\n    require( tx.origin == _customerAddress && !playerRegistered[_customerAddress] && _isCorrectBuyin (msg.value));\n    registeredPlayers = SafeMath.addint256(registeredPlayers, 1);\n    playerRegistered[_customerAddress] = true;\n    playerGamesScored[_customerAddress] = 0;\n    playerList.push(_customerAddress);\n    uint fivePercent = 0.01009 ether;\n    uint tenPercent = 0.02018 ether;\n    uint prizeEth = (msg.value).sub(tenPercent);\n    require(playerRegistered[_customerAddress]);\n    prizePool = prizePool.add(prizeEth);\n    givethPool = givethPool.add(fivePercent);\n    administrator.send(fivePercent);\n    emit Registration(_customerAddress);\n}",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The use of `send` to transfer Ether to the administrator can lead to reentrancy attacks. If the administrator is a contract with a fallback function, it can re-enter the contract, potentially causing unexpected behavior or state changes.",
        "file_name": "0x4c60e311d8fba04e313f7e7b3dec61b3028726d1.sol"
    },
    {
        "function_name": "concludeTournament",
        "code": "function concludeTournament(address _first , address _second , address _third , address _fourth) isAdministrator public {\n    require(gameFinished[64] && playerIsRegistered(_first) && playerIsRegistered(_second) && playerIsRegistered(_third) && playerIsRegistered(_fourth));\n    givethAddress.send(givethPool);\n    uint tenth = prizePool.div(10);\n    _first.send (tenth.mul(4));\n    _second.send(tenth.mul(3));\n    _third.send (tenth.mul(2));\n    _fourth.send(address(this).balance);\n    selfdestruct(administrator);\n}",
        "vulnerability": "Denial of Service via Failed Ether Transfer",
        "reason": "The use of `send` can fail and return false without reverting the transaction. If any of the addresses (_first, _second, _third, _fourth) are contracts with fallback functions that consume more than 2300 gas, the send operation will fail, potentially blocking the execution of the `concludeTournament` function and the subsequent `selfdestruct`.",
        "file_name": "0x4c60e311d8fba04e313f7e7b3dec61b3028726d1.sol"
    },
    {
        "function_name": "pullRipCord",
        "code": "function pullRipCord() isAdministrator public {\n    uint players = playerList.length;\n    for (uint i = 0; i < players; i++) {\n        address _toRefund = playerList[i];\n        _toRefund.send(0.19171 ether);\n        emit RipcordRefund(_toRefund);\n    }\n    selfdestruct(administrator);\n}",
        "vulnerability": "Inefficient Gas Usage and Potential DoS",
        "reason": "The function iterates through the entire player list and uses `send` to transfer Ether. If the player list is large, this will consume a lot of gas and may run out of gas before completing all transfers. Additionally, if any `send` fails due to out-of-gas or other reasons, the loop will continue, potentially allowing a denial of service on this function.",
        "file_name": "0x4c60e311d8fba04e313f7e7b3dec61b3028726d1.sol"
    }
]