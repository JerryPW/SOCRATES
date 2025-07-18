[
    {
        "function_name": "withdraw",
        "code": "function withdraw() public{ require( (msg.sender == wallet1)||(msg.sender == wallet2) ); uint half = address(this).balance/2; wallet1.send(half); wallet2.send(half); }",
        "vulnerability": "Unchecked send result",
        "reason": "The withdraw function uses the send method to transfer Ether to wallet1 and wallet2, but it does not check the return value of send. If the send fails, the transaction does not revert, which may result in loss of funds or unexpected behavior. A malicious actor could exploit this by blocking the transfer to one of the wallets, potentially causing denial of service.",
        "file_name": "0xde7c2911cac44d5949cbe80b0c7d38f7a476cbad.sol"
    },
    {
        "function_name": "setWallet1",
        "code": "function setWallet1(address _wallet1) public { require(msg.sender == wallet1); require(newWallet1 == _wallet1); wallet1 = _wallet1; }",
        "vulnerability": "Unauthorized wallet change",
        "reason": "The setWallet1 function allows wallet1 to change its address without any restriction other than matching newWallet1. If an attacker gains control of wallet1, they can change it to any address they want, as long as it matches newWallet1, potentially redirecting Ether to the attacker's address.",
        "file_name": "0xde7c2911cac44d5949cbe80b0c7d38f7a476cbad.sol"
    },
    {
        "function_name": "setWallet2",
        "code": "function setWallet2(address _wallet2) public { require(msg.sender == wallet2); require(newWallet2 == _wallet2); wallet2 = _wallet2; }",
        "vulnerability": "Unauthorized wallet change",
        "reason": "Similar to setWallet1, the setWallet2 function allows wallet2 to change its address without any restriction other than matching newWallet2. If an attacker gains control of wallet2, they can change it to any address they desire, as long as it matches newWallet2, potentially redirecting Ether to the attacker's address.",
        "file_name": "0xde7c2911cac44d5949cbe80b0c7d38f7a476cbad.sol"
    }
]