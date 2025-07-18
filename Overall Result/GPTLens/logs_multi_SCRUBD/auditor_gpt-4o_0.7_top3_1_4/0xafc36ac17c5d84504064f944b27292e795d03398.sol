[
    {
        "function_name": "withdrawTokens",
        "code": "function withdrawTokens() pwner { token.transfer(seller, token.balanceOf(address(this)) - (total_iou_purchased - total_iou_withdrawn)); }",
        "vulnerability": "Integer underflow vulnerability",
        "reason": "The subtraction operation in `token.balanceOf(address(this)) - (total_iou_purchased - total_iou_withdrawn)` can lead to an integer underflow if `total_iou_purchased` is less than `total_iou_withdrawn`, causing an incorrect transfer amount. This would result in transferring an unexpectedly large number of tokens from the contract.",
        "file_name": "0xafc36ac17c5d84504064f944b27292e795d03398.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() payable { if(block.number > 4199999 && iou_purchased[msg.sender] > token.balanceOf(address(this))) { uint256 eth_to_refund = eth_sent[msg.sender]; if(eth_to_refund == 0 || iou_purchased[msg.sender] == 0) throw; total_iou_purchased -= iou_purchased[msg.sender]; eth_sent[msg.sender] = 0; iou_purchased[msg.sender] = 0; msg.sender.transfer(eth_to_refund); return; } if(token.balanceOf(address(this)) == 0 || iou_purchased[msg.sender] > token.balanceOf(address(this))) throw; uint256 iou_to_withdraw = iou_purchased[msg.sender]; if(iou_to_withdraw == 0) throw; iou_purchased[msg.sender] = 0; eth_sent[msg.sender] = 0; total_iou_withdrawn += iou_to_withdraw; token.transfer(msg.sender, iou_to_withdraw); }",
        "vulnerability": "Block number dependency",
        "reason": "The use of a specific block number (4199999) as a condition for allowing refunds makes the contract behavior dependent on blockchain state that can change over time. This could lead to refunds being locked after the block number is surpassed, potentially causing a denial of service for users wishing to withdraw their funds.",
        "file_name": "0xafc36ac17c5d84504064f944b27292e795d03398.sol"
    },
    {
        "function_name": "purchase",
        "code": "function purchase() payable { if(halt_purchases) throw; if(msg.value == 0) throw; uint256 iou_to_purchase = price_per_eth * msg.value; if((total_iou_purchased + iou_to_purchase) > total_iou_available) throw; iou_purchased[msg.sender] += iou_to_purchase; eth_sent[msg.sender] += msg.value; total_iou_purchased += iou_to_purchase; }",
        "vulnerability": "No limit on maximum purchase amount",
        "reason": "The function does not impose a specific limit on the maximum value of a single purchase, apart from the total availability check. This could potentially allow a user to purchase a large number of IOUs in a single transaction, impacting the balance and availability for other users if not carefully managed.",
        "file_name": "0xafc36ac17c5d84504064f944b27292e795d03398.sol"
    }
]