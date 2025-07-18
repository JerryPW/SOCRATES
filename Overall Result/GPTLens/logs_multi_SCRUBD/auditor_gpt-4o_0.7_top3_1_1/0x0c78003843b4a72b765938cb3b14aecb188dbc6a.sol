[
    {
        "function_name": "withdrawBalance",
        "code": "function withdrawBalance(address _to) onlyOwner external { require(_to != address(0)); require(address(this).balance > 0); oraclizeBalance = 0; _to.transfer(address(this).balance); }",
        "vulnerability": "Insecure Ether Transfer",
        "reason": "The function allows the owner to withdraw the entire balance of the contract to an address without any additional checks or constraints. If the owner's address is compromised, an attacker can withdraw all funds.",
        "file_name": "0x0c78003843b4a72b765938cb3b14aecb188dbc6a.sol"
    },
    {
        "function_name": "__callback",
        "code": "function __callback(bytes32 myid, string result, bytes proof) public { if (msg.sender != oraclize_cbAddress()) revert(); require (pendingQueries[myid] == true); proof; emit NewKrakenPriceTicker(result); uint USD = parseInt(result); tokenPriceInWei = 1 ether / USD; updatePrice(); delete pendingQueries[myid]; }",
        "vulnerability": "Floating Point Arithmetic",
        "reason": "The function calculates `tokenPriceInWei` using division, which can lead to precision errors. If `USD` is very small, it can cause the price to be set incorrectly, potentially manipulated by an attacker controlling the oracle response.",
        "file_name": "0x0c78003843b4a72b765938cb3b14aecb188dbc6a.sol"
    },
    {
        "function_name": "buyTokens",
        "code": "function buyTokens(address _beneficiary) public payable { uint256 weiAmount = msg.value; _preValidatePurchase(_beneficiary, weiAmount); uint tokens = 0; uint bonusTokens = 0; uint totalTokens = 0; (tokens, bonusTokens, totalTokens) = _getTokenAmount(weiAmount); _validatePurchase(tokens); uint256 price = tokens.div(1 ether).mul(tokenPriceInWei); uint256 _diff = weiAmount.sub(price); if (_diff > 0) { weiAmount = weiAmount.sub(_diff); msg.sender.transfer(_diff); } _processPurchase(_beneficiary, totalTokens); emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens, bonusTokens); _updateState(weiAmount, totalTokens); _forwardFunds(weiAmount); }",
        "vulnerability": "Reentrancy",
        "reason": "The function refunds excess Ether to the `msg.sender` before updating the state variables and forwarding funds. This can be exploited using reentrancy attacks, allowing an attacker to repeatedly call `buyTokens` and manipulate state variables such as `tokensSold` and `weiRaised`.",
        "file_name": "0x0c78003843b4a72b765938cb3b14aecb188dbc6a.sol"
    }
]