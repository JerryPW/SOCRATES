[
    {
        "function_name": "token.transfer",
        "code": "function transfer(address _to, uint256 _amount) public returns (bool success);",
        "vulnerability": "Lack of return value checking",
        "reason": "The `buyTokens` function calls `token.transfer` without checking its return value. If the transfer fails, the transaction will continue executing, which could result in incorrect states or loss of funds. Attackers can exploit this by sending tokens to addresses that reject transfers, potentially causing the function to behave unexpectedly.",
        "file_name": "0x26436e73fdd02adde8ae7ab61fa660d6f7926e6f.sol"
    },
    {
        "function_name": "forwardFunds",
        "code": "function forwardFunds() internal { wallet.transfer(msg.value); }",
        "vulnerability": "Unsafe use of transfer function",
        "reason": "The `forwardFunds` function uses the `transfer` function to send Ether to the `wallet`. If the `wallet` address is a contract, and its fallback function uses more than 2300 gas, the transfer will fail and revert the entire transaction. An attacker could deploy a contract with a costly fallback function to disrupt the crowdsale by making it impossible to forward funds.",
        "file_name": "0x26436e73fdd02adde8ae7ab61fa660d6f7926e6f.sol"
    },
    {
        "function_name": "rateUpgrade",
        "code": "function rateUpgrade(uint256 tierAmount) internal { uint256 tierEthLimit = fundingLimit[tierNum].div(fundingRate[tierNum]); uint256 tierWeiLimit = tierEthLimit.mul(1 ether); if(tierAmount >= tierWeiLimit) { tierNum = tierNum.add(1); rate = fundingRate[tierNum]; tierTotal = 0; } }",
        "vulnerability": "Incorrect array bounds check",
        "reason": "The `rateUpgrade` function changes the `rate` based on the `tierNum`, but it doesn't check if `tierNum` exceeds the length of the `fundingRate` array. If `tierNum` becomes out of bounds, it will cause a runtime error leading to denial of service. This can happen if multiple large purchases are made in a short period.",
        "file_name": "0x26436e73fdd02adde8ae7ab61fa660d6f7926e6f.sol"
    }
]