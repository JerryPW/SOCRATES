[
    {
        "function_name": "unlockSecret",
        "code": "function unlockSecret() private returns(bool){ bytes32 hash = keccak256(blockhash(block.number-1)); uint256 secret = uint256(hash); str(secret); if(secret%5==0){ winner = msg.sender; return true; } else{ return false; } }",
        "vulnerability": "Predictable secret determination",
        "reason": "The function relies on blockhash(block.number-1) to generate a secret. However, block hashes can be predicted by miners and hence, an attacker can manipulate the block hash to become the winner by ensuring the secret % 5 equals 0. This allows them to exploit the contract to designate themselves as the winner.",
        "file_name": "0x352dbba201af66f98a47f2b280bff45f9050dbf8.sol"
    },
    {
        "function_name": "claimPrize",
        "code": "function claimPrize() public payable onlyWinner { winner.transfer(address(this).balance); }",
        "vulnerability": "Improper winner authorization",
        "reason": "Once an attacker is designated as the winner using the predictable secret vulnerability, they can call the claimPrize function to transfer the entire balance of the contract to themselves. This is due to the lack of robust checks to ensure that the winner designation was done in a fair and secure manner.",
        "file_name": "0x352dbba201af66f98a47f2b280bff45f9050dbf8.sol"
    },
    {
        "function_name": "setSeed",
        "code": "function setSeed (uint256 _index, uint256 _value) public payable onlyPlayers { seed[_index] = _value; }",
        "vulnerability": "Seed manipulation",
        "reason": "The function allows any player to change the values in the seed array. This could be exploited to manipulate the seed values used in the guessSeed function, potentially allowing a player to become the owner if their manipulated seed divides the guessed seed to match the secret, compromising contract integrity.",
        "file_name": "0x352dbba201af66f98a47f2b280bff45f9050dbf8.sol"
    }
]