[
    {
        "function_name": "withdraw",
        "code": "function withdraw() public{ require( (msg.sender == wallet1)||(msg.sender == wallet2) ); uint half = address(this).balance/2; wallet1.send(half); wallet2.send(half); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The withdraw function sends Ether to external wallets using the send method without proper reentrancy protection. An attacker could potentially re-enter the contract in the middle of the transaction and drain funds by calling withdraw repeatedly before the first transaction is completed.",
        "file_name": "0xde7c2911cac44d5949cbe80b0c7d38f7a476cbad.sol"
    },
    {
        "function_name": "setWallet1",
        "code": "function setWallet1(address _wallet1) public { require(msg.sender == wallet1); require(newWallet1 == _wallet1); wallet1 = _wallet1; }",
        "vulnerability": "Improper wallet update logic",
        "reason": "The function allows the current wallet1 to change its address to newWallet1 without the owner\u2019s approval. This can lead to a situation where an attacker, who compromises the wallet1, can set it to any address as long as they set newWallet1 to the same address beforehand, effectively hijacking control.",
        "file_name": "0xde7c2911cac44d5949cbe80b0c7d38f7a476cbad.sol"
    },
    {
        "function_name": "setWallet2",
        "code": "function setWallet2(address _wallet2) public { require(msg.sender == wallet2); require(newWallet2 == _wallet2); wallet2 = _wallet2; }",
        "vulnerability": "Improper wallet update logic",
        "reason": "Similar to setWallet1, this function allows the current wallet2 to change its address to newWallet2 without the owner's consent. An attacker, who gains access to wallet2, can change the address to any desired address by setting newWallet2 to the same address first, thus taking control.",
        "file_name": "0xde7c2911cac44d5949cbe80b0c7d38f7a476cbad.sol"
    }
]