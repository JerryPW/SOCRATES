[
    {
        "function_name": "withdraw",
        "code": "function withdraw() onlyOwner returns (bool result) { owner.send(this.balance); return true; }",
        "vulnerability": "Unchecked send call",
        "reason": "The use of 'send' does not check for the success of the Ether transfer, which can lead to loss of Ether if the transfer fails. This is problematic because 'send' only forwards 2300 gas, which may be insufficient if the owner is a contract with a complex fallback function.",
        "file_name": "0x5d268508179db4da44de9057792758bff280e3ed.sol"
    },
    {
        "function_name": "CentraWhiteList",
        "code": "function CentraWhiteList() { owner = msg.sender; operation = 0; }",
        "vulnerability": "Lack of proper access control",
        "reason": "The constructor sets the contract deployer as the owner. However, there is no mechanism to change the owner, which means if the private key of the deploying address is compromised, control over the contract is irretrievably lost.",
        "file_name": "0x5d268508179db4da44de9057792758bff280e3ed.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function() payable { if(!(msg.value > 0)) throw; operation_address[operation] = msg.sender; operation_amount[operation] = msg.value; operation = operation.add(1); }",
        "vulnerability": "Potential DoS with block gas limit",
        "reason": "The fallback function increments the 'operation' state variable on every transaction, which could eventually lead to a point where it becomes too costly to process due to block gas limit constraints as 'operation' grows, resulting in a denial of service for further interactions.",
        "file_name": "0x5d268508179db4da44de9057792758bff280e3ed.sol"
    }
]