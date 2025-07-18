[
    {
        "function_name": "proxy",
        "code": "function proxy(address target, bytes data) public payable { target.call.value(msg.value)(data); }",
        "vulnerability": "Arbitrary call vulnerability",
        "reason": "The proxy function allows any user to make arbitrary calls to any target contract with any data. This means an attacker can potentially execute any function on any contract, even if they do not have permission to do so in a normal context. This could be used to exploit vulnerabilities in other contracts or perform unauthorized actions.",
        "file_name": "0xb11b2fed6c9354f7aa2f658d3b4d7b31d8a13b77.sol"
    },
    {
        "function_name": "Vault",
        "code": "function Vault() public payable { if (msg.sender == tx.origin) { Owner = msg.sender; deposit(); } }",
        "vulnerability": "Unauthorized owner change",
        "reason": "The Vault function can be called by any externally owned account, allowing any user to set themselves as the Owner of the DepositProxy contract. This effectively gives them full control over the contract, including the ability to withdraw all deposited funds.",
        "file_name": "0xb11b2fed6c9354f7aa2f658d3b4d7b31d8a13b77.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 amount) public onlyOwner { if (amount>0 && Deposits[msg.sender]>=amount) { msg.sender.transfer(amount); } }",
        "vulnerability": "Incorrect ownership check",
        "reason": "The withdraw function checks msg.sender against the Deposits mapping for the amount, but the onlyOwner modifier is using a different Owner variable from the Proxy contract. This allows the attacker to become the owner using the Vault function and withdraw others' deposits without restriction.",
        "file_name": "0xb11b2fed6c9354f7aa2f658d3b4d7b31d8a13b77.sol"
    }
]