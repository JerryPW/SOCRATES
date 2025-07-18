[
    {
        "function_name": "register",
        "code": "function register() public payable { address _customerAddress = msg.sender; require( tx.origin == _customerAddress && !playerRegistered[_customerAddress] && _isCorrectBuyin (msg.value)); registeredPlayers = SafeMath.addint256(registeredPlayers, 1); playerRegistered[_customerAddress] = true; playerGamesScored[_customerAddress] = 0; playerList.push(_customerAddress); uint fivePercent = 0.01009 ether; uint tenPercent = 0.02018 ether; uint prizeEth = (msg.value).sub(tenPercent); require(playerRegistered[_customerAddress]); prizePool = prizePool.add(prizeEth); givethPool = givethPool.add(fivePercent); administrator.send(fivePercent); emit Registration(_customerAddress); }",
        "vulnerability": "Use of tx.origin for Authentication",
        "reason": "The register function uses tx.origin to verify the sender, which is susceptible to phishing attacks. An attacker can trick a user into calling a malicious contract that then calls this function, making it appear as though the request came from the user directly.",
        "file_name": "0x4c60e311d8fba04e313f7e7b3dec61b3028726d1.sol"
    },
    {
        "function_name": "concludeTournament",
        "code": "function concludeTournament(address _first , address _second , address _third , address _fourth) isAdministrator public { require(gameFinished[64] && playerIsRegistered(_first) && playerIsRegistered(_second) && playerIsRegistered(_third) && playerIsRegistered(_fourth)); givethAddress.send(givethPool); uint tenth = prizePool.div(10); _first.send (tenth.mul(4)); _second.send(tenth.mul(3)); _third.send (tenth.mul(2)); _fourth.send(address(this).balance); selfdestruct(administrator); }",
        "vulnerability": "Unsafe Use of send() Function",
        "reason": "The concludeTournament function uses send() for transferring Ether, which forwards only 2300 gas and can fail if the recipient is a contract with a fallback function that requires more than 2300 gas. This can lead to failed transactions and locked funds.",
        "file_name": "0x4c60e311d8fba04e313f7e7b3dec61b3028726d1.sol"
    },
    {
        "function_name": "pullRipCord",
        "code": "function pullRipCord() isAdministrator public { uint players = playerList.length; for (uint i = 0; i < players; i++) { address _toRefund = playerList[i]; _toRefund.send(0.19171 ether); emit RipcordRefund(_toRefund); } selfdestruct(administrator); }",
        "vulnerability": "Potential for Denial of Service",
        "reason": "The pullRipCord function iterates over the playerList and uses send(), which can fail if a player's address is a contract that consumes more than 2300 gas. This could block the entire refund process, resulting in a denial of service for other participants.",
        "file_name": "0x4c60e311d8fba04e313f7e7b3dec61b3028726d1.sol"
    }
]