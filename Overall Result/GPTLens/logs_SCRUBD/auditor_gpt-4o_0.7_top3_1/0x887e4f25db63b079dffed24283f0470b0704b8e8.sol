[
    {
        "function_name": "Sort",
        "code": "function Sort() internal { uint feecounter; feecounter=msg.value/5; owner.send(feecounter); feecounter=0; uint txcounter=Tx.length; counter=Tx.length; Tx.length++; Tx[txcounter].txuser=msg.sender; Tx[txcounter].txvalue=msg.value; }",
        "vulnerability": "Unsafe usage of send",
        "reason": "The use of 'send' to transfer ether is unsafe as it does not throw an error on failure, which can lead to ether being locked in the contract. If 'send' fails, the transaction continues without reverting, potentially leaving the contract in an inconsistent state.",
        "file_name": "0x887e4f25db63b079dffed24283f0470b0704b8e8.sol"
    },
    {
        "function_name": "Count",
        "code": "function Count(uint end, uint start) public onlyowner { while (end>start) { Tx[end].txuser.send((Tx[end].txvalue/1000)*200); end-=1; } }",
        "vulnerability": "Unsafe iteration over dynamic array",
        "reason": "Iterating over a dynamic array with a while loop where end is controlled by the owner can lead to an out-of-gas error if 'end' is large. This can be exploited to block the execution of the function, causing denial of service.",
        "file_name": "0x887e4f25db63b079dffed24283f0470b0704b8e8.sol"
    },
    {
        "function_name": "Count",
        "code": "function Count(uint end, uint start) public onlyowner { while (end>start) { Tx[end].txuser.send((Tx[end].txvalue/1000)*200); end-=1; } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The 'send' function is used within a loop without any reentrancy guard. If a malicious contract is one of the recipients, it can re-enter the contract and potentially manipulate the state or exhaust the gas limit, leading to unexpected behavior.",
        "file_name": "0x887e4f25db63b079dffed24283f0470b0704b8e8.sol"
    }
]