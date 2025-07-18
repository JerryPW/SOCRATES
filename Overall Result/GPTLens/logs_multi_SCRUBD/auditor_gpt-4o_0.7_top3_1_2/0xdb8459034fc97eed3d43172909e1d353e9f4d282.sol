[
    {
        "function_name": "changeStartAndEndDate",
        "code": "function changeStartAndEndDate (uint256 startTimeUnixTimestamp, uint256 endTimeUnixTimestamp) public onlyOwner { require (startTimeUnixTimestamp!=0 && endTimeUnixTimestamp!=0); require(endTimeUnixTimestamp>startTimeUnixTimestamp); require(endTimeUnixTimestamp.sub(startTimeUnixTimestamp) >=totalDurationInDays); startTime = startTimeUnixTimestamp; endTime = endTimeUnixTimestamp; }",
        "vulnerability": "Potential Denial of Service",
        "reason": "The owner can set a new start and end date for the crowdsale that does not overlap with the current time, effectively pausing the crowdsale indefinitely. This could lead to a denial of service for participants if the owner sets a future start date and never updates it.",
        "file_name": "0xdb8459034fc97eed3d43172909e1d353e9f4d282.sol"
    },
    {
        "function_name": "forwardFunds",
        "code": "function forwardFunds() internal { owner.transfer(msg.value); }",
        "vulnerability": "Unsafe direct transfer of Ether",
        "reason": "The usage of `transfer` in forwarding funds to the owner's address is potentially dangerous due to the 2300 gas limit imposed by `transfer`. If the owner is a contract that requires more than 2300 gas for execution, this transfer will fail, potentially causing funds to be stuck.",
        "file_name": "0xdb8459034fc97eed3d43172909e1d353e9f4d282.sol"
    },
    {
        "function_name": "manualTokenTransfer",
        "code": "function manualTokenTransfer(address receiver, uint value) public onlyOwner { token.transfer(receiver,value); TOKENS_SOLD = TOKENS_SOLD.add(value); }",
        "vulnerability": "Incorrect update of TOKENS_SOLD",
        "reason": "The function allows the owner to transfer tokens manually to any address, and it updates the `TOKENS_SOLD` variable without checking whether the transfer was successful. This could lead to an incorrect accounting of tokens sold if the transfer fails or the token contract behaves unexpectedly.",
        "file_name": "0xdb8459034fc97eed3d43172909e1d353e9f4d282.sol"
    }
]