[
    {
        "function_name": "setPeriod",
        "code": "function setPeriod(uint i, uint v) public { periods[i] = v; }",
        "vulnerability": "Lack of access control",
        "reason": "The setPeriod function allows anyone to modify the periods array, which could interfere with the vesting schedule. An attacker could set the periods to unfavorable values, potentially allowing them to manipulate the current period and limits for token transfers.",
        "file_name": "0x533411c7c401ee3a136ddc7a2fc95d6624c9e041.sol"
    },
    {
        "function_name": "VestingContractWTTEST",
        "code": "function VestingContractWTTEST(WeTestToken _we_test_token) public { owner = msg.sender; we_test_token = _we_test_token; periods.push(1527003900); periods.push(2**256 - 1); current_period = 0; initData(0x0e0da823836499790ecbe17ba075a2a7cbe970e2, 1806343 * 10**18); }",
        "vulnerability": "Hardcoded address initialization",
        "reason": "The constructor initializes account data with a hardcoded address (0x0e0da823836499790ecbe17ba075a2a7cbe970e2). If this address is not controlled by the contract owner or is incorrect, it may lead to an undesired state where tokens are locked or incorrectly distributed.",
        "file_name": "0x533411c7c401ee3a136ddc7a2fc95d6624c9e041.sol"
    },
    {
        "function_name": "ownerTransfer",
        "code": "function ownerTransfer(address to, uint value) public onlyOwner { uint current_balance_all = 0; for (uint i = 0; i < accounts.length; i++) current_balance_all += account_data[accounts[i]].current_balance; require(getBalance() > current_balance_all && value <= getBalance() - current_balance_all); if (we_test_token.transfer(to, value)) emit OwnerTransfer(to, value); }",
        "vulnerability": "Incorrect balance calculation",
        "reason": "The ownerTransfer function calculates the total current balance of all accounts and allows owner transfers if the contract's balance exceeds this amount. However, this logic does not account for tokens already transferred out of the contract, potentially allowing the owner to transfer more tokens than intended, especially if new periods are not correctly managed.",
        "file_name": "0x533411c7c401ee3a136ddc7a2fc95d6624c9e041.sol"
    }
]