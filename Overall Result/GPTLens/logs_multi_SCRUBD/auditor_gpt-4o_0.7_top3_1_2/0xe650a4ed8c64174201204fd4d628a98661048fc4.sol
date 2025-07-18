[
    {
        "function_name": "sendToken",
        "code": "function sendToken(address addr, uint256 amount, token tokenReward) private returns (bool success) { for(uint c=0;c<tokenMaster.length;c++){ if (tokenMaster[c] == msg.sender) { tokenReward.transfer(addr, amount); return true; } } return false; }",
        "vulnerability": "Arbitrary token transfer",
        "reason": "The `sendToken` function allows any address in `tokenMaster` to transfer tokens from any token address specified in `betToTokenAddress`, potentially leading to unauthorized token transfers. An attacker with access to one of the token master addresses can call `signal` to trigger `sendToken`, resulting in unauthorized token transfers from the contract.",
        "file_name": "0xe650a4ed8c64174201204fd4d628a98661048fc4.sol"
    },
    {
        "function_name": "signal",
        "code": "function signal(bytes32 bid, bytes32 result) public returns (bool success) { betToWinners[bid] = result; address payable addr = (betToAddress[bid]); if (betToTokenAddress[bid] != address(0x0)){ sendToken(addr, betToValue[bid], token(betToTokenAddress[bid])); }else{ addr.send(betToValue[bid]); } return true; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `signal` function directly transfers Ether using `addr.send` without any reentrancy protection. This makes the contract vulnerable to reentrancy attacks if `addr` is a contract with a fallback function that calls back into `signal` or another function on the contract, potentially allowing the draining of Ether from the contract.",
        "file_name": "0xe650a4ed8c64174201204fd4d628a98661048fc4.sol"
    },
    {
        "function_name": "insertBet",
        "code": "function insertBet(bytes32 bid, address payable addr, uint256 _value, address payable tokenAddress) public returns (bool success) { betToAddress[bid] = addr; betToValue[bid] = _value; betToTokenAddress[bid] = tokenAddress; return true; }",
        "vulnerability": "No input validation",
        "reason": "The `insertBet` function lacks validation checks for input parameters, allowing anyone to insert arbitrary bets. This could lead to storage of invalid or malicious data, such as duplicate bids, invalid addresses, or invalid values, which could be exploited for various attacks or to corrupt the contract's state.",
        "file_name": "0xe650a4ed8c64174201204fd4d628a98661048fc4.sol"
    }
]