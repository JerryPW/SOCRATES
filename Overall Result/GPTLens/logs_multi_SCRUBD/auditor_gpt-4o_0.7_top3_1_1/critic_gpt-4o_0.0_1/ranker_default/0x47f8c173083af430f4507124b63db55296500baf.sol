[
    {
        "function_name": "sendCoin",
        "vulnerability": "Reentrancy",
        "criticism": "The reasoning correctly identifies a potential reentrancy vulnerability due to token transfers occurring before updating the 'campaigns[id].currentBalance'. This could allow a malicious receiver to re-enter the function and manipulate the balance. The severity is high because reentrancy can lead to significant financial loss. The profitability is also high as an attacker could potentially drain funds from the contract.",
        "correctness": 9,
        "severity": 8,
        "profitability": 8,
        "reason": "The 'sendCoin' function performs token transfers before updating the 'campaigns[id].currentBalance'. This leaves the contract vulnerable to reentrancy attacks, where a malicious receiver could re-enter the 'sendCoin' function and manipulate the balance.",
        "code": "function sendCoin(address[] _routerOwners, uint[] amount, bytes32 id) onlyOwner { require(campaigns[id].status == Status.created); require(amount.length == _routerOwners.length); require(sum(amount) <= campaigns[id].tokenAmount); for (var i = 0; i < amount.length; i++) { token.transfer(_routerOwners[i], safeDiv(safeMul(amount[i], 95), 100)); } token.transfer(fee, safeDiv(safeMul(sum(amount), 5), 100) ); campaigns[id].currentBalance = safeSub(campaigns[id].currentBalance, sum(amount)); SendCoinForCampaign(id); }",
        "file_name": "0x47f8c173083af430f4507124b63db55296500baf.sol",
        "final_score": 8.5
    },
    {
        "function_name": "sum",
        "vulnerability": "Integer Overflow",
        "criticism": "The reasoning is correct in identifying the potential for integer overflow due to the lack of safe arithmetic operations. Solidity versions prior to 0.8.0 do not automatically check for overflows, making this a valid concern. The severity is moderate as it can lead to incorrect results, but it does not directly allow for exploitation. The profitability is low because an external attacker cannot directly profit from this overflow.",
        "correctness": 8,
        "severity": 5,
        "profitability": 1,
        "reason": "The 'sum' function does not use safe arithmetic operations, making it vulnerable to integer overflow when summing large numbers in the array, which can lead to incorrect results and potential exploitation.",
        "code": "function sum(uint[] array) public returns (uint) { uint summa; for (uint i; i < array.length; i++) { summa += array[i]; } return summa; }",
        "file_name": "0x47f8c173083af430f4507124b63db55296500baf.sol",
        "final_score": 5.5
    },
    {
        "function_name": "createCampaign",
        "vulnerability": "Lack of Input Validation",
        "criticism": "The reasoning correctly identifies the lack of input validation for the 'value' parameter. Allowing a zero value could lead to unexpected behavior in other parts of the contract that assume a positive balance. The severity is moderate because it could lead to logical errors, but it does not directly enable exploitation. The profitability is low as it does not provide a direct financial gain to an attacker.",
        "correctness": 8,
        "severity": 4,
        "profitability": 1,
        "reason": "There is no validation to check if 'value' is a positive number. This could allow campaigns to be created with a token amount of zero, potentially causing unexpected behavior or exploitation in other functions that assume a positive balance.",
        "code": "function createCampaign(bytes32 id, uint value, address campaignCreator) onlyOwner returns (uint) { require(getAddressCreatorById(id) == address(0)); token.transferFrom(campaignCreator, this, value); campaigns[id] = Campaign(campaignCreator, value, value, Status.created); CreateCampaign(id); }",
        "file_name": "0x47f8c173083af430f4507124b63db55296500baf.sol",
        "final_score": 5.25
    }
]