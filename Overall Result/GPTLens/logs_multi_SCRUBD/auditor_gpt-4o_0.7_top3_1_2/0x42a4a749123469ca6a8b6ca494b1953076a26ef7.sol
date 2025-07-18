[
    {
        "function_name": "withdrawTokens",
        "code": "function withdrawTokens() public { require(bals[msg.sender] > 0); require(now >= releaseTimes[msg.sender]); tokenReward.transfer(msg.sender,bals[msg.sender]); bals[msg.sender] = 0; }",
        "vulnerability": "Lack of safe transfer call to external contract",
        "reason": "The `withdrawTokens` function calls the `transfer` function of the `tokenReward` contract, but it does not check the return value. If the `transfer` function fails, the tokens might not be transferred, but `bals[msg.sender]` will still be set to 0, resulting in a loss of funds for the caller. This can be exploited if the `tokenReward` contract behaves unexpectedly or maliciously, intentionally failing the transfer.",
        "file_name": "0x42a4a749123469ca6a8b6ca494b1953076a26ef7.sol"
    },
    {
        "function_name": "sendTokens",
        "code": "function sendTokens(address _to, uint _value, uint _timeStamp, bytes32 _referenceCode) public onlyOwner { bals[_to] = bals[_to].add(_value); releaseTimes[_to] = _timeStamp; referenceCodes[_to].push(_referenceCode); referenceAddresses[_referenceCode].push(_to); emit TokensSent(_to, _value, _timeStamp, _referenceCode); }",
        "vulnerability": "No validation on timestamp for token release",
        "reason": "The `sendTokens` function allows the contract owner to set any `_timeStamp` for releasing tokens, including past timestamps. This can allow the owner to immediately withdraw tokens intended for future release, potentially defrauding beneficiaries expecting tokens at a later date.",
        "file_name": "0x42a4a749123469ca6a8b6ca494b1953076a26ef7.sol"
    },
    {
        "function_name": "setTokenReward",
        "code": "function setTokenReward(address _tokenContractAddress) public onlyOwner { tokenReward = token(_tokenContractAddress); addressOfTokenUsedAsReward = _tokenContractAddress; }",
        "vulnerability": "Token contract address can be changed arbitrarily",
        "reason": "The owner can call `setTokenReward` to change the `tokenReward` contract to any arbitrary address, including a malicious contract. This could allow the owner to redirect token transfers to a malicious contract, facilitating theft or loss of tokens for users attempting to withdraw.",
        "file_name": "0x42a4a749123469ca6a8b6ca494b1953076a26ef7.sol"
    }
]