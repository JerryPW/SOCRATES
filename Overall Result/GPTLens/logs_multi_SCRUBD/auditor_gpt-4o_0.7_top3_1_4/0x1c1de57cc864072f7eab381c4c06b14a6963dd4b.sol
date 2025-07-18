[
    {
        "function_name": "createToken",
        "code": "function createToken(string symbol, string name, address coin_address, uint8 decimals) public { require(msg.value == deploy_fee); require(owner.send(msg.value)); shitcoins.push(coin_t(symbol, name, coin_address, decimals, msg.sender, 0, COIN_NON_APPROVED, 0, 0)); shitcoin_index[symbol] = uint16(shitcoins.length); }",
        "vulnerability": "Potential reentrancy vulnerability",
        "reason": "The function sends Ether to an external address (owner) before updating the state variables (adding the coin to the shitcoins array and updating shitcoin_index). This could potentially be exploited if the owner is a contract that performs a reentrant call, although the risk is mitigated since the recipient is the contract owner.",
        "file_name": "0x1c1de57cc864072f7eab381c4c06b14a6963dd4b.sol"
    },
    {
        "function_name": "remove_coin",
        "code": "function remove_coin(uint index) public { require(msg.sender == owner); require(index < shitcoins.length); string ticker = shitcoins[index].ticker; delete shitcoins[index]; delete shitcoin_index[ticker]; for (uint16 i = 0; i < uint16(shitcoins.length); i++) { shitcoin_index[shitcoins[i].ticker] = i + 1; } }",
        "vulnerability": "Reindexing after deletion",
        "reason": "The function deletes an element from the array and then attempts to reindex the remaining elements. However, this can cause inconsistencies if there are any indices greater than the removed index. Additionally, it may not fully clear the deleted entry, leading to potential issues when accessing the array.",
        "file_name": "0x1c1de57cc864072f7eab381c4c06b14a6963dd4b.sol"
    },
    {
        "function_name": "cancel",
        "code": "function cancel(string token, uint256 index) public { coin_t coin = shitcoins[shitcoin_index[token] - 1]; order_t order = order_book[token][index]; require(coin.state == COIN_APPROVED); require((msg.sender == order.owner) || (msg.sender == owner)); require(order.amount > 0); order.amount = 0; if (order.buy_sell == BUY) { uint256 total_deal = total_amount(token, order.amount, order.price); etx_balances[msg.sender] = safe_sub(etx_balances[msg.sender], total_deal); require(order.owner.send(total_deal)); } else { ERC20 shitcoin = ERC20(coin.base); shitcoin.transfer(order.owner, order.amount); } }",
        "vulnerability": "Incorrect refund amount",
        "reason": "The function sets order.amount to 0 before calculating the total_deal to refund, which results in a refund of 0 Ether. This could lead to users not receiving their correct refunds and potentially losing funds.",
        "file_name": "0x1c1de57cc864072f7eab381c4c06b14a6963dd4b.sol"
    }
]