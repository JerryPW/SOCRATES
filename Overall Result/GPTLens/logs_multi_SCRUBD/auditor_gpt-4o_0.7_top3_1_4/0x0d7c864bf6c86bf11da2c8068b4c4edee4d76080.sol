[
    {
        "function_name": "withdraw",
        "code": "function withdraw() public onlyContractOwner { contractOwner.transfer(address(this).balance); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function `withdraw` transfers all contract balance to the contract owner without using a reentrancy guard or the Checks-Effects-Interactions pattern. This can be exploited if `contractOwner` is a contract with a fallback function, allowing it to call back into `withdraw` before the balance is reduced to zero, potentially draining the contract.",
        "file_name": "0x0d7c864bf6c86bf11da2c8068b4c4edee4d76080.sol"
    },
    {
        "function_name": "updateAd",
        "code": "function updateAd(uint256 id) public payable { require(msg.value >= adPriceMultiple.mul(adPriceHour)); require(block.timestamp > purchaseTimestamp.add(purchaseSeconds)); require(id > 0); theInvestor.send(msg.value.div(10)); lastOwner.send(msg.value.div(2)); if (msg.value >= adPriceMultiple.mul(adPriceWeek)) { purchaseSeconds = 604800; } else if (msg.value >= adPriceMultiple.mul(adPriceDay)) { purchaseSeconds = 86400; } else if (msg.value >= adPriceMultiple.mul(adPriceHalfDay)) { purchaseSeconds = 43200; } else { purchaseSeconds = 3600; } dappId = id; purchaseTimestamp = block.timestamp; lastOwner = msg.sender; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function `updateAd` sends ether to `theInvestor` and `lastOwner` before updating state variables such as `dappId`, `purchaseTimestamp`, and `lastOwner`. This can lead to reentrancy attacks if `theInvestor` or `lastOwner` are contracts with fallback functions that call `updateAd` again, potentially causing inconsistent state or unauthorized access.",
        "file_name": "0x0d7c864bf6c86bf11da2c8068b4c4edee4d76080.sol"
    },
    {
        "function_name": "updateInvestor",
        "code": "function updateInvestor() public payable { require(msg.value >= investmentMin); theInvestor.send(msg.value.div(100).mul(60)); investmentMin = investmentMin.mul(2); theInvestor = msg.sender; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function `updateInvestor` sends ether to `theInvestor` and then updates critical state variables `investmentMin` and `theInvestor`. If `theInvestor` is a contract, it can exploit this by performing a reentrancy attack, allowing it to call `updateInvestor` again before the state changes are applied, potentially leading to unauthorized changes in `investmentMin` and `theInvestor`.",
        "file_name": "0x0d7c864bf6c86bf11da2c8068b4c4edee4d76080.sol"
    }
]