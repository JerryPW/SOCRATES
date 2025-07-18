[
    {
        "function_name": "function () payable external",
        "code": "function () payable external { require(check[msg.sender] == false); require(msg.value < 1000000000000000001 wei); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint copy = price; uint second = price; uint third = price; if (amountRaised <= 100 ether) { uint newvalue = copy / 10; swapaddress.transfer(msg.sender, amount / newvalue); } else if (amountRaised <= 2100 ether) { uint secondvalue = second / 2; swapaddress.transfer(msg.sender, amount / secondvalue); } else { swapaddress.transfer(msg.sender, amount / third); } beneficiary.send(msg.value); emit FundTransfer(msg.sender, amount, true); check[msg.sender] = true; }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The contract uses `beneficiary.send(msg.value);` which transfers Ether to the beneficiary. If the beneficiary is a contract, it can call back into this contract before the state is updated (`check[msg.sender] = true;`), allowing reentrancy attacks to exploit the contract by repeatedly triggering the fallback function.",
        "file_name": "0x8e3e25958ad448aeb5982a01b63bcb91355d56a5.sol"
    },
    {
        "function_name": "function () payable external",
        "code": "function () payable external { require(check[msg.sender] == false); require(msg.value < 1000000000000000001 wei); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint copy = price; uint second = price; uint third = price; if (amountRaised <= 100 ether) { uint newvalue = copy / 10; swapaddress.transfer(msg.sender, amount / newvalue); } else if (amountRaised <= 2100 ether) { uint secondvalue = second / 2; swapaddress.transfer(msg.sender, amount / secondvalue); } else { swapaddress.transfer(msg.sender, amount / third); } beneficiary.send(msg.value); emit FundTransfer(msg.sender, amount, true); check[msg.sender] = true; }",
        "vulnerability": "Unchecked External Call",
        "reason": "The statement `beneficiary.send(msg.value);` does not check the return value of the send operation, which can lead to loss of Ether if the transfer fails. This can be particularly problematic if the beneficiary address is a contract that uses more than 2300 gas units, causing the send function to fail.",
        "file_name": "0x8e3e25958ad448aeb5982a01b63bcb91355d56a5.sol"
    },
    {
        "function_name": "function () payable external",
        "code": "function () payable external { require(check[msg.sender] == false); require(msg.value < 1000000000000000001 wei); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint copy = price; uint second = price; uint third = price; if (amountRaised <= 100 ether) { uint newvalue = copy / 10; swapaddress.transfer(msg.sender, amount / newvalue); } else if (amountRaised <= 2100 ether) { uint secondvalue = second / 2; swapaddress.transfer(msg.sender, amount / secondvalue); } else { swapaddress.transfer(msg.sender, amount / third); } beneficiary.send(msg.value); emit FundTransfer(msg.sender, amount, true); check[msg.sender] = true; }",
        "vulnerability": "Integer Division Truncation",
        "reason": "The function uses integer division for calculating the value of `newvalue`, `secondvalue`, and the amount of collectibles to transfer. This can lead to truncation and rounding errors, especially when `amount` is not a perfect multiple of `newvalue`, `secondvalue`, or `third`, potentially resulting in incorrect amounts of collectibles being transferred.",
        "file_name": "0x8e3e25958ad448aeb5982a01b63bcb91355d56a5.sol"
    }
]