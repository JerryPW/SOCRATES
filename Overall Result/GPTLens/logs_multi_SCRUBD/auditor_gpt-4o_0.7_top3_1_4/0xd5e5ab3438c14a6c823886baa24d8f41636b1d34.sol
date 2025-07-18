[
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _amount,address _owner)public olyowner returns(bool){ _owner.send(_amount); return true; }",
        "vulnerability": "Unsafe use of send for Ether transfer",
        "reason": "The use of `send` to transfer Ether can lead to potential reentrancy attacks and loss of funds if the recipient is a contract with a fallback function that reverts. It is recommended to use `transfer` or `call` with proper checks.",
        "file_name": "0xd5e5ab3438c14a6c823886baa24d8f41636b1d34.sol"
    },
    {
        "function_name": "TokenERC20",
        "code": "function TokenERC20()public payable{ amountren = 0; investeds = 0; aipi = msg.sender; }",
        "vulnerability": "Owner can be set to any address",
        "reason": "The constructor sets the `aipi` variable to the deployer of the contract, allowing them to control the contract along with the hardcoded owner. This can be dangerous if the deployer is not trusted or if the deployment is compromised.",
        "file_name": "0xd5e5ab3438c14a6c823886baa24d8f41636b1d34.sol"
    },
    {
        "function_name": "commissions",
        "code": "function commissions(uint256 _amount)public olyowner returns(bool){ commission = _amount; }",
        "vulnerability": "Potential for excessive commission setting",
        "reason": "The `commissions` function allows the owner to set the commission to any arbitrary value, potentially up to 100% or more of the transaction amount, which could lead to unfair distribution of funds and abuse by the contract owner.",
        "file_name": "0xd5e5ab3438c14a6c823886baa24d8f41636b1d34.sol"
    }
]