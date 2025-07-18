[
    {
        "function_name": "setPeriod",
        "code": "function setPeriod(uint i, uint v) public { periods[i] = v; }",
        "vulnerability": "Unrestricted access to setPeriod",
        "reason": "The setPeriod function allows any user to modify the periods array, which could be used maliciously. An attacker could set future periods to incorrect values or reduce the length of the vesting period, potentially disrupting the vesting schedule.",
        "file_name": "0x4f0499f4da2d75d03fcc2dc2d97ffae976246809.sol"
    },
    {
        "function_name": "VestingContractWT",
        "code": "function VestingContractWT(WeToken _we_token) public { owner = msg.sender; we_token = _we_token; periods.push(1542499200); periods.push(2**256 - 1); current_period = 0; initData(0x41c936C0dC81F0c41b45A0069bc9E1A56F4d12B3, 1806343 * 10**18); }",
        "vulnerability": "Hardcoded initial account and balance",
        "reason": "The constructor initializes the contract with a hardcoded address and token balance, which could be a point of attack if the address is not controlled by the intended party. This may lead to unauthorized access to the vesting funds if the hardcoded address is compromised.",
        "file_name": "0x4f0499f4da2d75d03fcc2dc2d97ffae976246809.sol"
    },
    {
        "function_name": "ownerTransfer",
        "code": "function ownerTransfer(address to, uint value) public onlyOwner { uint current_balance_all = 0; for (uint i = 0; i < accounts.length; i++) current_balance_all += account_data[accounts[i]].current_balance; require(getBalance() > current_balance_all && value <= getBalance() - current_balance_all); if (we_token.transfer(to, value)) emit OwnerTransfer(to, value); }",
        "vulnerability": "Potential integer overflow in balance calculation",
        "reason": "The ownerTransfer function does not properly check for integer overflow when summing balances. This could allow an attacker to manipulate account balances in such a way that the total balance overflows, potentially allowing unauthorized transfer of tokens if the overflowed value passes the require check.",
        "file_name": "0x4f0499f4da2d75d03fcc2dc2d97ffae976246809.sol"
    }
]