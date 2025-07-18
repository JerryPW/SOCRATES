[
    {
        "function_name": "function()",
        "code": "function() external payable { owner.send(msg.value / 10); if (balances[msg.sender] != 0){ address kashout = msg.sender; uint256 getout = balances[msg.sender]*5/100*(block.number-timestamp[msg.sender])/5900; kashout.send(getout); } timestamp[msg.sender] = block.number; balances[msg.sender] += msg.value; }",
        "vulnerability": "Use of block.number for time",
        "reason": "The contract uses `block.number` to calculate time intervals, which is unreliable because block numbers can vary in time between different blockchains or under different conditions. This can be exploited by miners to manipulate the block number to their advantage, potentially altering the payout calculations.",
        "file_name": "0xde1fa94c7fa043fccf3938f47e9911ca584baed4.sol"
    },
    {
        "function_name": "function()",
        "code": "function() external payable { owner.send(msg.value / 10); if (balances[msg.sender] != 0){ address kashout = msg.sender; uint256 getout = balances[msg.sender]*5/100*(block.number-timestamp[msg.sender])/5900; kashout.send(getout); } timestamp[msg.sender] = block.number; balances[msg.sender] += msg.value; }",
        "vulnerability": "Reentrancy",
        "reason": "The fallback function does not use any protection against reentrancy attacks. An attacker can exploit this by recursively calling the fallback function before the balance is updated, allowing them to drain funds from the contract. This is especially risky with the use of `send`, which only forwards 2300 gas, making it harder to perform reentrant calls, but not impossible with fallback functions.",
        "file_name": "0xde1fa94c7fa043fccf3938f47e9911ca584baed4.sol"
    },
    {
        "function_name": "function()",
        "code": "function() external payable { owner.send(msg.value / 10); if (balances[msg.sender] != 0){ address kashout = msg.sender; uint256 getout = balances[msg.sender]*5/100*(block.number-timestamp[msg.sender])/5900; kashout.send(getout); } timestamp[msg.sender] = block.number; balances[msg.sender] += msg.value; }",
        "vulnerability": "Use of send without checking return value",
        "reason": "The contract uses the `send` function to transfer ether, but it does not check the return value to verify that the transfer was successful. If the `send` operation fails (e.g., due to exceeding gas limit or a receiver contract rejecting the transfer), the contract does not handle this failure and will proceed as if the transfer was successful, potentially leading to incorrect state updates or loss of funds.",
        "file_name": "0xde1fa94c7fa043fccf3938f47e9911ca584baed4.sol"
    }
]