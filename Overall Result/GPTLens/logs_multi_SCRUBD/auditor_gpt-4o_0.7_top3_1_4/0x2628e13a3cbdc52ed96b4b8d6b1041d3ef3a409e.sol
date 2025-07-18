[
    {
        "function_name": "addParticipant",
        "code": "function addParticipant(address _address, address _referrer) payable public { require(participants[_address] == address(0), \"This participant is already registered\"); require(msg.value >= 0.45 ether && msg.value <= 225 ether, \"Deposit should be between 0.45 ether and 225 ether (45 days)\"); participants[_address] = address(new Participant(_address, msg.value / 45)); processPayment(_address); processing.send(msg.value / 20); if (_referrer != address(0) && referrers[_referrer]) { _referrer.send(msg.value / 20); } emit ParticipantAdded(_address); }",
        "vulnerability": "Unsafe use of send() for Ether transfer",
        "reason": "The function uses .send() to transfer Ether, which forwards only 2300 gas and does not propagate exceptions. This can result in Ether being lost if the recipient is a contract with a fallback function that requires more than 2300 gas to execute or if the recipient rejects the transaction.",
        "file_name": "0x2628e13a3cbdc52ed96b4b8d6b1041d3ef3a409e.sol"
    },
    {
        "function_name": "processPayment",
        "code": "function processPayment(address _address) public { Participant participant = Participant(participants[_address]); bool done = participant.processPayment.value(participant.daily())(); if (done) { participants[_address] = address(0); emit ParticipantRemoved(_address); } }",
        "vulnerability": "External call to untrusted contract",
        "reason": "The function calls an external contract's processPayment function and sends Ether in the process. This allows for reentrancy attacks where the external contract can call back into the vulnerable function before the execution is complete, potentially leading to unexpected behavior or financial loss.",
        "file_name": "0x2628e13a3cbdc52ed96b4b8d6b1041d3ef3a409e.sol"
    },
    {
        "function_name": "addReferrer",
        "code": "function addReferrer(address _address) public { require(!referrers[_address], \"This address is already a referrer\"); referrers[_address] = true; EasySmartolutionRef refContract = new EasySmartolutionRef(address(this)); refContract.setReferrer(_address); emit ReferrerAdded(address(refContract), _address); }",
        "vulnerability": "Unrestricted referrer addition",
        "reason": "The function allows any address to be added as a referrer without any validation or constraints, enabling potential abuse by attackers who can spam the contract with referrer entries, leading to storage bloat and increased gas costs.",
        "file_name": "0x2628e13a3cbdc52ed96b4b8d6b1041d3ef3a409e.sol"
    }
]