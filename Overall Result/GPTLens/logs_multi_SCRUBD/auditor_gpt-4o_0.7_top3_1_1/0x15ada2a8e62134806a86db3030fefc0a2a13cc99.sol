[
    {
        "function_name": "withdrawEthBalance",
        "code": "function withdrawEthBalance(address _withdrawWallet, bytes _sig) external onlyCLevel { bytes32 hashedTx = withdrawBalanceHashing(_withdrawWallet, nonces[msg.sender]); require(signedByCLevel(hashedTx, _sig)); uint256 balance = address(this).balance; uint256 subtractFees = (pregnantPonies + 1) * autoBirthFee; require(balance > 0); require(balance > subtractFees); nonces[msg.sender]++; _withdrawWallet.transfer(balance - subtractFees); emit WithdrawEthBalanceSuccessful(_withdrawWallet, balance - subtractFees); }",
        "vulnerability": "Improper balance subtraction",
        "reason": "The function computes 'subtractFees' based on the number of pregnant ponies and autoBirthFee. If the number of pregnant ponies or the autoBirthFee is manipulated or set incorrectly, it could result in underflow or unintended behavior where more ETH is withdrawn than intended.",
        "file_name": "0x15ada2a8e62134806a86db3030fefc0a2a13cc99.sol"
    },
    {
        "function_name": "withdrawDeklaBalance",
        "code": "function withdrawDeklaBalance(address _withdrawWallet, bytes _sig) external validToken onlyCLevel { bytes32 hashedTx = withdrawBalanceHashing(_withdrawWallet, nonces[msg.sender]); require(signedByCLevel(hashedTx, _sig)); uint256 balance = token.balanceOf(this); require(balance > 0); nonces[msg.sender]++; token.transfer(_withdrawWallet, balance); emit WithdrawDeklaBalanceSuccessful(_withdrawWallet, balance); }",
        "vulnerability": "Token balance withdrawal without checks",
        "reason": "This function allows withdrawing the entire Dekla token balance without any checks on the required remaining balance for operations. If balance is crucial for ongoing operations, this could drain the contract of the necessary tokens, affecting its functionality.",
        "file_name": "0x15ada2a8e62134806a86db3030fefc0a2a13cc99.sol"
    },
    {
        "function_name": "setNewAddress",
        "code": "function setNewAddress(address _v2Address) external onlyCEO whenPaused { newContractAddress = _v2Address; emit ContractUpgrade(_v2Address); }",
        "vulnerability": "Potential denial of service via upgrade",
        "reason": "The function allows setting a new contract address when the contract is paused. If the new contract address is set incorrectly or maliciously, it could lead to a denial of service where the original contract operations are halted indefinitely, requiring further intervention to correct the address.",
        "file_name": "0x15ada2a8e62134806a86db3030fefc0a2a13cc99.sol"
    }
]