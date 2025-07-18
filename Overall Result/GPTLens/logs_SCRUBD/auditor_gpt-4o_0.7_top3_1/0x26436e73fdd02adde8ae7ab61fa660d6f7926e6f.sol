[
    {
        "function_name": "Crowdsale",
        "code": "function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _cap, address _wallet) public {\n    require(_startTime >= now);\n    require(_endTime >= _startTime);\n    require(_cap > 0);\n    require(_wallet != address(0));\n    owner = msg.sender;\n    address _tokenAddr = 0x6A09e1b7cC5cb52FfdfC585a8dF51CED7063915C;\n    token = Token(_tokenAddr);\n    startTime = _startTime;\n    endTime = _endTime;\n    rate = fundingRate[tierNum];\n    cap = _cap.mul(1 ether);\n    wallet = _wallet;\n    initialCrowdsale(_startTime, _endTime, _cap, cap, fundingRate[tierNum], rate, _wallet);\n}",
        "vulnerability": "Hardcoded Token Address",
        "reason": "The constructor sets a hardcoded token address which cannot be changed. If the token contract is updated or replaced, the Crowdsale contract will remain linked to the outdated contract, causing potential issues in functionality and fund flow.",
        "file_name": "0x26436e73fdd02adde8ae7ab61fa660d6f7926e6f.sol"
    },
    {
        "function_name": "rateUpgrade",
        "code": "function rateUpgrade(uint256 tierAmount) internal {\n    uint256 tierEthLimit = fundingLimit[tierNum].div(fundingRate[tierNum]);\n    uint256 tierWeiLimit = tierEthLimit.mul(1 ether);\n    if(tierAmount >= tierWeiLimit) {\n        tierNum = tierNum.add(1);\n        rate = fundingRate[tierNum];\n        tierTotal = 0;\n    }\n}",
        "vulnerability": "Array Out of Bounds",
        "reason": "In the rateUpgrade function, tierNum is incremented without checking if it exceeds the bounds of the fundingRate array. If tierNum exceeds 4, it will cause an out-of-bounds access, potentially leading to a crash or incorrect behavior.",
        "file_name": "0x26436e73fdd02adde8ae7ab61fa660d6f7926e6f.sol"
    },
    {
        "function_name": "destroy",
        "code": "function destroy() public onlyOwner payable {\n    uint256 balance = tokensAvailable();\n    if(balance > 0) {\n        token.transfer(owner, balance);\n    }\n    selfdestruct(owner);\n}",
        "vulnerability": "Missing Token Approval",
        "reason": "The destroy function attempts to transfer tokens back to the owner without ensuring proper approval from the token contract. This can result in a failed transfer if the Crowdsale contract does not have permission to transfer tokens on behalf of the owner.",
        "file_name": "0x26436e73fdd02adde8ae7ab61fa660d6f7926e6f.sol"
    }
]