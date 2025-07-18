[
    {
        "function_name": "setPeriod",
        "code": "function setPeriod(uint i, uint v) public { periods[i] = v; }",
        "vulnerability": "Public function allows manipulation of periods",
        "reason": "The setPeriod function is public and allows anyone to modify the periods array. This can be exploited by an attacker to change vesting periods to arbitrary values, potentially enabling earlier or unauthorized fund releases.",
        "file_name": "0x4f0499f4da2d75d03fcc2dc2d97ffae976246809.sol"
    },
    {
        "function_name": "VestingContractWT",
        "code": "function VestingContractWT(WeToken _we_token) public { owner = msg.sender; we_token = _we_token; periods.push(1542499200); periods.push(2**256 - 1); current_period = 0; initData(0x41c936C0dC81F0c41b45A0069bc9E1A56F4d12B3, 1806343 * 10**18); }",
        "vulnerability": "Lack of input validation in constructor",
        "reason": "The constructor initializes the contract with a predefined account and balance without any input validation. This can lead to vulnerabilities if the hardcoded address or balance is incorrect or maliciously set in a deployed contract, causing potential loss of funds or incorrect vesting.",
        "file_name": "0x4f0499f4da2d75d03fcc2dc2d97ffae976246809.sol"
    },
    {
        "function_name": "ownerTransfer",
        "code": "function ownerTransfer(address to, uint value) public onlyOwner { uint current_balance_all = 0; for (uint i = 0; i < accounts.length; i++) current_balance_all += account_data[accounts[i]].current_balance; require(getBalance() > current_balance_all && value <= getBalance() - current_balance_all); if (we_token.transfer(to, value)) emit OwnerTransfer(to, value); }",
        "vulnerability": "Incorrect balance calculation logic",
        "reason": "The ownerTransfer function calculates the current_balance_all by summing the current balances of all accounts. However, this logic may not correctly account for tokens already transferred out, leading to an inaccurate assessment of available tokens. This can result in unauthorized token transfers if the balance checking logic fails to account for all scenarios.",
        "file_name": "0x4f0499f4da2d75d03fcc2dc2d97ffae976246809.sol"
    }
]