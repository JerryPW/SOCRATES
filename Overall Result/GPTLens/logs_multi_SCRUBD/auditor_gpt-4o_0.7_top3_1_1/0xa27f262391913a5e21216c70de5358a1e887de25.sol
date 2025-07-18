[
    {
        "function_name": "setPeriod",
        "code": "function setPeriod(uint i, uint v) public { periods[i] = v; }",
        "vulnerability": "Arbitrary Period Modification",
        "reason": "The function setPeriod allows any user to modify the periods array arbitrarily. This can lead to incorrect setting of vesting periods, potentially allowing for unintended token vesting or unlocking. There is no access control, meaning anyone can call this function and manipulate the vesting schedule to their advantage.",
        "file_name": "0xa27f262391913a5e21216c70de5358a1e887de25.sol"
    },
    {
        "function_name": "VestingContractWTTEST",
        "code": "function VestingContractWTTEST(WeTestToken _we_test_token) public { owner = msg.sender; we_test_token = _we_test_token; periods.push(1526997600); periods.push(2**256 - 1); current_period = 0; initData(0x0e0da823836499790ecbe17ba075a2a7cbe970e2, 1806343 * 10**18); }",
        "vulnerability": "Unprotected Initialization",
        "reason": "The constructor function does not have any checks to ensure it is called only once or by a specific entity. While in Solidity 0.4.21 the constructor is named after the contract, it's still a risk if mistakenly redeployed or used as a regular function. This could potentially allow an attacker to redeploy the contract with their address as the owner or set arbitrary values for the token address and initial vesting data.",
        "file_name": "0xa27f262391913a5e21216c70de5358a1e887de25.sol"
    },
    {
        "function_name": "ownerTransfer",
        "code": "function ownerTransfer(address to, uint value) public onlyOwner { uint current_balance_all = 0; for (uint i = 0; i < accounts.length; i++) current_balance_all += account_data[accounts[i]].current_balance; require(getBalance() > current_balance_all && value <= getBalance() - current_balance_all); if (we_test_token.transfer(to, value)) emit OwnerTransfer(to, value); }",
        "vulnerability": "Incorrect Balance Check",
        "reason": "The function ownerTransfer checks if the contract's balance is greater than the sum of current balances of all accounts and if the value to transfer is less than the surplus balance. However, this check does not account for the scenario where the token's balanceOf function could be manipulated, or if there are other external transfers that are not recorded in the contract's current_balance_all. This could potentially allow the owner to transfer out more tokens than intended, especially if the balanceOf view is incorrect or altered externally.",
        "file_name": "0xa27f262391913a5e21216c70de5358a1e887de25.sol"
    }
]