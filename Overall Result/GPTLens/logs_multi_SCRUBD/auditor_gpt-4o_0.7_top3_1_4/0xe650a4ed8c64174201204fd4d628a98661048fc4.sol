[
    {
        "function_name": "sendToken",
        "code": "function sendToken(address addr, uint256 amount, token tokenReward) private returns (bool success) { for(uint c=0;c<tokenMaster.length;c++){ if (tokenMaster[c] == msg.sender) { tokenReward.transfer(addr, amount); return true; } } return false; }",
        "vulnerability": "Unchecked external call",
        "reason": "The `tokenReward.transfer` function is being called without checking its return value. If the token adheres to the ERC20 standard, the transfer function returns a boolean indicating success. If this is not checked, the contract could assume a transfer succeeded when it actually failed, leading to incorrect balances and potential loss of funds.",
        "file_name": "0xe650a4ed8c64174201204fd4d628a98661048fc4.sol"
    },
    {
        "function_name": "insertBet",
        "code": "function insertBet(bytes32 bid, address payable addr, uint256 _value, address payable tokenAddress) public returns (bool success) { betToAddress[bid] = addr; betToValue[bid] = _value; betToTokenAddress[bid] = tokenAddress; return true; }",
        "vulnerability": "Lack of access control",
        "reason": "The `insertBet` function is publicly accessible, which allows any user to insert arbitrary bets into the contract's storage. This can lead to unauthorized entries which can be later used to trigger the `signal` function, resulting in unauthorized token transfers or ETH sends.",
        "file_name": "0xe650a4ed8c64174201204fd4d628a98661048fc4.sol"
    },
    {
        "function_name": "signal",
        "code": "function signal(bytes32 bid, bytes32 result) public returns (bool success) { betToWinners[bid] = result; address payable addr = (betToAddress[bid]); if (betToTokenAddress[bid] != address(0x0)){ sendToken(addr, betToValue[bid], token(betToTokenAddress[bid])); }else{ addr.send(betToValue[bid]); } return true; }",
        "vulnerability": "Unsafe use of addr.send",
        "reason": "The function uses `addr.send(betToValue[bid])` to transfer ETH, which only forwards 2300 gas and does not revert on failure. This may lead to situations where the transfer fails (for example, if the receiving address is a contract with high gas requirements), but the contract does not handle this failure, potentially resulting in loss of funds.",
        "file_name": "0xe650a4ed8c64174201204fd4d628a98661048fc4.sol"
    }
]