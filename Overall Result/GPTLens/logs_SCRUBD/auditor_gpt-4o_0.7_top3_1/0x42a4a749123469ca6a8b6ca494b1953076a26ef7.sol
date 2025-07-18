[
    {
        "function_name": "withdrawTokens",
        "code": "function withdrawTokens() public { require(bals[msg.sender] > 0); require(now >= releaseTimes[msg.sender]); tokenReward.transfer(msg.sender,bals[msg.sender]); bals[msg.sender] = 0; }",
        "vulnerability": "Missing return value check for ERC20 transfer",
        "reason": "The withdrawTokens function calls the transfer function of the token contract without checking its return value. If the transfer fails, the user's balance will still be set to 0, leading to a loss of tokens for the user. This vulnerability could be exploited if the token contract does not revert on failure but returns false instead. An attacker could call withdrawTokens when the transfer is expected to fail, and this would result in the loss of tokens for the user.",
        "file_name": "0x42a4a749123469ca6a8b6ca494b1953076a26ef7.sol"
    },
    {
        "function_name": "sendTokens",
        "code": "function sendTokens(address _to, uint _value, uint _timeStamp, bytes32 _referenceCode) public onlyOwner { bals[_to] = bals[_to].add(_value); releaseTimes[_to] = _timeStamp; referenceCodes[_to].push(_referenceCode); referenceAddresses[_referenceCode].push(_to); emit TokensSent(_to, _value, _timeStamp, _referenceCode); }",
        "vulnerability": "Potential overflow in balance addition",
        "reason": "The sendTokens function uses the SafeMath add function to update the balances, which prevents overflow. However, if the SafeMath library were to be removed or bypassed, this function would be vulnerable to integer overflow attacks, where the balance could wrap around, allowing an attacker to withdraw more tokens than they are entitled to. Although SafeMath is currently in use, any future changes or misunderstandings about its importance could reintroduce this vulnerability.",
        "file_name": "0x42a4a749123469ca6a8b6ca494b1953076a26ef7.sol"
    },
    {
        "function_name": "setTokenReward",
        "code": "function setTokenReward(address _tokenContractAddress) public onlyOwner { tokenReward = token(_tokenContractAddress); addressOfTokenUsedAsReward = _tokenContractAddress; }",
        "vulnerability": "Token contract address can be set to a malicious contract",
        "reason": "The setTokenReward function allows the owner to set the token contract address arbitrarily. This means that the contract owner can potentially set a malicious contract as the token reward contract, which could then execute arbitrary code or steal funds when the transfer function is called. An attacker could exploit this to replace the legitimate token contract with one that behaves maliciously, affecting all users interacting with the contract.",
        "file_name": "0x42a4a749123469ca6a8b6ca494b1953076a26ef7.sol"
    }
]