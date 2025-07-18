[
    {
        "function_name": "checkBalanceSendEth",
        "code": "function checkBalanceSendEth(address _recipient) public { require(creator == msg.sender, \"unauthorized\"); checkBalance(_recipient); _recipient.transfer(1); checkBalance(_recipient); _recipient.send(1); checkBalance(_recipient); logBlockDetails(); logGasDetails(); logGasDetails(); logSenderDetails(); }",
        "vulnerability": "reentrancy_attack",
        "reason": "The function uses both transfer and send to transfer ether to the _recipient. If the _recipient is a contract, it can exploit reentrancy by calling checkBalanceSendEth again in its fallback function. This could allow the contract to drain funds as the balance check is done before the transfers.",
        "file_name": "0x0dd1326b7b80107f002ba16dad7fe2dd22f00491.sol"
    },
    {
        "function_name": "constructor",
        "code": "constructor(address _proxy) public { creator = msg.sender; creatorproxy = _proxy; }",
        "vulnerability": "unprotected_function_access",
        "reason": "The contract allows the creator to be set at deployment time but does not provide any mechanism to change it later or verify the validity of the creatorproxy. If the proxy address is malicious, it could potentially execute unauthorized actions on behalf of the creator.",
        "file_name": "0x0dd1326b7b80107f002ba16dad7fe2dd22f00491.sol"
    },
    {
        "function_name": "verifyBlockHash",
        "code": "function verifyBlockHash(string memory _hash, uint _blockNumber) public returns (bytes32, bytes32) { bytes32 hash1 = keccak256(_hash); bytes32 hash2 = getBlockHash(_blockNumber); return(hash1, hash2) ; }",
        "vulnerability": "incorrect_blockhash_usage",
        "reason": "The function uses block.blockhash to retrieve the hash of a given block number. However, blockhash only works for the most recent 256 blocks, making this unreliable for older blocks. This could lead to incorrect assumptions about the block data being verified.",
        "file_name": "0x0dd1326b7b80107f002ba16dad7fe2dd22f00491.sol"
    }
]