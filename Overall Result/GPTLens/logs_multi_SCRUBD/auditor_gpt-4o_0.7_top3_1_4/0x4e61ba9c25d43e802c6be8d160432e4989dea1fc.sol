[
    {
        "function_name": "withdrawTokens",
        "code": "function withdrawTokens() { if(msg.sender != seller) throw; token.transfer(seller, token.balanceOf(address(this))); }",
        "vulnerability": "Potential loss of tokens due to lack of access control",
        "reason": "The `withdrawTokens` function does not have any checks for the state of the contract, such as whether purchases have been halted or whether all IOUs have been distributed. This means that the seller can withdraw all tokens at any time, even if obligations to purchasers have not been met, potentially causing loss to IOU purchasers.",
        "file_name": "0x4e61ba9c25d43e802c6be8d160432e4989dea1fc.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() payable { if(block.number > 4199999 && iou_purchased[msg.sender] > token.balanceOf(address(this))) { uint256 eth_to_refund = eth_sent[msg.sender]; if(eth_to_refund == 0 || iou_purchased[msg.sender] == 0) throw; total_iou_purchased -= iou_purchased[msg.sender]; eth_sent[msg.sender] = 0; iou_purchased[msg.sender] = 0; msg.sender.transfer(eth_to_refund); return; } if(token.balanceOf(address(this)) == 0 || iou_purchased[msg.sender] > token.balanceOf(address(this))) throw; uint256 iou_to_withdraw = iou_purchased[msg.sender]; uint256 eth_to_release = eth_sent[msg.sender]; if(iou_to_withdraw == 0 || eth_to_release == 0) throw; iou_purchased[msg.sender] = 0; eth_sent[msg.sender] = 0; token.transfer(msg.sender, iou_to_withdraw); seller.transfer(eth_to_release); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `withdraw` function can be re-entered due to the use of `transfer`, which sends Ether to an address and allows for fallback functions to be executed. If the attacker creates a contract with a fallback function that calls `withdraw` again, they can exploit this vulnerability to withdraw funds multiple times before their balances are updated. This can lead to significant financial loss from the contract.",
        "file_name": "0x4e61ba9c25d43e802c6be8d160432e4989dea1fc.sol"
    },
    {
        "function_name": "purchase",
        "code": "function purchase() payable { if(halt_purchases) throw; uint256 iou_to_purchase = 160 * msg.value; if((total_iou_purchased + iou_to_purchase) > total_iou_available) throw; iou_purchased[msg.sender] += iou_to_purchase; eth_sent[msg.sender] += msg.value; total_iou_purchased += iou_to_purchase; }",
        "vulnerability": "Integer overflow",
        "reason": "The calculation `uint256 iou_to_purchase = 160 * msg.value;` is susceptible to integer overflow if the msg.value is large enough. This could allow an attacker to bypass the check `(total_iou_purchased + iou_to_purchase) > total_iou_available` and purchase more IOUs than intended, leading to incorrect state updates and potential financial loss for the contract.",
        "file_name": "0x4e61ba9c25d43e802c6be8d160432e4989dea1fc.sol"
    }
]