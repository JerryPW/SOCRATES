[
    {
        "function_name": "buy",
        "code": "function buy() payable public returns(bool) { require(msg.value >= minQty.mul(price), \"The Value sent is insuffient for min quantity in one order\"); uint256 _amount = msg.value.div(price); voteCoinContract.transfer(msg.sender, _amount); emit Buy(msg.sender, _amount, msg.value); return true; }",
        "vulnerability": "ERC20 Transfer Return Value Not Checked",
        "reason": "The transfer function of the ERC20 token does not have its return value checked. If the transfer fails, the function will not detect it, potentially leading to a loss of funds for users who believe they have successfully purchased tokens.",
        "file_name": "0x01911afa1a3d64d52451a22cb265fc34f596f425.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _amount) public onlyOwner returns(bool) { require(address(this).balance > _amount, 'Insufficient balance'); msg.sender.transfer(_amount); }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The withdraw function allows the owner to transfer ether. If the owner is a contract, it might have a fallback function that could call back into the contract before the withdrawal is completed, potentially leading to a reentrancy attack.",
        "file_name": "0x01911afa1a3d64d52451a22cb265fc34f596f425.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _amount) public onlyOwner returns(bool) { require(address(this).balance > _amount, 'Insufficient balance'); msg.sender.transfer(_amount); }",
        "vulnerability": "Improper Balance Check",
        "reason": "The require statement checks if the contract balance is greater than the withdrawal amount instead of checking if it is greater than or equal. This can cause unnecessary failures when attempting to withdraw the entire balance.",
        "file_name": "0x01911afa1a3d64d52451a22cb265fc34f596f425.sol"
    }
]