[
    {
        "function_name": "setWallet1",
        "code": "function setWallet1(address _wallet1) public { require(msg.sender == wallet1); require(newWallet1 == _wallet1); wallet1 = _wallet1; }",
        "vulnerability": "Unauthorized wallet replacement",
        "reason": "The setWallet1 function allows anyone who is the current wallet1 to change wallet1 to any address as long as it matches newWallet1. However, since there is no initial mechanism to securely set newWallet1, an attacker who gains control over wallet1 can set newWallet1 to their own address and then call setWallet1 to finalize the change, effectively taking control over wallet1.",
        "file_name": "0xde7c2911cac44d5949cbe80b0c7d38f7a476cbad.sol"
    },
    {
        "function_name": "setWallet2",
        "code": "function setWallet2(address _wallet2) public { require(msg.sender == wallet2); require(newWallet2 == _wallet2); wallet2 = _wallet2; }",
        "vulnerability": "Unauthorized wallet replacement",
        "reason": "Similar to setWallet1, the setWallet2 function suffers from the same issue. An attacker who gains control over wallet2 can set newWallet2 to their address and then call setWallet2 to finalize the change, taking control over wallet2. Without a secure initialization of newWallet2 or additional verification, this function can be exploited.",
        "file_name": "0xde7c2911cac44d5949cbe80b0c7d38f7a476cbad.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() public{ require( (msg.sender == wallet1)||(msg.sender == wallet2) ); uint half = address(this).balance/2; wallet1.send(half); wallet2.send(half); }",
        "vulnerability": "Denial of service via send failure",
        "reason": "The withdraw function uses the send method to transfer ether, which returns false on failure but does not revert the transaction. If either wallet1 or wallet2 is a contract that does not implement a payable fallback function, the send will fail, and the ether will remain locked in the contract, causing a denial of service. Additionally, if send fails for either wallet, it does not revert the entire transaction, leading to inconsistent states where one wallet might receive funds while the other does not.",
        "file_name": "0xde7c2911cac44d5949cbe80b0c7d38f7a476cbad.sol"
    }
]