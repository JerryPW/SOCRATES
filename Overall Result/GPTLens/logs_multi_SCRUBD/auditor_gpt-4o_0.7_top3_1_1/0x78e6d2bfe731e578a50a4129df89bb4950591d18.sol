[
    {
        "function_name": "constructor",
        "code": "constructor( address SendTo, uint etherCostOfEachCollectible, address addressOfCollectibleUsedAsReward ) public { beneficiary = SendTo; price = etherCostOfEachCollectible * 1 szabo; swapaddress = collectible(addressOfCollectibleUsedAsReward); }",
        "vulnerability": "Lack of input validation for constructor parameters",
        "reason": "The constructor allows setting any address as the beneficiary and swap address without validation. An attacker could deploy a malicious contract and set themselves as the beneficiary or set a fraudulent collectible contract, resulting in loss of funds or incorrect token distribution.",
        "file_name": "0x78e6d2bfe731e578a50a4129df89bb4950591d18.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function () payable external { require(check[msg.sender] == false); require(msg.value < 1000000000000000001 wei); uint amount = msg.value; balanceOf[msg.sender] += amount; uint second = price; uint third = price; if (counter <= 6000) { counter += 1; swapaddress.transfer(msg.sender, 5000000); msg.sender.send(msg.value); } else if (amountRaised <= 8000 ether) { amountRaised += amount; uint secondvalue = second / 5; swapaddress.transfer(msg.sender, amount / secondvalue); } else { amountRaised += amount; uint thirdvalue = third / 3; swapaddress.transfer(msg.sender, amount / thirdvalue); } beneficiary.send(msg.value); emit FundTransfer(msg.sender, amount, true); check[msg.sender] = true; }",
        "vulnerability": "Reentrancy vulnerability in fallback function",
        "reason": "The fallback function makes an external call to msg.sender.send() before updating the state variable check[msg.sender]. This can be exploited for reentrancy attacks, where the attacker can repeatedly call the contract before the state is updated, potentially draining funds.",
        "file_name": "0x78e6d2bfe731e578a50a4129df89bb4950591d18.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function () payable external { require(check[msg.sender] == false); require(msg.value < 1000000000000000001 wei); uint amount = msg.value; balanceOf[msg.sender] += amount; uint second = price; uint third = price; if (counter <= 6000) { counter += 1; swapaddress.transfer(msg.sender, 5000000); msg.sender.send(msg.value); } else if (amountRaised <= 8000 ether) { amountRaised += amount; uint secondvalue = second / 5; swapaddress.transfer(msg.sender, amount / secondvalue); } else { amountRaised += amount; uint thirdvalue = third / 3; swapaddress.transfer(msg.sender, amount / thirdvalue); } beneficiary.send(msg.value); emit FundTransfer(msg.sender, amount, true); check[msg.sender] = true; }",
        "vulnerability": "Arbitrary send to beneficiary",
        "reason": "The contract sends msg.value to the beneficiary address without validating the success of the send operation. If the send fails, the transaction will continue, leading to potential inconsistencies or loss of funds intended for the beneficiary.",
        "file_name": "0x78e6d2bfe731e578a50a4129df89bb4950591d18.sol"
    }
]