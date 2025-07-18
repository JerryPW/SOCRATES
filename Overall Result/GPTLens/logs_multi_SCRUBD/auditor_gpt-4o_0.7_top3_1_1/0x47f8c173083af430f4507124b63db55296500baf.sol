[
    {
        "function_name": "sum",
        "code": "function sum(uint[] array) public returns (uint) { uint summa; for (uint i; i < array.length; i++) { summa += array[i]; } return summa; }",
        "vulnerability": "Integer Overflow",
        "reason": "The 'sum' function does not use safe arithmetic operations, making it vulnerable to integer overflow when summing large numbers in the array, which can lead to incorrect results and potential exploitation.",
        "file_name": "0x47f8c173083af430f4507124b63db55296500baf.sol"
    },
    {
        "function_name": "createCampaign",
        "code": "function createCampaign(bytes32 id, uint value, address campaignCreator) onlyOwner returns (uint) { require(getAddressCreatorById(id) == address(0)); token.transferFrom(campaignCreator, this, value); campaigns[id] = Campaign(campaignCreator, value, value, Status.created); CreateCampaign(id); }",
        "vulnerability": "Lack of Input Validation",
        "reason": "There is no validation to check if 'value' is a positive number. This could allow campaigns to be created with a token amount of zero, potentially causing unexpected behavior or exploitation in other functions that assume a positive balance.",
        "file_name": "0x47f8c173083af430f4507124b63db55296500baf.sol"
    },
    {
        "function_name": "sendCoin",
        "code": "function sendCoin(address[] _routerOwners, uint[] amount, bytes32 id) onlyOwner { require(campaigns[id].status == Status.created); require(amount.length == _routerOwners.length); require(sum(amount) <= campaigns[id].tokenAmount); for (var i = 0; i < amount.length; i++) { token.transfer(_routerOwners[i], safeDiv(safeMul(amount[i], 95), 100)); } token.transfer(fee, safeDiv(safeMul(sum(amount), 5), 100) ); campaigns[id].currentBalance = safeSub(campaigns[id].currentBalance, sum(amount)); SendCoinForCampaign(id); }",
        "vulnerability": "Reentrancy",
        "reason": "The 'sendCoin' function performs token transfers before updating the 'campaigns[id].currentBalance'. This leaves the contract vulnerable to reentrancy attacks, where a malicious receiver could re-enter the 'sendCoin' function and manipulate the balance.",
        "file_name": "0x47f8c173083af430f4507124b63db55296500baf.sol"
    }
]