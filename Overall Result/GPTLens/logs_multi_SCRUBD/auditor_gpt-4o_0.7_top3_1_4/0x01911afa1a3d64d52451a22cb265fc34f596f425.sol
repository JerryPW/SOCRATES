[
    {
        "function_name": "buy",
        "code": "function buy() payable public returns(bool) { require(msg.value >= minQty.mul(price), \"The Value sent is insuffient for min quantity in one order\"); uint256 _amount = msg.value.div(price); voteCoinContract.transfer(msg.sender, _amount); emit Buy(msg.sender, _amount, msg.value); return true; }",
        "vulnerability": "Missing return value check of ERC20 transfer",
        "reason": "The function `buy` calls `voteCoinContract.transfer(msg.sender, _amount)` without checking the return value. This can lead to a situation where the transfer fails, but the function proceeds as if it was successful. This can be exploited if the token contract returns false on transfer failure without reverting. An attacker could potentially send Ether without receiving tokens if the transfer fails.",
        "file_name": "0x01911afa1a3d64d52451a22cb265fc34f596f425.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _amount) public onlyOwner returns(bool) { require(address(this).balance > _amount, 'Insufficient balance'); msg.sender.transfer(_amount); }",
        "vulnerability": "Improper balance check",
        "reason": "The function `withdraw` checks if the contract balance is greater than the `_amount`, which should be `>=`, not `>`. An attacker could exploit this by attempting to withdraw the entire balance minus 1 wei. This allows an attacker to potentially lock funds within the contract.",
        "file_name": "0x01911afa1a3d64d52451a22cb265fc34f596f425.sol"
    },
    {
        "function_name": "voteCoinAddress",
        "code": "address public voteCoinAddress = 0xebBA921554901aBc495Bf4C9f5E8F1C1c98078d9; IERC20 voteCoinContract = IERC20(voteCoinAddress);",
        "vulnerability": "Hardcoded token contract address",
        "reason": "The `voteCoinAddress` is hardcoded and not modifiable. If the token contract is upgraded or moved, the current contract would still point to the old address, causing potential loss of funds or inability to interact with the updated token contract. This can be exploited by deploying a malicious contract at the address before the original is deployed, causing all interactions to be redirected to the attacker.",
        "file_name": "0x01911afa1a3d64d52451a22cb265fc34f596f425.sol"
    }
]