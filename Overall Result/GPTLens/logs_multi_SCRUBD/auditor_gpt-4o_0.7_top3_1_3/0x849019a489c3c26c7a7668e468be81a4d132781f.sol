[
    {
        "function_name": "RefundDeposit",
        "code": "function RefundDeposit(address _addr, uint _wei) public payable { if(Depositors[_addr]>0) { if(isAllowed()) { _addr.send(_wei); Available-=_wei; Withdrew(_addr,_wei); } } }",
        "vulnerability": "Unsafe use of 'send' method",
        "reason": "The 'send' method is used to transfer Ether to an address. It only forwards a limited amount of gas and does not revert if the call fails, which can lead to a situation where the Ether is not transferred but the contract logic continues as if it were. This can lead to fund loss or incorrect accounting. Additionally, the function does not check if '_wei' exceeds the balance of '_addr', which can result in more Ether being sent than the depositor has.",
        "file_name": "0x849019a489c3c26c7a7668e468be81a4d132781f.sol"
    },
    {
        "function_name": "SetTrustee",
        "code": "function SetTrustee(address addr) public { require((msg.sender == Owner_O2)||(msg.sender==Creator)); Owner_O2 = addr; }",
        "vulnerability": "Improper access control",
        "reason": "The 'SetTrustee' function allows the change of a crucial contract role \u2013 Owner_O2. Improper access control could allow unauthorized parties to change the trustee, granting them undue permissions such as transferring funds. If 'Owner_O2' is compromised, an attacker could exploit this function to gain control over significant contract functions.",
        "file_name": "0x849019a489c3c26c7a7668e468be81a4d132781f.sol"
    },
    {
        "function_name": "SetFund",
        "code": "function SetFund(address addr) public { require((msg.sender == Owner_O2)||(msg.sender==Creator)); Owner_O3 = addr; }",
        "vulnerability": "Improper access control",
        "reason": "Similar to 'SetTrustee', 'SetFund' allows changing of a critical role \u2013 Owner_O3, which is involved in access control for fund withdrawals. If 'Owner_O2' is compromised, an attacker could exploit this to assign themselves or an accomplice as Owner_O3, enabling unauthorized control over withdrawals and potentially leading to fund theft.",
        "file_name": "0x849019a489c3c26c7a7668e468be81a4d132781f.sol"
    }
]