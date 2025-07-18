[
    {
        "function_name": "withdrawERC20",
        "code": "function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner { require(_amountToWithdraw > 0); IERC20 tokenContract = IERC20(_tokenContract); require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, \"WithdrawV2: Contract does not own enough tokens\"); tokenContract.transfer(erc20Payable, _amountToWithdraw); _withdrawAllSurcharges(); }",
        "vulnerability": "ERC20 theft by team",
        "reason": "The withdrawERC20 function allows any team member to withdraw an arbitrary amount of ERC20 tokens from the contract to a specified payable address without any restriction. This means a malicious or compromised team member could siphon all ERC20 tokens from the contract, potentially resulting in significant loss for token holders if the contract holds valuable tokens. There is no mechanism to restrict the withdrawal amount or to ensure it serves a legitimate purpose.",
        "file_name": "0x0043a4a809be33afa17c1e3e37e19977622e4700.sol"
    },
    {
        "function_name": "mintTo",
        "code": "function mintTo(address _to) public payable { require(onlyERC20MintingMode == false, \"Only minting with ERC-20 tokens is enabled.\"); require(getNextTokenId() <= collectionSize, \"Cannot mint over supply cap of 1000\"); require(mintingOpen == true, \"Minting is not open right now!\"); require(canMintAmount(_to, 1), \"Wallet address is over the maximum allowed mints\"); require(msg.value == getPrice(1), \"Value needs to be exactly the mint fee!\"); _safeMint(_to, 1, false); }",
        "vulnerability": "Minting without restrictions",
        "reason": "The mintTo function allows anyone to mint a token by merely paying the required fee, without any limitations on who can call this function, aside from general minting restrictions. This may not be desirable in all scenarios, especially if the contract owner intends to restrict minting to certain participants or during specific periods. Anyone can call this function to mint tokens for themselves or others, potentially leading to an oversupply of tokens, diluting their value.",
        "file_name": "0x0043a4a809be33afa17c1e3e37e19977622e4700.sol"
    },
    {
        "function_name": "setRamppAddress",
        "code": "function setRamppAddress(address _newAddress) public isRampp { require(_newAddress != RAMPPADDRESS, \"WithdrawableV2: New Rampp address must be different\"); RAMPPADDRESS = _newAddress; payableAddresses[0] = _newAddress; }",
        "vulnerability": "Centralized control over RAMPP address",
        "reason": "The setRamppAddress function allows the RAMPP address, which is a privileged address in the contract, to be changed by the current RAMPP address. This can be dangerous as it centralizes control and trust in a single address, which, if compromised, could redirect all privileged operations to a malicious address. This includes withdrawing funds or surcharges, potentially resulting in a complete loss of contract funds. The contract lacks mechanisms for multi-signature control or community consensus to approve such a critical change.",
        "file_name": "0x0043a4a809be33afa17c1e3e37e19977622e4700.sol"
    }
]