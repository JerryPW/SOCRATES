[
    {
        "function_name": "__callback",
        "code": "function __callback(bytes32 myid, string result, bytes proof) public { require(msg.sender == oraclize_cbAddress()); uint newPrice = parseInt(result).mul(100); if (newPrice >= m_ETHPriceLowerBound && newPrice <= m_ETHPriceUpperBound) { m_ETHPriceInCents = newPrice; m_ETHPriceLastUpdate = getTime(); NewETHPrice(m_ETHPriceInCents); } else { ETHPriceOutOfBounds(newPrice); } updateETHPriceInCents(); }",
        "vulnerability": "Unrestricted External Call",
        "reason": "The __callback function can be called by anyone if the Oraclize callback address is set incorrectly, allowing attackers to manipulate the ETH price and potentially execute unauthorized transactions or cause incorrect updates of the ETH price.",
        "file_name": "0x2aa216f8126190fe5610b1b6c3c4835d1b07c8c8.sol"
    },
    {
        "function_name": "oraclize_setNetwork",
        "code": "function oraclize_setNetwork(uint8 networkID) internal returns(bool){ return oraclize_setNetwork(); networkID; }",
        "vulnerability": "Improper Use of Function",
        "reason": "The function oraclize_setNetwork(uint8 networkID) improperly calls itself without using the networkID parameter, leading to potential infinite recursion or logic errors. This can disrupt the network setting functionality.",
        "file_name": "0x2aa216f8126190fe5610b1b6c3c4835d1b07c8c8.sol"
    },
    {
        "function_name": "updateETHPriceInCents",
        "code": "function updateETHPriceInCents() public payable { if ( !updateRequestExpired() ) { NewOraclizeQuery(\"Oraclize request fail. Previous one still pending\"); } else if (oraclize_getPrice(\"URL\") > this.balance) { NewOraclizeQuery(\"Oraclize request fail. Not enough ether\"); } else { oraclize_query( m_ETHPriceUpdateInterval, \"URL\", \"(https: m_callbackGas ); m_ETHPriceLastUpdateRequest = getTime(); NewOraclizeQuery(\"Oraclize query was sent\"); } }",
        "vulnerability": "Reentrancy",
        "reason": "The function updateETHPriceInCents checks for balance and then makes an external call with oraclize_query. If an attacker manages to execute a reentrant call during the balance check, they can manipulate the balance state and cause incorrect execution flow or drain funds.",
        "file_name": "0x2aa216f8126190fe5610b1b6c3c4835d1b07c8c8.sol"
    }
]