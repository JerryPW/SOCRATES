[
    {
        "function_name": "withdrawTokens",
        "code": "function withdrawTokens(address tokenContract) public { Token tc = Token(tokenContract); tc.transfer(owner, tc.balanceOf(this)); }",
        "vulnerability": "Missing Access Control",
        "reason": "The `withdrawTokens` function lacks access control, allowing any user to call it and transfer all tokens from the contract to the owner's address. This means an attacker can deplete the contract's token balance without restriction.",
        "file_name": "0xc80defd365fbac2dffeddfcb091b99afea6f8408.sol"
    },
    {
        "function_name": "withdrawEther",
        "code": "function withdrawEther() public { owner.transfer(this.balance); }",
        "vulnerability": "Missing Access Control",
        "reason": "The `withdrawEther` function does not have any access control checks. As a result, any user can call this function to transfer all Ether held by the contract to the owner's address. This exposes the contract to unauthorized balance depletion.",
        "file_name": "0xc80defd365fbac2dffeddfcb091b99afea6f8408.sol"
    },
    {
        "function_name": "getTokens",
        "code": "function getTokens(uint num, address tokenBuyerContract) public { tokenBuyerContract.call.value(0 wei)(); tokenBuyerContract.call.value(0 wei)(); tokenBuyerContract.call.value(0 wei)(); tokenBuyerContract.call.value(0 wei)(); tokenBuyerContract.call.value(0 wei)(); tokenBuyerContract.call.value(0 wei)(); tokenBuyerContract.call.value(0 wei)(); tokenBuyerContract.call.value(0 wei)(); tokenBuyerContract.call.value(0 wei)(); tokenBuyerContract.call.value(0 wei)(); }",
        "vulnerability": "Arbitrary External Call",
        "reason": "The `getTokens` function makes multiple external calls to the provided `tokenBuyerContract` address in an unguarded manner. This allows attackers to execute arbitrary code, potentially leading to reentrancy attacks or other malicious actions, since there are no checks on the contract being called.",
        "file_name": "0xc80defd365fbac2dffeddfcb091b99afea6f8408.sol"
    }
]