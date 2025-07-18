[
    {
        "function_name": "buyTokens",
        "code": "function buyTokens(address _beneficiary) public payable { uint256 weiAmount = msg.value; _preValidatePurchase(_beneficiary, weiAmount); uint tokens = 0; uint bonusTokens = 0; uint totalTokens = 0; (tokens, bonusTokens, totalTokens) = _getTokenAmount(weiAmount); _validatePurchase(tokens); uint256 price = tokens.div(1 ether).mul(tokenPriceInWei); uint256 _diff = weiAmount.sub(price); if (_diff > 0) { weiAmount = weiAmount.sub(_diff); msg.sender.transfer(_diff); } _processPurchase(_beneficiary, totalTokens); emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens, bonusTokens); _updateState(weiAmount, totalTokens); _forwardFunds(weiAmount); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function `buyTokens` performs a transfer of Ether back to the sender before updating the state variables (`tokensSold` and `weiRaised`). This could allow a reentrant call to exploit the contract by calling `buyTokens` again and potentially bypassing the `_validatePurchase` function, leading to multiple token purchases with insufficient funds.",
        "file_name": "0x0c78003843b4a72b765938cb3b14aecb188dbc6a.sol"
    },
    {
        "function_name": "__callback",
        "code": "function __callback(bytes32 myid, string result, bytes proof) public { if (msg.sender != oraclize_cbAddress()) revert(); require (pendingQueries[myid] == true); proof; emit NewKrakenPriceTicker(result); uint USD = parseInt(result); tokenPriceInWei = 1 ether / USD; updatePrice(); delete pendingQueries[myid]; }",
        "vulnerability": "Lack of proper proof verification",
        "reason": "The `__callback` function does not properly verify the `proof` parameter, allowing potential manipulation of the `result` string. An attacker could exploit this by providing a false result, affecting the `tokenPriceInWei` variable, and consequently manipulating the token price in their favor.",
        "file_name": "0x0c78003843b4a72b765938cb3b14aecb188dbc6a.sol"
    },
    {
        "function_name": "finalize",
        "code": "function finalize() onlyOwner public { require(!isFinalized); require(hasClosed() || capReached()); finalization(); emit Finalized(); isFinalized = true; }",
        "vulnerability": "Improper finalization logic",
        "reason": "The `finalize` function relies on the `finalization` logic which sends remaining tokens to the `reserveFund`. If the contract is finalized without proper checks on the token balance, it could lead to a significant amount of tokens being transferred to the `reserveFund` without appropriate authorization or transparency, which could be exploited by malicious reserve fund owners.",
        "file_name": "0x0c78003843b4a72b765938cb3b14aecb188dbc6a.sol"
    }
]