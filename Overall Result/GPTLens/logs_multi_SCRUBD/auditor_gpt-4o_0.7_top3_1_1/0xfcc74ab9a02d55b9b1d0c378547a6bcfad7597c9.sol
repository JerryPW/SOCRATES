[
    {
        "function_name": "function () payable",
        "code": "function () payable { require(!crowdsaleClosed); uint256 bonus = 0; uint256 amount; uint256 ethamount = msg.value; balanceOf[msg.sender] = balanceOf[msg.sender].add(ethamount); amountRaised = amountRaised.add(ethamount); if(now >= preSaleStartdate && now <= preSaleDeadline ){ amount = ethamount.div(price); bonus = amount.div(8); amount = amount.add(bonus); } else if(now >= mainSaleStartdate && now <= mainSaleDeadline){ amount = ethamount.div(price); } amount = amount.mul(1000000000000000000); tokenReward.transfer(msg.sender, amount); beneficiary.send(ethamount); fundTransferred = fundTransferred.add(ethamount); }",
        "vulnerability": "Unsafe external call to `beneficiary.send`",
        "reason": "The use of `beneficiary.send(ethamount);` can lead to reentrancy attacks and unexpected failures in fund transfer due to limited gas stipends. This makes the contract vulnerable to attacks where the `beneficiary` address is a contract with a fallback function that reverts the transaction or consumes more than the provided gas, potentially locking funds in the contract.",
        "file_name": "0xfcc74ab9a02d55b9b1d0c378547a6bcfad7597c9.sol"
    },
    {
        "function_name": "function getTokensBack",
        "code": "function getTokensBack() { uint256 remaining = tokenReward.balanceOf(this); if(msg.sender == beneficiary){ tokenReward.transfer(beneficiary, remaining); } }",
        "vulnerability": "Lack of access control",
        "reason": "The function `getTokensBack` allows the `beneficiary` to transfer all remaining tokens from the contract to themselves without any condition based on the state of the crowdsale. This can be exploited by the `beneficiary` to drain the tokens at any time, even before the crowdsale ends, violating the expectations of fairness and transparency to contributors.",
        "file_name": "0xfcc74ab9a02d55b9b1d0c378547a6bcfad7597c9.sol"
    },
    {
        "function_name": "function ChangeDates",
        "code": "function ChangeDates(uint256 _preSaleStartdate, uint256 _preSaleDeadline, uint256 _mainSaleStartdate, uint256 _mainSaleDeadline) { if(msg.sender == beneficiary){ if(_preSaleStartdate != 0){ preSaleStartdate = _preSaleStartdate; } if(_preSaleDeadline != 0){ preSaleDeadline = _preSaleDeadline; } if(_mainSaleStartdate != 0){ mainSaleStartdate = _mainSaleStartdate; } if(_mainSaleDeadline != 0){ mainSaleDeadline = _mainSaleDeadline; } if(crowdsaleClosed == true){ crowdsaleClosed = false; } } }",
        "vulnerability": "Arbitrary date modification",
        "reason": "The function `ChangeDates` allows the `beneficiary` to arbitrarily modify the start and end dates of the presale and main sale, as well as reopen a closed crowdsale. This can be exploited to manipulate the crowdsale process, potentially defrauding investors by altering sale conditions without notice or consent.",
        "file_name": "0xfcc74ab9a02d55b9b1d0c378547a6bcfad7597c9.sol"
    }
]