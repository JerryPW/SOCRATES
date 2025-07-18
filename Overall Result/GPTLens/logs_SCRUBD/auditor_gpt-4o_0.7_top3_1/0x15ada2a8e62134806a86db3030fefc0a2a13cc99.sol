[
    {
        "function_name": "signedByCLevel",
        "code": "function signedByCLevel( bytes32 _message, bytes _sig ) internal view onlyCLevel returns (bool) { address signer = recover(_message, _sig); require(signer != msg.sender); return ( signer == cooAddress || signer == ceoAddress || signer == cfoAddress ); }",
        "vulnerability": "Improper authorization",
        "reason": "The function checks if the signer is a C-level address but does not ensure that the signature is from a different C-level address than the sender. This allows a C-level to potentially sign their transaction, leading to unauthorized actions.",
        "file_name": "0x15ada2a8e62134806a86db3030fefc0a2a13cc99.sol"
    },
    {
        "function_name": "setCEO",
        "code": "function setCEO( address _newCEO, bytes _sig ) external onlyCLevel { require( _newCEO != address(0) && _newCEO != cfoAddress && _newCEO != cooAddress ); bytes32 hashedTx = getCEOHashing(_newCEO, nonces[msg.sender]); require(signedByCLevel(hashedTx, _sig)); nonces[msg.sender]++; ceoAddress = _newCEO; CLevelTxCount_++; }",
        "vulnerability": "Replay attack",
        "reason": "The setCEO function uses nonces for replay protection but increments the nonce after setting the new CEO. If an attacker can predict or intercept the nonce before the transaction is confirmed, they can use the same signature to execute the function multiple times.",
        "file_name": "0x15ada2a8e62134806a86db3030fefc0a2a13cc99.sol"
    },
    {
        "function_name": "withdrawEthBalance",
        "code": "function withdrawEthBalance(address _withdrawWallet, bytes _sig) external onlyCLevel { bytes32 hashedTx = withdrawBalanceHashing(_withdrawWallet, nonces[msg.sender]); require(signedByCLevel(hashedTx, _sig)); uint256 balance = address(this).balance; uint256 subtractFees = (pregnantPonies + 1) * autoBirthFee; require(balance > 0); require(balance > subtractFees); nonces[msg.sender]++; _withdrawWallet.transfer(balance - subtractFees); emit WithdrawEthBalanceSuccessful(_withdrawWallet, balance - subtractFees); }",
        "vulnerability": "Excessive balance withdrawal",
        "reason": "The function withdrawEthBalance calculates the amount to withdraw by deducting certain fees from the total balance but does not account for potential re-entrancy attacks that could manipulate the balance before the transfer is completed. This can allow the attacker to withdraw more than intended.",
        "file_name": "0x15ada2a8e62134806a86db3030fefc0a2a13cc99.sol"
    }
]