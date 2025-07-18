[
    {
        "function_name": "function()",
        "code": "function () payable { require(!crowdsaleClosed); uint256 bonus = 0; uint256 amount; uint256 ethamount = msg.value; balanceOf[msg.sender] = balanceOf[msg.sender].add(ethamount); amountRaised = amountRaised.add(ethamount); if(now >= preSaleStartdate && now <= preSaleDeadline ){ amount = ethamount.div(price); bonus = amount.div(8); amount = amount.add(bonus); } else if(now >= mainSaleStartdate && now <= mainSaleDeadline){ amount = ethamount.div(price); } amount = amount.mul(1000000000000000000); tokenReward.transfer(msg.sender, amount); beneficiary.send(ethamount); fundTransferred = fundTransferred.add(ethamount); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function sends Ether to the beneficiary before updating the state. If the beneficiary is a contract, it could re-enter the function, potentially leading to unexpected behavior or draining funds.",
        "file_name": "0xfcc74ab9a02d55b9b1d0c378547a6bcfad7597c9.sol"
    },
    {
        "function_name": "function ()",
        "code": "function () payable { require(!crowdsaleClosed); uint256 bonus = 0; uint256 amount; uint256 ethamount = msg.value; balanceOf[msg.sender] = balanceOf[msg.sender].add(ethamount); amountRaised = amountRaised.add(ethamount); if(now >= preSaleStartdate && now <= preSaleDeadline ){ amount = ethamount.div(price); bonus = amount.div(8); amount = amount.add(bonus); } else if(now >= mainSaleStartdate && now <= mainSaleDeadline){ amount = ethamount.div(price); } amount = amount.mul(1000000000000000000); tokenReward.transfer(msg.sender, amount); beneficiary.send(ethamount); fundTransferred = fundTransferred.add(ethamount); }",
        "vulnerability": "Unchecked send() result",
        "reason": "The beneficiary.send(ethamount) call does not check if the send operation succeeded. If the operation fails, it could result in Ether being permanently lost or the contract not behaving as expected.",
        "file_name": "0xfcc74ab9a02d55b9b1d0c378547a6bcfad7597c9.sol"
    },
    {
        "function_name": "ChangeDates",
        "code": "function ChangeDates(uint256 _preSaleStartdate, uint256 _preSaleDeadline, uint256 _mainSaleStartdate, uint256 _mainSaleDeadline) { if(msg.sender == beneficiary){ if(_preSaleStartdate != 0){ preSaleStartdate = _preSaleStartdate; } if(_preSaleDeadline != 0){ preSaleDeadline = _preSaleDeadline; } if(_mainSaleStartdate != 0){ mainSaleStartdate = _mainSaleStartdate; } if(_mainSaleDeadline != 0){ mainSaleDeadline = _mainSaleDeadline; } if(crowdsaleClosed == true){ crowdsaleClosed = false; } } }",
        "vulnerability": "Potential denial of service",
        "reason": "The beneficiary has the ability to repeatedly change the sale dates, which can lead to denial of service for participants who are unable to purchase tokens due to continuously shifting deadlines.",
        "file_name": "0xfcc74ab9a02d55b9b1d0c378547a6bcfad7597c9.sol"
    }
]