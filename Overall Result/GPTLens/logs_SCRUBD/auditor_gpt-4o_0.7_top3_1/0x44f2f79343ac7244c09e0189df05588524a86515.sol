[
    {
        "function_name": "withdrawTokens",
        "code": "function withdrawTokens() { if(msg.sender != seller) throw; token.transfer(seller, token.balanceOf(address(this)) - (total_iou_purchased - total_iou_withdrawn)); }",
        "vulnerability": "Incorrect token transfer amount",
        "reason": "The function attempts to transfer tokens to the seller based on the difference between the total IOUs purchased and withdrawn. However, this calculation doesn't account for the actual token balance, potentially allowing the seller to withdraw more tokens than entitled, especially if the contract receives tokens from other sources.",
        "file_name": "0x44f2f79343ac7244c09e0189df05588524a86515.sol"
    },
    {
        "function_name": "paySeller",
        "code": "function paySeller() { if(msg.sender != seller) throw; if(token.balanceOf(address(this)) < (total_iou_purchased - total_iou_withdrawn)) throw; halt_purchases = true; seller.transfer(this.balance); }",
        "vulnerability": "Unrestricted ether withdrawal by seller",
        "reason": "The seller can withdraw all ether from the contract balance, regardless of whether all obligations to the IOU holders have been met. This could potentially leave the contract without funds to refund or compensate IOU holders.",
        "file_name": "0x44f2f79343ac7244c09e0189df05588524a86515.sol"
    },
    {
        "function_name": "purchase",
        "code": "function purchase() payable { if(halt_purchases) throw; uint256 iou_to_purchase = price_per_eth * msg.value; if((total_iou_purchased + iou_to_purchase) > total_iou_available) throw; iou_purchased[msg.sender] += iou_to_purchase; eth_sent[msg.sender] += msg.value; total_iou_purchased += iou_to_purchase; }",
        "vulnerability": "Lack of validation for price_per_eth",
        "reason": "The function multiplies the ether sent with price_per_eth without any checks on the validity or scale of price_per_eth. If price_per_eth is set incorrectly (e.g., too high), users can be misled into sending ether without receiving a fair amount of IOUs, or the contract can end up in a state where it cannot fulfill its obligations.",
        "file_name": "0x44f2f79343ac7244c09e0189df05588524a86515.sol"
    }
]