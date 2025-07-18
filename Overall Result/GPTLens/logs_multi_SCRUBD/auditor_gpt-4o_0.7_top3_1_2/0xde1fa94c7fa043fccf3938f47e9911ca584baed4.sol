[
    {
        "function_name": "function()",
        "code": "function() external payable { owner.send(msg.value / 10); if (balances[msg.sender] != 0){ address kashout = msg.sender; uint256 getout = balances[msg.sender]*5/100*(block.number-timestamp[msg.sender])/5900; kashout.send(getout); } timestamp[msg.sender] = block.number; balances[msg.sender] += msg.value; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function sends ether to the msg.sender through kashout.send(getout) without updating the state variables (balances and timestamp) before the send call. This allows an attacker to re-enter the contract by calling the fallback function recursively, potentially draining funds.",
        "file_name": "0xde1fa94c7fa043fccf3938f47e9911ca584baed4.sol"
    },
    {
        "function_name": "function()",
        "code": "function() external payable { owner.send(msg.value / 10); if (balances[msg.sender] != 0){ address kashout = msg.sender; uint256 getout = balances[msg.sender]*5/100*(block.number-timestamp[msg.sender])/5900; kashout.send(getout); } timestamp[msg.sender] = block.number; balances[msg.sender] += msg.value; }",
        "vulnerability": "Use of block number for time calculations",
        "reason": "The calculation of the amount to be sent to the user (getout) relies on the block.number as a substitute for time. Block times can vary and be manipulated by miners to some extent, leading to inconsistent or unfair reward calculations.",
        "file_name": "0xde1fa94c7fa043fccf3938f47e9911ca584baed4.sol"
    },
    {
        "function_name": "function()",
        "code": "function() external payable { owner.send(msg.value / 10); if (balances[msg.sender] != 0){ address kashout = msg.sender; uint256 getout = balances[msg.sender]*5/100*(block.number-timestamp[msg.sender])/5900; kashout.send(getout); } timestamp[msg.sender] = block.number; balances[msg.sender] += msg.value; }",
        "vulnerability": "Unsafe use of send",
        "reason": "The send function is used for transferring ether in both owner.send and kashout.send. If the send fails, it does not throw an exception and the transaction continues, potentially leading to a loss of funds or inconsistent state.",
        "file_name": "0xde1fa94c7fa043fccf3938f47e9911ca584baed4.sol"
    }
]