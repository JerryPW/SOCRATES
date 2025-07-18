[
    {
        "function_name": "BatchTransfer",
        "code": "function BatchTransfer(address _owner) public { require(_owner != address(0)); owner = _owner; owner = msg.sender; }",
        "vulnerability": "Constructor overwrites owner",
        "reason": "The constructor of the BatchTransfer contract takes an address parameter _owner and sets the owner to this address. However, immediately after, it overwrites the owner with msg.sender. This makes the _owner parameter useless and always assigns ownership to the deployer of the contract, which might not be the intended behavior.",
        "file_name": "0x62a03c868c959386b2df7f266e79bc711fb92398.sol"
    },
    {
        "function_name": "batchTransfer",
        "code": "function batchTransfer(address[] _recipients, uint256[] _values) external onlyOwnerOrAdmin returns (bool) { require( _recipients.length > 0 && _recipients.length == _values.length); uint256 total = 0; for(uint i = 0; i < _values.length; i++){ total = total.add(_values[i]); } require(total <= standardToken.balanceOf(msg.sender)); for(uint j = 0; j < _recipients.length; j++){ standardToken.transfer(_recipients[j], _values[j]); totalUserTransfered = totalUserTransfered.add(1); userTransfered[_recipients[j]] = true; TransferToken(msg.sender, _recipients[j], _values[j]); } return true; }",
        "vulnerability": "Lack of transfer result check",
        "reason": "The batchTransfer function calls the transfer function of the standardToken without checking its returned result. If the transfer fails for any reason (e.g., due to a false return value from the token's transfer function), the function will not revert, leading to potential inconsistencies in the expected state and actual token balances.",
        "file_name": "0x62a03c868c959386b2df7f266e79bc711fb92398.sol"
    },
    {
        "function_name": "setContractToken",
        "code": "function setContractToken (address _addressContract) public onlyOwner { require(_addressContract != address(0)); standardToken = Token(_addressContract); totalUserTransfered = 0; }",
        "vulnerability": "Token contract can be arbitrarily changed",
        "reason": "The setContractToken function allows the owner to change the token contract address at any time. This can be exploited if ownership is compromised or in the presence of a malicious owner, as they could set the token to an arbitrary contract, potentially leading to the loss of tokens or other malicious actions.",
        "file_name": "0x62a03c868c959386b2df7f266e79bc711fb92398.sol"
    }
]