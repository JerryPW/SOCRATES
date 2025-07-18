[
    {
        "function_name": "GAME",
        "code": "function GAME( uint _ticketPool, uint _ticketPrice, uint _winnerPrize, uint _jackpotFactor, uint _jackpotCut, uint _tokenCut, uint _jackpotChance, address _ICO, address _BONUS ) public { require(1000000%_ticketPool == 0); require(_ICO != address(0)); require(_BONUS != address(0)); require(_ticketPool.mul(_ticketPrice) > _winnerPrize.add(_jackpotCut).add(_tokenCut)); ticketPool = _ticketPool; ticketPrice = _ticketPrice.mul(1000000000000); winnerPrize = _winnerPrize.mul(1000000000000); jackpotFactor = _jackpotFactor; jackpotCut = _jackpotCut.mul(1000000000000); tokenCut = _tokenCut.mul(1000000000000); jackpotChance = _jackpotChance; jackpot = 0; ticketsBought = 0; buyerNumber = 0; bank = AwardsTokensInterface(_ICO); bonus = AwardsTokensInterface(_BONUS); token = AwardsTokensInterface(_BONUS); owner = msg.sender; oraclize_setProof(proofType_Ledger); queueFunds = 0; queueIndex = 0; queueLength = 0; }",
        "vulnerability": "Arithmetic Overflow",
        "reason": "The constructor performs multiple arithmetic operations without using SafeMath, which could lead to integer overflow or underflow attacks, especially when initializing large values like ticket price, winner prize, etc.",
        "file_name": "0x00195777bed7025e78819156281192c85fb3cf9b.sol"
    },
    {
        "function_name": "__callback",
        "code": "function __callback(bytes32 _queryId, string _result, bytes _proof) public { require (msg.sender == oraclize_cbAddress()); if(oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) == 0){ uint randomNumber = uint(keccak256(_result)); startRaffle((randomNumber % 1000000)+1); } else if (ledgerCount <= 2){ LedgerFailed(\"Requesting new\"); ledgerCount = ledgerCount.add(1); getRandom(); } else { LedgerFailed(\"Stopping\"); } }",
        "vulnerability": "Reentrancy",
        "reason": "The __callback function calls startRaffle, which performs external calls to transfer Ether. Although it checks the sender, it is still susceptible to reentrancy attacks. If an attacker could manipulate the state changes or call sequence, it could exploit the contract.",
        "file_name": "0x00195777bed7025e78819156281192c85fb3cf9b.sol"
    },
    {
        "function_name": "takeAll",
        "code": "function takeAll() public onlyOwner { msg.sender.transfer(address(this).balance); }",
        "vulnerability": "Improper Access Control",
        "reason": "The takeAll function allows the owner to transfer all Ether held in the contract to their address without any restrictions or considerations for ongoing transactions or obligations. This can be exploited by a malicious owner to drain the contract.",
        "file_name": "0x00195777bed7025e78819156281192c85fb3cf9b.sol"
    }
]