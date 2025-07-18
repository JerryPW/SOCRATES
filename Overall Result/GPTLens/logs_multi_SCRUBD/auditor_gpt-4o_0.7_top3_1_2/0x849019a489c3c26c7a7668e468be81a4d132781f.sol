[
    {
        "function_name": "RefundDeposit",
        "code": "function RefundDeposit(address _addr, uint _wei) public payable { if(Depositors[_addr]>0) { if(isAllowed()) { _addr.send(_wei); Available-=_wei; Withdrew(_addr,_wei); } } }",
        "vulnerability": "reentrancy",
        "reason": "The RefundDeposit function uses the send method to transfer Ether, which sends a limited amount of gas and does not check the success of the operation. However, this still opens up the possibility of a reentrancy attack if the recipient is a contract with a fallback function. The attacker could recursively call RefundDeposit and drain funds from the contract. Additionally, the function does not check if _wei is less than or equal to Depositors[_addr] or Available, potentially allowing larger withdrawals than allowed.",
        "file_name": "0x849019a489c3c26c7a7668e468be81a4d132781f.sol"
    },
    {
        "function_name": "initDeposit",
        "code": "function initDeposit() { Owner_O1 = msg.sender; }",
        "vulnerability": "lack of access control",
        "reason": "The initDeposit function can be called by anyone, allowing them to set themselves as Owner_O1. This lack of access control means any user can potentially assume the role of Owner_O1, which may have further permissions in other parts of the contract, leading to unauthorized access and modifications.",
        "file_name": "0x849019a489c3c26c7a7668e468be81a4d132781f.sol"
    },
    {
        "function_name": "SetTrustee",
        "code": "function SetTrustee(address addr) public { require((msg.sender == Owner_O2)||(msg.sender==Creator)); Owner_O2 = addr; }",
        "vulnerability": "improper access control",
        "reason": "The function SetTrustee allows the creator or the current Owner_O2 to change Owner_O2 to any address. If Owner_O2 is compromised or misused, it could transfer this control to a malicious address, leading to unauthorized access to functionality restricted to Owner_O2, such as potentially setting new trustees or funds.",
        "file_name": "0x849019a489c3c26c7a7668e468be81a4d132781f.sol"
    }
]