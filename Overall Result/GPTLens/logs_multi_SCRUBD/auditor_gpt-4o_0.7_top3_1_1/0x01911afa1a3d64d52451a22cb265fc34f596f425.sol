[
    {
        "function_name": "buy",
        "code": "function buy() payable public returns(bool) { require(msg.value >= minQty.mul(price), \"The Value sent is insuffient for min quantity in one order\"); uint256 _amount = msg.value.div(price); voteCoinContract.transfer(msg.sender, _amount); emit Buy(msg.sender, _amount, msg.value); return true; }",
        "vulnerability": "ERC20 return value not checked",
        "reason": "The function 'buy' calls 'voteCoinContract.transfer' but does not check if the transfer was successful. If the token contract returns false, the function will proceed as if the transfer was successful, which could lead to inconsistencies and potential loss of funds.",
        "file_name": "0x01911afa1a3d64d52451a22cb265fc34f596f425.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _amount) public onlyOwner returns(bool) { require(address(this).balance > _amount, 'Insufficient balance'); msg.sender.transfer(_amount); }",
        "vulnerability": "Incorrect balance check",
        "reason": "The function 'withdraw' checks if the contract balance is greater than '_amount', but it should check if the balance is greater than or equal to '_amount'. This can cause the function to fail even if the exact amount is available, preventing the owner from withdrawing funds.",
        "file_name": "0x01911afa1a3d64d52451a22cb265fc34f596f425.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function () payable external {}",
        "vulnerability": "Unrestricted Ether reception",
        "reason": "The fallback function allows the contract to receive Ether from any address without any restrictions or logging. This could lead to confusion about who sent funds to the contract and why, and may result in unintentional locking of funds in the contract.",
        "file_name": "0x01911afa1a3d64d52451a22cb265fc34f596f425.sol"
    }
]