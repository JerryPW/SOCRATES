[
    {
        "function_name": "withdrawTokens",
        "code": "function withdrawTokens() { if(msg.sender != seller) throw; token.transfer(seller, token.balanceOf(address(this))); }",
        "vulnerability": "Potential locking of tokens",
        "reason": "The function `withdrawTokens` transfers all tokens to the seller, potentially leaving the contract with no tokens to fulfill IOU withdrawals. If the tokens are withdrawn before all IOU holders have claimed their tokens, it may lead to a situation where IOU holders cannot receive their tokens, rendering their IOUs useless.",
        "file_name": "0x4e61ba9c25d43e802c6be8d160432e4989dea1fc.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() payable { if(block.number > 4199999 && iou_purchased[msg.sender] > token.balanceOf(address(this))) { uint256 eth_to_refund = eth_sent[msg.sender]; if(eth_to_refund == 0 || iou_purchased[msg.sender] == 0) throw; total_iou_purchased -= iou_purchased[msg.sender]; eth_sent[msg.sender] = 0; iou_purchased[msg.sender] = 0; msg.sender.transfer(eth_to_refund); return; } if(token.balanceOf(address(this)) == 0 || iou_purchased[msg.sender] > token.balanceOf(address(this))) throw; uint256 iou_to_withdraw = iou_purchased[msg.sender]; uint256 eth_to_release = eth_sent[msg.sender]; if(iou_to_withdraw == 0 || eth_to_release == 0) throw; iou_purchased[msg.sender] = 0; eth_sent[msg.sender] = 0; token.transfer(msg.sender, iou_to_withdraw); seller.transfer(eth_to_release); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The withdraw function transfers ether to the msg.sender before updating state variables. This allows a reentrancy attack, where an attacker can repeatedly call the withdraw function to drain funds or tokens by manipulating the order of operations. The contract should update state variables before making any external calls.",
        "file_name": "0x4e61ba9c25d43e802c6be8d160432e4989dea1fc.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() payable { if(block.number > 4199999 && iou_purchased[msg.sender] > token.balanceOf(address(this))) { uint256 eth_to_refund = eth_sent[msg.sender]; if(eth_to_refund == 0 || iou_purchased[msg.sender] == 0) throw; total_iou_purchased -= iou_purchased[msg.sender]; eth_sent[msg.sender] = 0; iou_purchased[msg.sender] = 0; msg.sender.transfer(eth_to_refund); return; } if(token.balanceOf(address(this)) == 0 || iou_purchased[msg.sender] > token.balanceOf(address(this))) throw; uint256 iou_to_withdraw = iou_purchased[msg.sender]; uint256 eth_to_release = eth_sent[msg.sender]; if(iou_to_withdraw == 0 || eth_to_release == 0) throw; iou_purchased[msg.sender] = 0; eth_sent[msg.sender] = 0; token.transfer(msg.sender, iou_to_withdraw); seller.transfer(eth_to_release); }",
        "vulnerability": "Block number dependency",
        "reason": "The withdraw function contains logic dependent on a specific block number (4199999). This can lead to unpredictable behavior post that block, where legitimate IOU holders might not be able to claim their tokens if the conditions are not met. It is a bad practice to rely on block numbers for business logic as they can create vulnerabilities related to timing and transaction ordering.",
        "file_name": "0x4e61ba9c25d43e802c6be8d160432e4989dea1fc.sol"
    }
]