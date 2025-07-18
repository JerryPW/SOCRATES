[
    {
        "function_name": "register",
        "code": "function register() public payable { address _customerAddress = msg.sender; require( tx.origin == _customerAddress && !playerRegistered[_customerAddress] && _isCorrectBuyin (msg.value)); registeredPlayers = SafeMath.addint256(registeredPlayers, 1); playerRegistered[_customerAddress] = true; playerGamesScored[_customerAddress] = 0; playerList.push(_customerAddress); uint fivePercent = 0.01009 ether; uint tenPercent = 0.02018 ether; uint prizeEth = (msg.value).sub(tenPercent); require(playerRegistered[_customerAddress]); prizePool = prizePool.add(prizeEth); givethPool = givethPool.add(fivePercent); administrator.send(fivePercent); emit Registration(_customerAddress); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The use of `send` to transfer ether to `administrator` without ensuring that the state changes are finalized before the transfer can lead to a reentrancy attack. An attacker could re-enter the contract before the state is updated, allowing them to register multiple times with the same ether sent.",
        "file_name": "0x4c60e311d8fba04e313f7e7b3dec61b3028726d1.sol"
    },
    {
        "function_name": "concludeTournament",
        "code": "function concludeTournament(address _first , address _second , address _third , address _fourth) isAdministrator public { require(gameFinished[64] && playerIsRegistered(_first) && playerIsRegistered(_second) && playerIsRegistered(_third) && playerIsRegistered(_fourth)); givethAddress.send(givethPool); uint tenth = prizePool.div(10); _first.send (tenth.mul(4)); _second.send(tenth.mul(3)); _third.send (tenth.mul(2)); _fourth.send(address(this).balance); selfdestruct(administrator); }",
        "vulnerability": "Unchecked send calls can fail",
        "reason": "The function uses `send` to transfer ether, which can fail silently, resulting in funds being lost or not transferred as expected. If any of the `send` operations fail, the subsequent operations will not revert, potentially disrupting the distribution of the prize pool.",
        "file_name": "0x4c60e311d8fba04e313f7e7b3dec61b3028726d1.sol"
    },
    {
        "function_name": "pullRipCord",
        "code": "function pullRipCord() isAdministrator public { uint players = playerList.length; for (uint i = 0; i < players; i++) { address _toRefund = playerList[i]; _toRefund.send(0.19171 ether); emit RipcordRefund(_toRefund); } selfdestruct(administrator); }",
        "vulnerability": "Potential for funds to be locked",
        "reason": "The use of `send` for refunding players can fail if the player's address has a fallback function that uses more than 2300 gas or if the address is a contract without a payable fallback function. This could result in some players not receiving their refunds, leaving funds locked in the contract.",
        "file_name": "0x4c60e311d8fba04e313f7e7b3dec61b3028726d1.sol"
    }
]