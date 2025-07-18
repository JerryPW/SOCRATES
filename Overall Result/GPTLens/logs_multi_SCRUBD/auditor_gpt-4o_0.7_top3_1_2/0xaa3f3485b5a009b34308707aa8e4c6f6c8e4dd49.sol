[
    {
        "function_name": "withdrawTokens",
        "code": "function withdrawTokens() pwner { token.transfer(seller, token.balanceOf(address(this)) - (total_iou_purchased - total_iou_withdrawn)); }",
        "vulnerability": "Incorrect token transfer calculation",
        "reason": "In the withdrawTokens function, the calculation for transferring tokens to the seller is incorrect. If total_iou_withdrawn is greater than total_iou_purchased, it could result in transferring more tokens than available, which is a potential exploit where tokens could be drained improperly.",
        "file_name": "0xaa3f3485b5a009b34308707aa8e4c6f6c8e4dd49.sol"
    },
    {
        "function_name": "paySeller",
        "code": "function paySeller() pwner { if(token.balanceOf(address(this)) < (total_iou_purchased - total_iou_withdrawn)) throw; halt_purchases = true; seller.transfer(this.balance); }",
        "vulnerability": "Incorrect ETH balance transfer to seller",
        "reason": "The paySeller function allows for the entire contract balance to be transferred to the seller if the token balance condition is met. This could result in misappropriation of funds because it does not consider partial withdrawals or refunds, allowing the seller to drain all ETH from the contract upon a minimal condition being satisfied.",
        "file_name": "0xaa3f3485b5a009b34308707aa8e4c6f6c8e4dd49.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() payable { if(block.number > 4199999 && iou_purchased[msg.sender] > token.balanceOf(address(this))) { uint256 eth_to_refund = eth_sent[msg.sender]; if(eth_to_refund == 0 || iou_purchased[msg.sender] == 0) throw; total_iou_purchased -= iou_purchased[msg.sender]; eth_sent[msg.sender] = 0; iou_purchased[msg.sender] = 0; msg.sender.transfer(eth_to_refund); return; } if(token.balanceOf(address(this)) == 0 || iou_purchased[msg.sender] > token.balanceOf(address(this))) throw; uint256 iou_to_withdraw = iou_purchased[msg.sender]; if(iou_to_withdraw == 0) throw; iou_purchased[msg.sender] = 0; eth_sent[msg.sender] = 0; total_iou_withdrawn += iou_to_withdraw; token.transfer(msg.sender, iou_to_withdraw); }",
        "vulnerability": "Potential denial of service",
        "reason": "The withdraw function can result in a denial of service if the token balance of the contract does not cover the requested amount for withdrawal. If many users have IOUs purchased but the token balance is insufficient, none of them can withdraw, causing a lockout situation.",
        "file_name": "0xaa3f3485b5a009b34308707aa8e4c6f6c8e4dd49.sol"
    }
]