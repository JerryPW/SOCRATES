[
    {
        "function_name": "mint",
        "vulnerability": "Bypass Merkle Proof",
        "criticism": "The reasoning is correct. By calling mintProof with an empty proof array, the function effectively bypasses the Merkle proof verification. This could allow unauthorized users to mint tokens, which is a significant vulnerability. The severity is high because it undermines the access control mechanism. The profitability is also high as unauthorized users can mint tokens without restriction.",
        "correctness": 9,
        "severity": 8,
        "profitability": 8,
        "reason": "This function calls mintProof with an empty proof array, effectively bypassing the Merkle proof verification and potentially allowing unauthorized users to mint tokens.",
        "code": "function mint(uint256 mintCount,address receiveAds) external payable { bytes32[] memory proof = new bytes32[](0); mintProof(mintCount,receiveAds,proof); }",
        "file_name": "0x0321be5f545ea569424aace4dc08d60f467229ac.sol",
        "final_score": 8.5
    },
    {
        "function_name": "devAwardEth",
        "vulnerability": "Incorrect ETH Distribution",
        "criticism": "The reasoning is correct in identifying a potential issue with the ETH distribution logic. The calculation for devAmount does not properly account for the remaining balance, which could lead to incorrect transfers. The severity is moderate because it could result in unintended ETH loss, but it is limited to the developer's address. The profitability is low for an external attacker as it requires control over the developer's address.",
        "correctness": 8,
        "severity": 5,
        "profitability": 1,
        "reason": "The calculation for devAmount does not account for proper proportional distribution. If remainBalance is zero, it may incorrectly transfer more ETH than intended, potentially causing unintended ETH loss.",
        "code": "function devAwardEth() external { require(_mintedCounts==_maxMintCount,\"waiting mint finish\"); require(!devHadClaimEth,\"had claimed\"); require(msg.sender==_devAddress,\"only dev!\"); uint256 balance = address(this).balance; require(balance > 0, \"Contract has no ETH balance.\"); address payable sender = payable(_devAddress); uint256 devAmount = donateEthPro*balance/(deployReserveEthPro+donateEthPro); if(remainBalance==0){ sender.transfer(devAmount); remainBalance = balance-devAmount; }else{ sender.transfer(remainBalance); } devHadClaimEth = true; }",
        "file_name": "0x0321be5f545ea569424aace4dc08d60f467229ac.sol",
        "final_score": 5.5
    },
    {
        "function_name": "mintProof",
        "vulnerability": "Unrestricted ETH transfer",
        "criticism": "The reasoning is partially correct. The function does transfer ETH to lpContract based on msg.value, but it does not explicitly verify if lpContract is a trusted address. However, the function uses IWETH to wrap ETH, which is a common practice in DeFi applications. The severity is moderate because if lpContract is not a trusted address, it could lead to loss of funds. The profitability is low for an external attacker unless they can control lpContract.",
        "correctness": 6,
        "severity": 5,
        "profitability": 2,
        "reason": "The function transfers ETH to lpContract based on msg.value without verifying if lpContract is a trusted address, allowing potential redirection of ETH to an attacker-controlled contract.",
        "code": "function mintProof(uint256 mintCount,address receiveAds,bytes32[] memory proof) public payable { require(!isContract(msg.sender),\"not supper contract mint\"); require(mintCount > 0, \"Invalid mint count\"); require(mintCount <= _maxMintPerAddress, \"Exceeded maximum mint count per address\"); require(msg.value >= mintCount*_mintPrice, \"illegal price\"); require(_mintCounts[msg.sender]+mintCount <= _maxMintPerAddress, \"over limit\"); receiveAds = msg.sender; if(isZero(wlRoot)){ require(block.timestamp >= mintStartTime, \"Minting has not started yet\"); require(block.timestamp <= mintEndTime, \"Minting has ended\"); }else { if (block.timestamp<wlMintedEndTime){ require(wlMintedCounts+mintCount<=wlMintCounts,\"over limit\"); bytes32 leaf = keccak256(abi.encodePacked(msg.sender)); require(MerkleProof.verify(proof, wlRoot, leaf),\"Not In Wl\"); wlMintedCounts += mintCount; } } if (block.timestamp<wlMintedEndTime){ require(_mintedCounts-wlMintedCounts+mintCount <= (_maxMintCount - wlMintedCounts), \"illegal mintAmount\"); } IWETH(wethAddress).deposit{value: msg.value*(1000-deployReserveEthPro-donateEthPro)/1000}(); IWETH(wethAddress).approve(lpContract, msg.value*(1000-deployReserveEthPro-donateEthPro)/1000); IWETH(wethAddress).transferFrom(address(this), lpContract, msg.value*(1000-deployReserveEthPro-donateEthPro)/1000); uint256 mintAmount = (totalSupply() * _maxPro * mintCount) / (_maxMintCount * 2000000); for (uint256 i = 0; i < contractAuths.length; i++) { if (contractAuths[i].contractType == ContractType.ERC721) { if(validateNftNumber==1){ IERC721Enumerable eRC721Enumerable = IERC721Enumerable(contractAuths[i].contractAddress); uint256 tokenId = eRC721Enumerable.tokenOfOwnerByIndex(msg.sender, 0); require(!tokenExists[tokenId],\"had used!\"); tokenExists[tokenId] = true; } uint256 tokenCount = getERC721TokenCount(contractAuths[i].contractAddress); require(tokenCount >= contractAuths[i].tokenCount, \"Insufficient ERC721 tokens\"); } else if (contractAuths[i].contractType == ContractType.ERC20) { uint256 tokenCount = getERC20TokenCount(contractAuths[i].contractAddress); require(tokenCount >= contractAuths[i].tokenCount, \"Insufficient ERC20 tokens\"); } else if (contractAuths[i].contractType == ContractType.ERC1155) { uint256 tokenCount = getERC1155TokenCount(contractAuths[i].contractAddress, 0); require(tokenCount >= contractAuths[i].tokenCount, \"Insufficient ERC1155 tokens\"); } } _transfer(address(this), receiveAds, mintAmount); _transfer(address(this), lpContract, mintAmount); IUniswapV2Pair(lpContract).sync(); _mintCounts[msg.sender] += mintCount; _mintedCounts += mintCount; }",
        "file_name": "0x0321be5f545ea569424aace4dc08d60f467229ac.sol",
        "final_score": 4.75
    }
]