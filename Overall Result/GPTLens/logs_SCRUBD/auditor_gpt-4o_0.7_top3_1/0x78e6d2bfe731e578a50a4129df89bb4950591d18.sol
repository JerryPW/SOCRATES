[
    {
        "function_name": "fallback function",
        "code": "function () payable external { require(check[msg.sender] == false); require(msg.value < 1000000000000000001 wei); uint amount = msg.value; balanceOf[msg.sender] += amount; uint second = price; uint third = price; if (counter <= 6000) { counter += 1; swapaddress.transfer(msg.sender, 5000000); msg.sender.send(msg.value); } else if (amountRaised <= 8000 ether) { amountRaised += amount; uint secondvalue = second / 5; swapaddress.transfer(msg.sender, amount / secondvalue); } else { amountRaised += amount; uint thirdvalue = third / 3; swapaddress.transfer(msg.sender, amount / thirdvalue); } beneficiary.send(msg.value); emit FundTransfer(msg.sender, amount, true); check[msg.sender] = true; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function contains a reentrancy vulnerability because it sends Ether back to the sender using 'msg.sender.send(msg.value)' before updating the 'check' mapping. This allows an attacker to repeatedly call the function and drain the contract balance before 'check[msg.sender]' is set to true. An attacker could exploit this by creating a contract that repeatedly calls the fallback function.",
        "file_name": "0x78e6d2bfe731e578a50a4129df89bb4950591d18.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function () payable external { require(check[msg.sender] == false); require(msg.value < 1000000000000000001 wei); uint amount = msg.value; balanceOf[msg.sender] += amount; uint second = price; uint third = price; if (counter <= 6000) { counter += 1; swapaddress.transfer(msg.sender, 5000000); msg.sender.send(msg.value); } else if (amountRaised <= 8000 ether) { amountRaised += amount; uint secondvalue = second / 5; swapaddress.transfer(msg.sender, amount / secondvalue); } else { amountRaised += amount; uint thirdvalue = third / 3; swapaddress.transfer(msg.sender, amount / thirdvalue); } beneficiary.send(msg.value); emit FundTransfer(msg.sender, amount, true); check[msg.sender] = true; }",
        "vulnerability": "Unchecked send result",
        "reason": "The contract uses 'send' to transfer Ether back to the sender and to the beneficiary without checking the return value. If the send operation fails, it is not handled, potentially leaving the contract in an inconsistent state or causing loss of funds. The 'send' method returns false on failure, and without checking this, funds may not be transferred as expected.",
        "file_name": "0x78e6d2bfe731e578a50a4129df89bb4950591d18.sol"
    },
    {
        "function_name": "constructor",
        "code": "constructor( address SendTo, uint etherCostOfEachCollectible, address addressOfCollectibleUsedAsReward ) public { beneficiary = SendTo; price = etherCostOfEachCollectible * 1 szabo; swapaddress = collectible(addressOfCollectibleUsedAsReward); }",
        "vulnerability": "Lack of input validation",
        "reason": "The constructor does not validate the input parameters, such as the 'SendTo' address or 'addressOfCollectibleUsedAsReward'. If invalid or malicious addresses are provided, it could lead to loss of funds or enable unauthorized access to contract functions. Verifying the validity of these addresses could prevent potential issues.",
        "file_name": "0x78e6d2bfe731e578a50a4129df89bb4950591d18.sol"
    }
]