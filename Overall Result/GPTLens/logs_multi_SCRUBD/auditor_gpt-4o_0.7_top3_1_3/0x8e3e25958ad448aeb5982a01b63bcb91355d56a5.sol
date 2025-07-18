[
    {
        "function_name": "fallback",
        "code": "function () payable external { require(check[msg.sender] == false); require(msg.value < 1000000000000000001 wei); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint copy = price; uint second = price; uint third = price; if (amountRaised <= 100 ether) { uint newvalue = copy / 10; swapaddress.transfer(msg.sender, amount / newvalue); } else if (amountRaised <= 2100 ether) { uint secondvalue = second / 2; swapaddress.transfer(msg.sender, amount / secondvalue); } else { swapaddress.transfer(msg.sender, amount / third); } beneficiary.send(msg.value); emit FundTransfer(msg.sender, amount, true); check[msg.sender] = true; }",
        "vulnerability": "Reentrancy Attack",
        "reason": "The fallback function uses swapaddress.transfer and beneficiary.send which both forward gas to the callee. If the collectible contract or beneficiary address is malicious, they could re-enter the fallback function before the check[msg.sender] is set to true, allowing them to continuously withdraw funds or tokens.",
        "file_name": "0x8e3e25958ad448aeb5982a01b63bcb91355d56a5.sol"
    },
    {
        "function_name": "fallback",
        "code": "function () payable external { require(check[msg.sender] == false); require(msg.value < 1000000000000000001 wei); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint copy = price; uint second = price; uint third = price; if (amountRaised <= 100 ether) { uint newvalue = copy / 10; swapaddress.transfer(msg.sender, amount / newvalue); } else if (amountRaised <= 2100 ether) { uint secondvalue = second / 2; swapaddress.transfer(msg.sender, amount / secondvalue); } else { swapaddress.transfer(msg.sender, amount / third); } beneficiary.send(msg.value); emit FundTransfer(msg.sender, amount, true); check[msg.sender] = true; }",
        "vulnerability": "Gas Limit and Revert Attack",
        "reason": "The usage of beneficiary.send(msg.value) only forwards 2300 gas, which can cause the transaction to fail if the beneficiary address is a contract that requires more gas. This can lead to funds being stuck in the contract.",
        "file_name": "0x8e3e25958ad448aeb5982a01b63bcb91355d56a5.sol"
    },
    {
        "function_name": "fallback",
        "code": "function () payable external { require(check[msg.sender] == false); require(msg.value < 1000000000000000001 wei); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint copy = price; uint second = price; uint third = price; if (amountRaised <= 100 ether) { uint newvalue = copy / 10; swapaddress.transfer(msg.sender, amount / newvalue); } else if (amountRaised <= 2100 ether) { uint secondvalue = second / 2; swapaddress.transfer(msg.sender, amount / secondvalue); } else { swapaddress.transfer(msg.sender, amount / third); } beneficiary.send(msg.value); emit FundTransfer(msg.sender, amount, true); check[msg.sender] = true; }",
        "vulnerability": "Unchecked External Call",
        "reason": "The contract does not check the return value of swapaddress.transfer or beneficiary.send. If either of these calls fail, the transaction will continue to execute, potentially leading to loss of tokens or ether.",
        "file_name": "0x8e3e25958ad448aeb5982a01b63bcb91355d56a5.sol"
    }
]