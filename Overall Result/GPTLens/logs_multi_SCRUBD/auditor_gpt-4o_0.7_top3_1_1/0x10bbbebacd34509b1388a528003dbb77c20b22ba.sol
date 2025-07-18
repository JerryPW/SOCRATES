[
    {
        "function_name": "upgradeToAndCall",
        "code": "function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin { _upgradeTo(newImplementation); (bool success,) = newImplementation.delegatecall(data); require(success); }",
        "vulnerability": "Delegatecall to arbitrary implementation",
        "reason": "The `upgradeToAndCall` function allows the admin to upgrade the proxy to a new implementation and execute a function on that implementation using `delegatecall`. This can be dangerous if the `newImplementation` is not trusted, as it allows for arbitrary code execution in the context of the proxy contract. If an attacker gains control of the admin account, they can upgrade to a malicious contract and execute arbitrary code, potentially stealing funds or disrupting the contract.",
        "file_name": "0x10bbbebacd34509b1388a528003dbb77c20b22ba.sol"
    },
    {
        "function_name": "initialize",
        "code": "function initialize(address _logic, bytes memory _data) public payable { require(_implementation() == address(0)); assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1)); _setImplementation(_logic); if(_data.length > 0) { (bool success,) = _logic.delegatecall(_data); require(success); } }",
        "vulnerability": "Improper access control on initialization",
        "reason": "The `initialize` function does not have any access control, allowing anyone to initialize the contract if it hasn't been initialized yet. This can lead to a race condition where an attacker can initialize the contract before the legitimate owner, potentially setting malicious logic and executing arbitrary code, especially if the `_data` parameter is used to call functions on the initial logic contract.",
        "file_name": "0x10bbbebacd34509b1388a528003dbb77c20b22ba.sol"
    },
    {
        "function_name": "createTokenMapped",
        "code": "function createTokenMapped(address token) external payable returns (address tokenMapped) { _chargeFee(); IERC20(token).totalSupply(); require(tokenMappeds[token] == address(0), 'TokenMapped created already'); bytes32 salt = keccak256(abi.encodePacked(_chainId(), token)); bytes memory bytecode = type(InitializableProductProxy).creationCode; assembly { tokenMapped := create2(0, add(bytecode, 32), mload(bytecode), salt) } InitializableProductProxy(payable(tokenMapped)).__InitializableProductProxy_init(address(this), _TokenMapped_, abi.encodeWithSignature('__TokenMapped_init(address,address)', address(this), token)); tokenMappeds[token] = tokenMapped; emit CreateTokenMapped(_msgSender(), token, tokenMapped); }",
        "vulnerability": "Lack of validation on token contract",
        "reason": "The `createTokenMapped` function does not adequately check whether the `token` address is a valid contract or already mapped token. The function relies solely on the `totalSupply` check, which may not accurately determine the legitimacy of the token contract. This can result in mapping invalid or malicious tokens, posing a risk of creating proxy contracts that interact with malicious token contracts.",
        "file_name": "0x10bbbebacd34509b1388a528003dbb77c20b22ba.sol"
    }
]