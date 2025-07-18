[
    {
        "function_name": "setPeriod",
        "code": "function setPeriod(uint i, uint v) public { periods[i] = v; }",
        "vulnerability": "Unrestricted access to setPeriod",
        "reason": "The setPeriod function allows anyone to modify the periods array without any access control. This means an attacker can manipulate vesting periods, potentially setting them to very high values to prevent future vesting or to very low values to allow immediate and unplanned vesting.",
        "file_name": "0xa27f262391913a5e21216c70de5358a1e887de25.sol"
    },
    {
        "function_name": "VestingContractWTTEST",
        "code": "function VestingContractWTTEST(WeTestToken _we_test_token) public { owner = msg.sender; we_test_token = _we_test_token; periods.push(1526997600); periods.push(2**256 - 1); current_period = 0; initData(0x0e0da823836499790ecbe17ba075a2a7cbe970e2, 1806343 * 10**18); }",
        "vulnerability": "Hardcoded account initialization",
        "reason": "The constructor initializes a specific account with a large balance and sets up the vesting schedule. This hardcoded approach lacks flexibility and could be exploited if the address is known to be vulnerable or if the contract is deployed with unintended access to this address.",
        "file_name": "0xa27f262391913a5e21216c70de5358a1e887de25.sol"
    },
    {
        "function_name": "ownerTransfer",
        "code": "function ownerTransfer(address to, uint value) public onlyOwner { uint current_balance_all = 0; for (uint i = 0; i < accounts.length; i++) current_balance_all += account_data[accounts[i]].current_balance; require(getBalance() > current_balance_all && value <= getBalance() - current_balance_all); if (we_test_token.transfer(to, value)) emit OwnerTransfer(to, value); }",
        "vulnerability": "Incorrect balance calculation",
        "reason": "The ownerTransfer function assumes that the current balance of the contract minus the sum of all account balances is available for transfer. However, this can be incorrect if the token contract allows for external transfers out of the vesting contract, leading to potential unauthorized transfers if the balance is not correctly tracked.",
        "file_name": "0xa27f262391913a5e21216c70de5358a1e887de25.sol"
    }
]