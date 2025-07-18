[
    {
        "function_name": "withdrawEther",
        "code": "function withdrawEther(uint amountInWei) onlyOwner public { msg.sender.transfer(amountInWei); }",
        "vulnerability": "Owner can drain all Ether",
        "reason": "The function allows the contract owner to withdraw any amount of Ether from the contract without any checks on the balance, enabling the owner to potentially drain all Ether, which can be catastrophic for users who have deposited funds.",
        "file_name": "0x0d7e1053924599ceac270d3a28b839282781ecec.sol"
    },
    {
        "function_name": "setSendToSafeWalletPercentage",
        "code": "function setSendToSafeWalletPercentage(uint newValue) onlyOwner public { require (newValue > 0); sendToSafeWalletPercentage = uint(newValue); }",
        "vulnerability": "Excessive funds redirection risk",
        "reason": "The owner can set an excessively high percentage for `sendToSafeWalletPercentage`, potentially redirecting a large portion of funds to their own wallet during buy operations, which reduces trust and security for users.",
        "file_name": "0x0d7e1053924599ceac270d3a28b839282781ecec.sol"
    },
    {
        "function_name": "sell",
        "code": "function sell(uint quantity, uint minSaleReturn) public { uint amountInWei = formulaContract.calculateSaleReturn( (tokenContract.totalSupply()- uncirculatedSupplyCount) - tokenContract.balanceOf(this), address(this).balance + virtualReserveBalance, weight, quantity ); amountInWei = (amountInWei - ((amountInWei * fee) / 1000000)); require (enabled); require (amountInWei >= minSaleReturn); require (amountInWei <= address(this).balance); require (tokenContract.transferFrom(msg.sender, this, quantity)); collectedFees += (amountInWei * fee) / 1000000; emit Sell(msg.sender, quantity, amountInWei); msg.sender.transfer(amountInWei); }",
        "vulnerability": "Reentrancy attack vulnerability",
        "reason": "The `sell` function transfers Ether to the seller before updating the state (i.e., transferring tokens and emitting events), which opens the possibility of a reentrancy attack. An attacker could exploit this by creating a contract that calls `sell` and re-enters the function before the state is updated, potentially draining funds from the contract.",
        "file_name": "0x0d7e1053924599ceac270d3a28b839282781ecec.sol"
    }
]