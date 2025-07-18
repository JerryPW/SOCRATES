[
    {
        "function_name": "withdrawAll",
        "code": "function withdrawAll () onlyAdmins() public { msg.sender.transfer(address(this).balance); }",
        "vulnerability": "Admin can drain all funds",
        "reason": "The withdrawAll function allows any admin to withdraw the entire balance of the contract to their address. If an admin account is compromised or malicious, they could drain all funds from the contract.",
        "file_name": "0x46cefba4dd7512b2449e1ac4b730bfb7f77d1407.sol"
    },
    {
        "function_name": "withdrawAmount",
        "code": "function withdrawAmount (uint256 _amount) onlyAdmins() public { msg.sender.transfer(_amount); }",
        "vulnerability": "Admin can withdraw arbitrary amounts",
        "reason": "Similar to withdrawAll, the withdrawAmount function allows any admin to specify and withdraw an arbitrary amount of funds from the contract. This could be exploited by a malicious admin to misappropriate funds.",
        "file_name": "0x46cefba4dd7512b2449e1ac4b730bfb7f77d1407.sol"
    },
    {
        "function_name": "revoke",
        "code": "function revoke(uint256 _id) public { require(msg.sender == orderBook[_id].owner); require(orderBook[_id].endTime <= now); Issuer issuer = Issuer(orderBook[_id].issuer); issuer.transfer(msg.sender, orderBook[_id].tokenId); orderBook[_id] = orderBook[orderBookSize-1]; orderBookSize -= 1; }",
        "vulnerability": "Revoke causes data inconsistency",
        "reason": "The revoke function swaps the last order in the orderBook with the one being revoked without updating the orderBookSize correctly. This can lead to data inconsistency, allowing subsequent operations to access invalid order data or cause unexpected behavior.",
        "file_name": "0x46cefba4dd7512b2449e1ac4b730bfb7f77d1407.sol"
    }
]