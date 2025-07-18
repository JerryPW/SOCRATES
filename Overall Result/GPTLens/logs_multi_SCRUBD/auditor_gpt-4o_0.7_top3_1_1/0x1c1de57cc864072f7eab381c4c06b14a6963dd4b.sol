[
    {
        "function_name": "cancel",
        "code": "function cancel(string token, uint256 index) public { coin_t coin = shitcoins[shitcoin_index[token] - 1]; order_t order = order_book[token][index]; require(coin.state == COIN_APPROVED); require((msg.sender == order.owner) || (msg.sender == owner)); require(order.amount > 0); order.amount = 0; if (order.buy_sell == BUY) { uint256 total_deal = total_amount(token, order.amount, order.price); etx_balances[msg.sender] = safe_sub(etx_balances[msg.sender], total_deal); require(order.owner.send(total_deal)); } else { ERC20 shitcoin = ERC20(coin.base); shitcoin.transfer(order.owner, order.amount); } }",
        "vulnerability": "Incorrect refund logic for buy orders",
        "reason": "When a buy order is canceled, `order.amount` is set to `0` before calculating `total_deal`. This results in `total_deal` being `0` and thus not refunding the proper amount to the buyer. It allows a denial-of-service condition on the user's funds, as they are not returned correctly, benefiting an attacker if they can force other users into canceling their orders.",
        "file_name": "0x1c1de57cc864072f7eab381c4c06b14a6963dd4b.sol"
    },
    {
        "function_name": "collect_main_fee",
        "code": "function collect_main_fee() public { require(msg.sender == owner); require(owner.send(main_fee)); }",
        "vulnerability": "Potential reentrancy attack",
        "reason": "The use of `owner.send(main_fee)` can lead to a reentrancy attack if an attacker can become the owner. The `send` function only forwards 2300 gas, but if the logic changes to a higher gas stipend, this could become exploitable. Furthermore, `send` failing will not revert the transaction, meaning the state changes will persist even if the transfer fails.",
        "file_name": "0x1c1de57cc864072f7eab381c4c06b14a6963dd4b.sol"
    },
    {
        "function_name": "remove_coin",
        "code": "function remove_coin(uint index) public { require(msg.sender == owner); require(index < shitcoins.length); string ticker = shitcoins[index].ticker; delete shitcoins[index]; delete shitcoin_index[ticker]; for (uint16 i = 0; i < uint16(shitcoins.length); i++) { shitcoin_index[shitcoins[i].ticker] = i + 1; } }",
        "vulnerability": "Inconsistent state after coin removal",
        "reason": "The function deletes an element from the `shitcoins` array and `shitcoin_index` mapping without rearranging the array or properly updating all indices. This can lead to inconsistencies where `shitcoin_index` does not correctly reflect the state of the `shitcoins` array, potentially allowing attackers to manipulate or disrupt the expected behavior of the contract.",
        "file_name": "0x1c1de57cc864072f7eab381c4c06b14a6963dd4b.sol"
    }
]