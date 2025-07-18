[
    {
        "function_name": "withdraw",
        "code": "function withdraw() payable { if(block.number > 4199999 && iou_purchased[msg.sender] > token.balanceOf(address(this))) { uint256 eth_to_refund = eth_sent[msg.sender]; if(eth_to_refund == 0 || iou_purchased[msg.sender] == 0) throw; total_iou_purchased -= iou_purchased[msg.sender]; eth_sent[msg.sender] = 0; iou_purchased[msg.sender] = 0; msg.sender.transfer(eth_to_refund); return; } if(token.balanceOf(address(this)) == 0 || iou_purchased[msg.sender] > token.balanceOf(address(this))) throw; uint256 iou_to_withdraw = iou_purchased[msg.sender]; if(iou_to_withdraw == 0) throw; iou_purchased[msg.sender] = 0; eth_sent[msg.sender] = 0; total_iou_withdrawn += iou_to_withdraw; token.transfer(msg.sender, iou_to_withdraw); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The withdraw function is vulnerable to reentrancy attacks because it transfers Ether before updating the state variables. An attacker could exploit this by recursively calling the withdraw function to drain funds.",
        "file_name": "0xafc36ac17c5d84504064f944b27292e795d03398.sol"
    },
    {
        "function_name": "paySeller",
        "code": "function paySeller() pwner { if(token.balanceOf(address(this)) < (total_iou_purchased - total_iou_withdrawn)) throw; halt_purchases = true; seller.transfer(this.balance); }",
        "vulnerability": "Mishandling of Ether transfer",
        "reason": "The paySeller function uses a direct transfer to send Ether to the seller, which could fail if the seller is a contract that does not accept Ether, leading to a potential loss of funds as the function does not handle errors in transfer.",
        "file_name": "0xafc36ac17c5d84504064f944b27292e795d03398.sol"
    },
    {
        "function_name": "purchase",
        "code": "function purchase() payable { if(halt_purchases) throw; if(msg.value == 0) throw; uint256 iou_to_purchase = price_per_eth * msg.value; if((total_iou_purchased + iou_to_purchase) > total_iou_available) throw; iou_purchased[msg.sender] += iou_to_purchase; eth_sent[msg.sender] += msg.value; total_iou_purchased += iou_to_purchase; }",
        "vulnerability": "Integer overflow",
        "reason": "The calculation of iou_to_purchase = price_per_eth * msg.value is susceptible to an integer overflow, which could be exploited by an attacker to obtain more IOUs than intended.",
        "file_name": "0xafc36ac17c5d84504064f944b27292e795d03398.sol"
    }
]