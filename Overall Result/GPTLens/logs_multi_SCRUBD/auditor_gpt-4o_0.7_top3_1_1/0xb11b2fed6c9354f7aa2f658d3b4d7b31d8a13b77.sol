[
    {
        "function_name": "proxy",
        "code": "function proxy(address target, bytes data) public payable { target.call.value(msg.value)(data); }",
        "vulnerability": "Arbitrary code execution",
        "reason": "The proxy function uses target.call, which allows arbitrary code execution if the target address is controlled by an attacker. This can lead to unauthorized access and manipulation of the contract's state or funds.",
        "file_name": "0xb11b2fed6c9354f7aa2f658d3b4d7b31d8a13b77.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 amount) public onlyOwner { if (amount>0 && Deposits[msg.sender]>=amount) { msg.sender.transfer(amount); } }",
        "vulnerability": "Incorrect access control",
        "reason": "The withdraw function is supposed to allow only the owner to withdraw. However, it incorrectly checks Deposits[msg.sender], which should be Deposits[Owner]. This allows the owner to withdraw only their own deposits, not the deposits of others, potentially allowing other depositors to withdraw as well if the owner changes.",
        "file_name": "0xb11b2fed6c9354f7aa2f658d3b4d7b31d8a13b77.sol"
    },
    {
        "function_name": "Vault",
        "code": "function Vault() public payable { if (msg.sender == tx.origin) { Owner = msg.sender; deposit(); } }",
        "vulnerability": "Improper owner assignment",
        "reason": "The Vault function allows any externally owned account (EOA) to become the Owner by directly calling the Vault function, which sets the Owner to msg.sender. This can lead to unauthorized users gaining control over the contract, especially if they trigger this function before the intended owner.",
        "file_name": "0xb11b2fed6c9354f7aa2f658d3b4d7b31d8a13b77.sol"
    }
]