[
    {
        "function_name": "withdraw",
        "code": "function withdraw() payable { if(block.number > 4199999 && iou_purchased[msg.sender] > token.balanceOf(address(this))) { uint256 eth_to_refund = eth_sent[msg.sender]; if(eth_to_refund == 0 || iou_purchased[msg.sender] == 0) throw; total_iou_purchased -= iou_purchased[msg.sender]; eth_sent[msg.sender] = 0; iou_purchased[msg.sender] = 0; msg.sender.transfer(eth_to_refund); return; } if(token.balanceOf(address(this)) == 0 || iou_purchased[msg.sender] > token.balanceOf(address(this))) throw; uint256 iou_to_withdraw = iou_purchased[msg.sender]; uint256 eth_to_release = eth_sent[msg.sender]; if(iou_to_withdraw == 0 || eth_to_release == 0) throw; iou_purchased[msg.sender] = 0; eth_sent[msg.sender] = 0; token.transfer(msg.sender, iou_to_withdraw); seller.transfer(eth_to_release); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `withdraw` function transfers Ether to the user before updating the state variables `eth_sent` and `iou_purchased`. This allows an attacker to use reentrancy to call `withdraw` repeatedly and drain funds because the state isn't updated before the external call.",
        "file_name": "0x4e61ba9c25d43e802c6be8d160432e4989dea1fc.sol"
    },
    {
        "function_name": "purchase",
        "code": "function purchase() payable { if(halt_purchases) throw; uint256 iou_to_purchase = 160 * msg.value; if((total_iou_purchased + iou_to_purchase) > total_iou_available) throw; iou_purchased[msg.sender] += iou_to_purchase; eth_sent[msg.sender] += msg.value; total_iou_purchased += iou_to_purchase; }",
        "vulnerability": "Lack of input validation",
        "reason": "The `purchase` function allows for a multiplication of `msg.value` by 160 without checking for overflow. In Solidity 0.4.11, integer overflow can occur, potentially leading to incorrect `iou_to_purchase` values which can be exploited by sending large values of Ether, bypassing the `total_iou_available` limit.",
        "file_name": "0x4e61ba9c25d43e802c6be8d160432e4989dea1fc.sol"
    },
    {
        "function_name": "withdrawTokens",
        "code": "function withdrawTokens() { if(msg.sender != seller) throw; token.transfer(seller, token.balanceOf(address(this))); }",
        "vulnerability": "Unrestricted token withdrawal by seller",
        "reason": "The `withdrawTokens` function allows the seller to withdraw all tokens from the contract without any restrictions or conditions. This means the seller can drain the contract of tokens at any time, potentially defrauding purchasers who have not yet withdrawn their tokens.",
        "file_name": "0x4e61ba9c25d43e802c6be8d160432e4989dea1fc.sol"
    }
]