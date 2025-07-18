[
    {
        "function_name": "RefundDeposit",
        "code": "function RefundDeposit(address _addr, uint _wei) public payable { if(Depositors[_addr]>0) { if(isAllowed()) { _addr.send(_wei); Available-=_wei; Withdrew(_addr,_wei); } } }",
        "vulnerability": "Use of send() function",
        "reason": "The use of the send() function in the RefundDeposit function is a severe vulnerability because it only forwards 2300 gas, which might not be enough to cover the execution of the fallback function of the recipient. This can lead to a failure in refunding funds to the depositor, potentially locking their funds in the contract. Moreover, the send() function does not propagate errors, which can make it difficult to handle any issues that arise, leading to potential loss of funds.",
        "file_name": "0x849019a489c3c26c7a7668e468be81a4d132781f.sol"
    },
    {
        "function_name": "Sunset",
        "code": "function Sunset() public payable { if(msg.sender==Creator) { suicide(Creator); } }",
        "vulnerability": "Use of suicide() function",
        "reason": "The Sunset function uses the suicide function, which is now known as selfdestruct in newer Solidity versions. This function deletes the contract from the blockchain and sends all remaining ether to the Creator. This can be exploited by the Creator to unilaterally destroy the contract and withdraw all funds, potentially leaving other stakeholders at a loss. There are no checks or balances in place to prevent misuse, making it a severe vulnerability.",
        "file_name": "0x849019a489c3c26c7a7668e468be81a4d132781f.sol"
    },
    {
        "function_name": "SetPrcntRate",
        "code": "function SetPrcntRate(uint val) public { if(val>=1&&msg.sender==Creator) { prcntRate = val; } }",
        "vulnerability": "Lack of upper limit on prcntRate",
        "reason": "The SetPrcntRate function allows the Creator to set the prcntRate to any value greater than or equal to 1, with no upper limit. This could lead to situations where the interest rate is set to an unreasonably high number, causing the contract to potentially face financial distress or become insolvent if it cannot cover the promised rates. This lack of constraint can be exploited by the Creator to manipulate the contract in a way that could jeopardize its financial stability.",
        "file_name": "0x849019a489c3c26c7a7668e468be81a4d132781f.sol"
    }
]