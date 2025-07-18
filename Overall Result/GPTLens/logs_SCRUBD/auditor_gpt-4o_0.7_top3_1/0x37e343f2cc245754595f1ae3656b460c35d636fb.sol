[
    {
        "function_name": "acceptOwnership",
        "code": "function acceptOwnership() external { if (msg.sender == newOwnerCandidate) { owner = newOwnerCandidate; newOwnerCandidate = address(0); emit OwnershipTransferred(owner, newOwnerCandidate); } }",
        "vulnerability": "Ownership not transferred correctly",
        "reason": "The function sets the owner to newOwnerCandidate before setting newOwnerCandidate to address(0). As a result, the OwnershipTransferred event is emitted with a newOwnerCandidate value of address(0), which is incorrect and can lead to confusion in logs or auditing the ownership transfer.",
        "file_name": "0x37e343f2cc245754595f1ae3656b460c35d636fb.sol"
    },
    {
        "function_name": "registerUserWallet",
        "code": "function registerUserWallet(address _user, uint32 _id) external onlyServer { require(userIds[_user] == 0); require(_user != owner); userIds[_user] = _id; if (walletBalances[_user] > 0) { balances[_id] += walletBalances[_user]; walletBalances[_user] = 0; } }",
        "vulnerability": "Potential locking of funds",
        "reason": "The function allows a server to associate an address with a user ID, but there is no mechanism to change or revoke an association. If a mistake is made or an address needs to change its user ID, the funds could be locked or mismanaged since the user cannot update their ID association.",
        "file_name": "0x37e343f2cc245754595f1ae3656b460c35d636fb.sol"
    },
    {
        "function_name": "addBonus",
        "code": "function addBonus(uint32[] _userIds, uint64[] _amounts) external onlyServer { require(_userIds.length == _amounts.length); uint64 sum = 0; for (uint32 i = 0; i < _amounts.length; i++) sum += _amounts[i]; require(walletBalances[owner] >= sum); for (i = 0; i < _userIds.length; i++) { balances[_userIds[i]] += _amounts[i]; blockedBalances[_userIds[i]] += _amounts[i]; } sentBonuses += sum; walletBalances[owner] -= sum; }",
        "vulnerability": "Integer overflow in sum calculation",
        "reason": "The summation of _amounts in the loop can lead to an integer overflow, resulting in incorrect computation and potentially allowing an attacker to manipulate bonus allocation. Although the Solidity version is 0.4.18, which does not have built-in overflow protection, this should be handled manually.",
        "file_name": "0x37e343f2cc245754595f1ae3656b460c35d636fb.sol"
    }
]