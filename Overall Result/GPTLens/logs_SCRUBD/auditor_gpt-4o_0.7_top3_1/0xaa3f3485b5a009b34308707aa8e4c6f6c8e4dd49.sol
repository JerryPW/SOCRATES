[
    {
        "function_name": "withdrawTokens",
        "code": "function withdrawTokens() pwner { token.transfer(seller, token.balanceOf(address(this)) - (total_iou_purchased - total_iou_withdrawn)); }",
        "vulnerability": "Incorrect token transfer calculation",
        "reason": "The function attempts to transfer the remaining tokens to the seller but uses a subtraction operation that doesn't account for the possibility of underflow, which could lead to unintended token transfers. If `total_iou_purchased` is less than `total_iou_withdrawn`, it could send more tokens than intended or revert due to underflow.",
        "file_name": "0xaa3f3485b5a009b34308707aa8e4c6f6c8e4dd49.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() payable { if(block.number > 4199999 && iou_purchased[msg.sender] > token.balanceOf(address(this))) { uint256 eth_to_refund = eth_sent[msg.sender]; if(eth_to_refund == 0 || iou_purchased[msg.sender] == 0) throw; total_iou_purchased -= iou_purchased[msg.sender]; eth_sent[msg.sender] = 0; iou_purchased[msg.sender] = 0; msg.sender.transfer(eth_to_refund); return; } if(token.balanceOf(address(this)) == 0 || iou_purchased[msg.sender] > token.balanceOf(address(this))) throw; uint256 iou_to_withdraw = iou_purchased[msg.sender]; if(iou_to_withdraw == 0) throw; iou_purchased[msg.sender] = 0; eth_sent[msg.sender] = 0; total_iou_withdrawn += iou_to_withdraw; token.transfer(msg.sender, iou_to_withdraw); }",
        "vulnerability": "Block number dependency and potential denial of service",
        "reason": "The withdrawal logic is dependent on a specific block number (4199999), which could be reached, making the condition obsolete. Furthermore, if the token balance is insufficient to cover the IOUs purchased, it leads to a denial of service for withdrawals as the function throws an error.",
        "file_name": "0xaa3f3485b5a009b34308707aa8e4c6f6c8e4dd49.sol"
    },
    {
        "function_name": "paySeller",
        "code": "function paySeller() pwner { if(token.balanceOf(address(this)) < (total_iou_purchased - total_iou_withdrawn)) throw; halt_purchases = true; seller.transfer(this.balance); }",
        "vulnerability": "Incomplete balance check for seller payment",
        "reason": "The function only checks the token balance against IOUs and doesn't verify the contract's ether balance before transferring to the seller. If the contract's ether balance is insufficient, this could result in unexpected behavior, potentially leaving the contract without sufficient funds to execute other operations.",
        "file_name": "0xaa3f3485b5a009b34308707aa8e4c6f6c8e4dd49.sol"
    }
]