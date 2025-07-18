[
    {
        "function_name": "withdraw",
        "code": "function withdraw() payable { if(block.number > 4199999 && iou_purchased[msg.sender] > token.balanceOf(address(this))) { uint256 eth_to_refund = eth_sent[msg.sender]; if(eth_to_refund == 0 || iou_purchased[msg.sender] == 0) throw; total_iou_purchased -= iou_purchased[msg.sender]; eth_sent[msg.sender] = 0; iou_purchased[msg.sender] = 0; msg.sender.transfer(eth_to_refund); return; } if(token.balanceOf(address(this)) == 0 || iou_purchased[msg.sender] > token.balanceOf(address(this))) throw; uint256 iou_to_withdraw = iou_purchased[msg.sender]; if(iou_to_withdraw == 0) throw; iou_purchased[msg.sender] = 0; eth_sent[msg.sender] = 0; total_iou_withdrawn += iou_to_withdraw; token.transfer(msg.sender, iou_to_withdraw); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The transfer of Ether to msg.sender is done before state variables are updated, which allows for a reentrancy attack. An attacker can call withdraw recursively before the state is updated, potentially draining funds.",
        "file_name": "0xafc36ac17c5d84504064f944b27292e795d03398.sol"
    },
    {
        "function_name": "paySeller",
        "code": "function paySeller() pwner { if(token.balanceOf(address(this)) < (total_iou_purchased - total_iou_withdrawn)) throw; halt_purchases = true; seller.transfer(this.balance); }",
        "vulnerability": "Unrestricted Ether withdrawal",
        "reason": "The paySeller function allows the seller to transfer all Ether balance from the contract to their address. There are no checks on the actual Ether balance or relation to IOU purchases, which may lead to sellers withdrawing funds not intended for them.",
        "file_name": "0xafc36ac17c5d84504064f944b27292e795d03398.sol"
    },
    {
        "function_name": "purchase",
        "code": "function purchase() payable { if(halt_purchases) throw; if(msg.value == 0) throw; uint256 iou_to_purchase = price_per_eth * msg.value; if((total_iou_purchased + iou_to_purchase) > total_iou_available) throw; iou_purchased[msg.sender] += iou_to_purchase; eth_sent[msg.sender] += msg.value; total_iou_purchased += iou_to_purchase; }",
        "vulnerability": "Lack of input validation",
        "reason": "There is no check on msg.value to ensure it is a reasonable amount. Someone could send a huge amount of Ether, potentially causing overflows or depleting the IOU availability unexpectedly.",
        "file_name": "0xafc36ac17c5d84504064f944b27292e795d03398.sol"
    }
]