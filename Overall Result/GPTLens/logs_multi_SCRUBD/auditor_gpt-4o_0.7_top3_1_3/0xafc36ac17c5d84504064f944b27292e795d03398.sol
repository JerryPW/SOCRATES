[
    {
        "function_name": "withdraw",
        "code": "function withdraw() payable { if(block.number > 4199999 && iou_purchased[msg.sender] > token.balanceOf(address(this))) { uint256 eth_to_refund = eth_sent[msg.sender]; if(eth_to_refund == 0 || iou_purchased[msg.sender] == 0) throw; total_iou_purchased -= iou_purchased[msg.sender]; eth_sent[msg.sender] = 0; iou_purchased[msg.sender] = 0; msg.sender.transfer(eth_to_refund); return; } if(token.balanceOf(address(this)) == 0 || iou_purchased[msg.sender] > token.balanceOf(address(this))) throw; uint256 iou_to_withdraw = iou_purchased[msg.sender]; if(iou_to_withdraw == 0) throw; iou_purchased[msg.sender] = 0; eth_sent[msg.sender] = 0; total_iou_withdrawn += iou_to_withdraw; token.transfer(msg.sender, iou_to_withdraw); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function uses `msg.sender.transfer()`, which sends Ether to the caller before updating the state variables `iou_purchased` and `eth_sent`. This allows reentrancy attacks where a malicious contract could call `withdraw()` again before `eth_sent[msg.sender]` is set to 0, potentially draining the contract.",
        "file_name": "0xafc36ac17c5d84504064f944b27292e795d03398.sol"
    },
    {
        "function_name": "paySeller",
        "code": "function paySeller() pwner { if(token.balanceOf(address(this)) < (total_iou_purchased - total_iou_withdrawn)) throw; halt_purchases = true; seller.transfer(this.balance); }",
        "vulnerability": "Unchecked external call",
        "reason": "The `seller.transfer(this.balance)` call can fail, which would revert the entire transaction. If the seller is a contract and its fallback function consumes more than 2300 gas, the transfer will fail, locking the funds in the contract. Additionally, using `transfer` limits the gas forwarded, which can be problematic.",
        "file_name": "0xafc36ac17c5d84504064f944b27292e795d03398.sol"
    },
    {
        "function_name": "purchase",
        "code": "function purchase() payable { if(halt_purchases) throw; if(msg.value == 0) throw; uint256 iou_to_purchase = price_per_eth * msg.value; if((total_iou_purchased + iou_to_purchase) > total_iou_available) throw; iou_purchased[msg.sender] += iou_to_purchase; eth_sent[msg.sender] += msg.value; total_iou_purchased += iou_to_purchase; }",
        "vulnerability": "Integer overflow",
        "reason": "The calculation of `iou_to_purchase = price_per_eth * msg.value` can result in an integer overflow if `msg.value` is large enough. This could lead to incorrect updates of `iou_purchased` and `total_iou_purchased`, potentially allowing an attacker to purchase more IOUs than intended or even bypass limitations.",
        "file_name": "0xafc36ac17c5d84504064f944b27292e795d03398.sol"
    }
]