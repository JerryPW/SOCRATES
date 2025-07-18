[
    {
        "function_name": "setWallet1",
        "code": "function setWallet1(address _wallet1) public { require(msg.sender == wallet1); require(newWallet1 == _wallet1); wallet1 = _wallet1; }",
        "vulnerability": "Unauthorized Wallet Change",
        "reason": "The function `setWallet1` allows the current `wallet1` address to change itself to a new value if it matches `newWallet1`. However, `newWallet1` can be set by the owner without any restriction, which means the owner can effectively control `wallet1` without further checks. This bypasses any intended restriction on changing `wallet1` and can lead to unauthorized access if the owner is compromised or malicious.",
        "file_name": "0xde7c2911cac44d5949cbe80b0c7d38f7a476cbad.sol"
    },
    {
        "function_name": "setWallet2",
        "code": "function setWallet2(address _wallet2) public { require(msg.sender == wallet2); require(newWallet2 == _wallet2); wallet2 = _wallet2; }",
        "vulnerability": "Unauthorized Wallet Change",
        "reason": "Similar to `setWallet1`, the function `setWallet2` allows the current `wallet2` address to change itself to a new value if it matches `newWallet2`. The owner can set `newWallet2` to any arbitrary address, essentially allowing the owner to control `wallet2`. This poses a risk of unauthorized access if the owner's account is compromised or if the owner acts maliciously.",
        "file_name": "0xde7c2911cac44d5949cbe80b0c7d38f7a476cbad.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() public{ require( (msg.sender == wallet1)||(msg.sender == wallet2) ); uint half = address(this).balance/2; wallet1.send(half); wallet2.send(half); }",
        "vulnerability": "Unchecked Send Result",
        "reason": "The `withdraw` function uses the `.send()` method to transfer funds to `wallet1` and `wallet2` without checking the return value. If the send fails (e.g., if the receiving contract runs out of gas), the function does not revert, potentially causing a loss of funds. This vulnerability can be exploited by an attacker who can control either of the wallets to consume all gas, causing the send to fail and retain balance in the contract.",
        "file_name": "0xde7c2911cac44d5949cbe80b0c7d38f7a476cbad.sol"
    }
]