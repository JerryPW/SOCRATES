[
    {
        "function_name": "sum",
        "code": "function sum(uint[] array) public returns (uint) { uint summa; for (uint i; i < array.length; i++) { summa += array[i]; } return summa; }",
        "vulnerability": "Potential Integer Overflow",
        "reason": "The function `sum` lacks any checks for integer overflow when summing the elements of the input array. If the total exceeds the maximum uint value, it will wrap around to zero, potentially leading to incorrect calculations in functions that rely on this sum.",
        "file_name": "0x47f8c173083af430f4507124b63db55296500baf.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address newOwner) public onlyOwner { if (newOwner != address(0)) { owner = newOwner; } }",
        "vulnerability": "Lack of Event Emission",
        "reason": "The function `transferOwnership` changes a critical state variable `owner` without emitting an event. This can lead to lack of transparency and difficulty in tracking ownership changes on the blockchain.",
        "file_name": "0x47f8c173083af430f4507124b63db55296500baf.sol"
    },
    {
        "function_name": "finishCampaign",
        "code": "function finishCampaign(bytes32 id) onlyOwner returns (bool success) { campaigns[id].status = Status.finished; token.transfer(campaigns[id].creator, campaigns[id].currentBalance); campaigns[id].currentBalance = 0; }",
        "vulnerability": "Missing Checks and Event Emission",
        "reason": "The `finishCampaign` function can be called by the owner without checking if the campaign is in a suitable state to be finished (e.g., `Status.created`). This may allow premature finishing of campaigns. Additionally, it does not emit any events to log this critical operation, reducing transparency.",
        "file_name": "0x47f8c173083af430f4507124b63db55296500baf.sol"
    }
]