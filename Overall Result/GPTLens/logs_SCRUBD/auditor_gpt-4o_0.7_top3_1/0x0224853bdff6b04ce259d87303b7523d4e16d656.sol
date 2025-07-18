[
    {
        "function_name": "buyTokens",
        "code": "function buyTokens(address _beneficiary) public payable { require(started); require(!finished); require(_beneficiary != address(0)); require(msg.value != 0); require(whitelist[msg.sender] && whitelist[_beneficiary]); require(fidaToken.totalSupply() < 24750 * 10**3 * 10**DECIMALS); uint256 amountTokens = getAmountFida(msg.value); require(amountTokens >= 50 * 10**DECIMALS); if (!earlybirdEnded) { _investAsEarlybird(_beneficiary, amountTokens); } else { _investAsBonusProgram(_beneficiary, amountTokens); } wallet.transfer(msg.value); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function transfers Ether to an external address (`wallet.transfer(msg.value);`) after state changes are made. This can potentially allow a reentrant call that could exploit the contract's logic, especially if the `wallet` is a contract that could call back into this function.",
        "file_name": "0x0224853bdff6b04ce259d87303b7523d4e16d656.sol"
    },
    {
        "function_name": "giveBounty",
        "code": "function giveBounty(uint256 _tokens, address _address) external { require(msg.sender == bountyAddress); tokenAvailable = tokenAvailable.sub(_tokens); mintableFida.sendBoughtTokens(_address, _tokens); }",
        "vulnerability": "Improper authorization",
        "reason": "The function only checks if `msg.sender` is `bountyAddress`, which can be easily compromised if the control over `bountyAddress` is lost. There is no mechanism to ensure that only an authorized entity can update `bountyAddress`, making it susceptible to unauthorized bounty distribution if `bountyAddress` is changed maliciously.",
        "file_name": "0x0224853bdff6b04ce259d87303b7523d4e16d656.sol"
    },
    {
        "function_name": "_updatePrice",
        "code": "function _updatePrice() private { if (oraclize_getPrice(\"URL\", gasLimit) > address(this).balance) { emit OraclizeQueryNotSend(\"Oraclize query was NOT sent, please add some ETH to cover for the query fee\", oraclize_getPrice(\"URL\")); } else { bytes32 id = oraclize_query(\"URL\", \"(https: ids[id] = true; emit NewOraclizeQuery(id, oraclize_getPrice(\"URL\")); } }",
        "vulnerability": "Funds exhaustion risk",
        "reason": "This function uses Oraclize to perform an external query that requires payment in Ether. If the contract balance is insufficient, the query fails, which could halt contract functionality relying on up-to-date price information. Moreover, frequent and potentially costly queries could deplete the contract's Ether balance.",
        "file_name": "0x0224853bdff6b04ce259d87303b7523d4e16d656.sol"
    }
]