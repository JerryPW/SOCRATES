[
    {
        "function_name": "function () payable",
        "code": "function () payable { require(!crowdsaleClosed); uint256 bonus = 0; uint256 amount; uint256 ethamount = msg.value; balanceOf[msg.sender] = balanceOf[msg.sender].add(ethamount); amountRaised = amountRaised.add(ethamount); if(now >= preSaleStartdate && now <= preSaleDeadline ){ amount = ethamount.div(price); bonus = amount.div(8); amount = amount.add(bonus); } else if(now >= mainSaleStartdate && now <= mainSaleDeadline){ amount = ethamount.div(price); } amount = amount.mul(1000000000000000000); tokenReward.transfer(msg.sender, amount); beneficiary.send(ethamount); fundTransferred = fundTransferred.add(ethamount); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function sends Ether to the beneficiary after transferring tokens. If the beneficiary is a contract, it can reenter the fallback function, allowing it to drain the contract's Ether balance.",
        "file_name": "0xfcc74ab9a02d55b9b1d0c378547a6bcfad7597c9.sol"
    },
    {
        "function_name": "endCrowdsale",
        "code": "function endCrowdsale() afterDeadline { if(msg.sender == beneficiary){ crowdsaleClosed = true; } }",
        "vulnerability": "Unauthorized state change",
        "reason": "The function allows the beneficiary to end the crowdsale without any conditions once the deadline has passed. This can be exploited if the deadline is mistakenly set or manipulated.",
        "file_name": "0xfcc74ab9a02d55b9b1d0c378547a6bcfad7597c9.sol"
    },
    {
        "function_name": "ChangeDates",
        "code": "function ChangeDates(uint256 _preSaleStartdate, uint256 _preSaleDeadline, uint256 _mainSaleStartdate, uint256 _mainSaleDeadline) { if(msg.sender == beneficiary){ if(_preSaleStartdate != 0){ preSaleStartdate = _preSaleStartdate; } if(_preSaleDeadline != 0){ preSaleDeadline = _preSaleDeadline; } if(_mainSaleStartdate != 0){ mainSaleStartdate = _mainSaleStartdate; } if(_mainSaleDeadline != 0){ mainSaleDeadline = _mainSaleDeadline; } if(crowdsaleClosed == true){ crowdsaleClosed = false; } } }",
        "vulnerability": "Improper access control",
        "reason": "The beneficiary can change the start and end dates of the crowdsale at any time, including reopening a closed crowdsale. This can be used to manipulate the sale period unfairly.",
        "file_name": "0xfcc74ab9a02d55b9b1d0c378547a6bcfad7597c9.sol"
    }
]