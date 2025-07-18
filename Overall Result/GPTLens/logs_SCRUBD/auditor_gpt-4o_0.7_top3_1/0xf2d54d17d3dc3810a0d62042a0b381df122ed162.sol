[
    {
        "function_name": "setOwner",
        "code": "function setOwner(address newOwner) onlyGuardian public { if (msg.sender == guardian1) { if (newOwner == guardian2Vote || newOwner == guardian3Vote) { owner = newOwner; guardian1Vote = 0x0; guardian2Vote = 0x0; guardian3Vote = 0x0; } else { guardian1Vote = newOwner; } } else if (msg.sender == guardian2) { if (newOwner == guardian1Vote || newOwner == guardian3Vote) { owner = newOwner; guardian1Vote = 0x0; guardian2Vote = 0x0; guardian3Vote = 0x0; } else { guardian2Vote = newOwner; } } else if (msg.sender == guardian3) { if (newOwner == guardian1Vote || newOwner == guardian2Vote) { owner = newOwner; guardian1Vote = 0x0; guardian2Vote = 0x0; guardian3Vote = 0x0; } else { guardian3Vote = newOwner; } } }",
        "vulnerability": "Owner change vulnerability",
        "reason": "The setOwner function allows any guardian to set a new owner if two guardians agree. However, the voting system can be easily manipulated; one guardian can repeatedly set and reset their vote to manipulate the voting state, achieving consensus without the actual agreement of all parties involved.",
        "file_name": "0xf2d54d17d3dc3810a0d62042a0b381df122ed162.sol"
    },
    {
        "function_name": "function() payable",
        "code": "function() payable isOpen public { uint etherAmount = msg.value; balanceOf[msg.sender] += etherAmount; uint beercoinAmount = (etherAmount * 10**uint(beercoin.decimals())) / price; beercoin.transfer(msg.sender, beercoinAmount); soldBeercoins += beercoinAmount; raisedEther += etherAmount; emit FundTransfer(msg.sender, etherAmount, true); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function transfers Beercoin tokens to the sender before updating the state variables (soldBeercoins and raisedEther). This could potentially be exploited using a reentrancy attack, where an attacker could recursively call the fallback function to drain the contract's Beercoin balance.",
        "file_name": "0xf2d54d17d3dc3810a0d62042a0b381df122ed162.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() goalNotReached public { uint amount = balanceOf[msg.sender]; require(amount > 0); balanceOf[msg.sender] = 0; msg.sender.transfer(amount); emit FundTransfer(msg.sender, amount, false); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The withdraw function updates the balanceOf mapping after transferring Ether. This order of operations makes the contract vulnerable to reentrancy attacks, where an attacker could repeatedly call withdraw to extract more funds than they are entitled to before their balance is set to zero.",
        "file_name": "0xf2d54d17d3dc3810a0d62042a0b381df122ed162.sol"
    }
]