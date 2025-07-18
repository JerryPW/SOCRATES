[
    {
        "function_name": "setOwner",
        "code": "function setOwner(address newOwner) onlyGuardian public { if (msg.sender == guardian1) { if (newOwner == guardian2Vote || newOwner == guardian3Vote) { owner = newOwner; guardian1Vote = 0x0; guardian2Vote = 0x0; guardian3Vote = 0x0; } else { guardian1Vote = newOwner; } } else if (msg.sender == guardian2) { if (newOwner == guardian1Vote || newOwner == guardian3Vote) { owner = newOwner; guardian1Vote = 0x0; guardian2Vote = 0x0; guardian3Vote = 0x0; } else { guardian2Vote = newOwner; } } else if (msg.sender == guardian3) { if (newOwner == guardian1Vote || newOwner == guardian2Vote) { owner = newOwner; guardian1Vote = 0x0; guardian2Vote = 0x0; guardian3Vote = 0x0; } else { guardian3Vote = newOwner; } } }",
        "vulnerability": "Insecure ownership transfer",
        "reason": "The setOwner function allows any two guardians to collude and change the contract's owner, effectively bypassing the current owner's control. This can be exploited if any two out of the three guardians are compromised or act maliciously.",
        "file_name": "0xf2d54d17d3dc3810a0d62042a0b381df122ed162.sol"
    },
    {
        "function_name": "function() payable",
        "code": "function() payable isOpen public { uint etherAmount = msg.value; balanceOf[msg.sender] += etherAmount; uint beercoinAmount = (etherAmount * 10**uint(beercoin.decimals())) / price; beercoin.transfer(msg.sender, beercoinAmount); soldBeercoins += beercoinAmount; raisedEther += etherAmount; emit FundTransfer(msg.sender, etherAmount, true); }",
        "vulnerability": "Reentrancy vulnerability in fallback function",
        "reason": "The fallback function sends Beercoins to the sender before updating the state variables that track sold Beercoins and raised Ether. If the Beercoin contract's transfer function allows reentrancy, an attacker could repeatedly call the fallback function and drain the contract's Beercoins before the state is updated.",
        "file_name": "0xf2d54d17d3dc3810a0d62042a0b381df122ed162.sol"
    },
    {
        "function_name": "claimFunds",
        "code": "function claimFunds() onlyOwner goalReached public { uint etherAmount = address(this).balance; owner.transfer(etherAmount); emit FundTransfer(owner, etherAmount, false); }",
        "vulnerability": "Ether locked in contract",
        "reason": "The claimFunds function transfers all Ether from the contract's balance to the owner if the goal is reached. However, if the contract receives additional Ether after the goal is reached, this additional Ether would be locked in the contract indefinitely, as the function does not allow partial withdrawals.",
        "file_name": "0xf2d54d17d3dc3810a0d62042a0b381df122ed162.sol"
    }
]