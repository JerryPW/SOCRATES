[
    {
        "function_name": "withdrawTokens",
        "code": "function withdrawTokens() { if(msg.sender != seller) throw; token.transfer(seller, token.balanceOf(address(this)) - (total_iou_purchased - total_iou_withdrawn)); }",
        "vulnerability": "Integer Underflow",
        "reason": "The subtraction (token.balanceOf(address(this)) - (total_iou_purchased - total_iou_withdrawn)) could result in an underflow if total_iou_withdrawn is greater than total_iou_purchased. This would cause an incorrect token amount to be transferred, potentially transferring more tokens than intended.",
        "file_name": "0x44f2f79343ac7244c09e0189df05588524a86515.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() payable { if(block.number > 4199999 && iou_purchased[msg.sender] > token.balanceOf(address(this))) { uint256 eth_to_refund = eth_sent[msg.sender]; if(eth_to_refund == 0 || iou_purchased[msg.sender] == 0) throw; total_iou_purchased -= iou_purchased[msg.sender]; eth_sent[msg.sender] = 0; iou_purchased[msg.sender] = 0; msg.sender.transfer(eth_to_refund); return; } if(token.balanceOf(address(this)) == 0 || iou_purchased[msg.sender] > token.balanceOf(address(this))) throw; uint256 iou_to_withdraw = iou_purchased[msg.sender]; if(iou_to_withdraw == 0) throw; iou_purchased[msg.sender] = 0; eth_sent[msg.sender] = 0; total_iou_withdrawn += iou_to_withdraw; token.transfer(msg.sender, iou_to_withdraw); }",
        "vulnerability": "Reentrancy",
        "reason": "The function allows a user to withdraw ETH based on their purchase history. However, the external call msg.sender.transfer(eth_to_refund) occurs before updating the state variables total_iou_purchased, eth_sent, and iou_purchased. An attacker could exploit this by recursively calling withdraw(), potentially withdrawing more than entitled.",
        "file_name": "0x44f2f79343ac7244c09e0189df05588524a86515.sol"
    },
    {
        "function_name": "purchase",
        "code": "function purchase() payable { if(halt_purchases) throw; uint256 iou_to_purchase = price_per_eth * msg.value; if((total_iou_purchased + iou_to_purchase) > total_iou_available) throw; iou_purchased[msg.sender] += iou_to_purchase; eth_sent[msg.sender] += msg.value; total_iou_purchased += iou_to_purchase; }",
        "vulnerability": "Arithmetic Overflow",
        "reason": "The calculation of iou_to_purchase = price_per_eth * msg.value is susceptible to an overflow. If msg.value is large enough, the multiplication could wrap around, causing iou_to_purchase to be much smaller than expected, allowing the attacker to purchase more IOUs than they actually paid for.",
        "file_name": "0x44f2f79343ac7244c09e0189df05588524a86515.sol"
    }
]