[
    {
        "function_name": "proxy",
        "code": "function proxy(address target, bytes data) public payable { target.call.value(msg.value)(data); }",
        "vulnerability": "Unrestricted External Call",
        "reason": "The 'proxy' function allows anyone to call any function on any target address with any data, including sending ether. This makes the contract susceptible to reentrancy attacks, unauthorized contract interaction, and loss of funds.",
        "file_name": "0xb11b2fed6c9354f7aa2f658d3b4d7b31d8a13b77.sol"
    },
    {
        "function_name": "Vault",
        "code": "function Vault() public payable { if (msg.sender == tx.origin) { Owner = msg.sender; deposit(); } }",
        "vulnerability": "Ownership Takeover",
        "reason": "The 'Vault' function allows anyone to become the Owner if they call it directly (not through a contract) and send more than 0.5 ether. This allows any user to take control of the contract by calling this function, bypassing the original ownership checks.",
        "file_name": "0xb11b2fed6c9354f7aa2f658d3b4d7b31d8a13b77.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 amount) public onlyOwner { if (amount>0 && Deposits[msg.sender]>=amount) { msg.sender.transfer(amount); } }",
        "vulnerability": "Incorrect Access Control",
        "reason": "The 'withdraw' function uses 'onlyOwner' modifier but checks Deposits[msg.sender] for withdrawal amount, which means only the contract owner can withdraw their own deposits. However, if ownership is taken over, the new owner can withdraw the previous owner's deposits.",
        "file_name": "0xb11b2fed6c9354f7aa2f658d3b4d7b31d8a13b77.sol"
    }
]