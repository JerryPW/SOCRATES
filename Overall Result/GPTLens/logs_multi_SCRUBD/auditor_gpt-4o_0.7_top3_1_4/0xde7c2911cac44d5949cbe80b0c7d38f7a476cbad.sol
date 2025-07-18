[
    {
        "function_name": "withdraw",
        "code": "function withdraw() public { require( (msg.sender == wallet1)||(msg.sender == wallet2) ); uint half = address(this).balance/2; wallet1.send(half); wallet2.send(half); }",
        "vulnerability": "Potential reentrancy attack",
        "reason": "The withdraw function uses the send method to transfer Ether, which only forwards 2300 gas and does not prevent reentrancy. However, the main issue is that the contract does not update the balance before sending, allowing a potential reentrancy attack if wallet1 or wallet2 are contracts that can reenter the withdraw function.",
        "file_name": "0xde7c2911cac44d5949cbe80b0c7d38f7a476cbad.sol"
    },
    {
        "function_name": "setWallet1",
        "code": "function setWallet1(address _wallet1) public { require(msg.sender == wallet1); require(newWallet1 == _wallet1); wallet1 = _wallet1; }",
        "vulnerability": "Improper authorization",
        "reason": "The setWallet1 function allows wallet1 to change itself without any owner intervention. If wallet1 is compromised, an attacker can set a different address as wallet1 without owner authorization, effectively locking the legitimate user out.",
        "file_name": "0xde7c2911cac44d5949cbe80b0c7d38f7a476cbad.sol"
    },
    {
        "function_name": "setWallet2",
        "code": "function setWallet2(address _wallet2) public { require(msg.sender == wallet2); require(newWallet2 == _wallet2); wallet2 = _wallet2; }",
        "vulnerability": "Improper authorization",
        "reason": "Similar to setWallet1, the setWallet2 function allows wallet2 to change itself without any owner intervention. If wallet2 is compromised, an attacker can set a different address as wallet2 without owner authorization, effectively locking the legitimate user out.",
        "file_name": "0xde7c2911cac44d5949cbe80b0c7d38f7a476cbad.sol"
    }
]