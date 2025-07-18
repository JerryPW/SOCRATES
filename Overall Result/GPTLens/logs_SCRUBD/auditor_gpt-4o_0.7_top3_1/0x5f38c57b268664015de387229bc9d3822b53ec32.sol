[
    {
        "function_name": "migrate(IPackFour pack, uint id)",
        "code": "function migrate(IPackFour pack, uint id) public { require( canMigrate[address(pack)], \"V1: must be migrating from an approved pack\" ); require( !v1Migrated[address(pack)][id], \"V1: must not have been already migrated\" ); ( uint16 current, uint16 count, address user, uint256 randomness, ) = pack.purchases(id); require( randomness != 0, \"V1: must have had randomness set\" ); uint remaining = ((count - current) * 5); require( remaining > 0, \"V1: no more cards to migrate\" ); require(limit >= remaining, \"too many cards remaining\"); StackDepthLimit memory sdl; sdl.protos = new uint16[](remaining); sdl.qualities = new uint8[](remaining); (sdl.oldProtos, sdl.purities) = pack.predictPacks(id); uint loopStart = (current * 5); for (uint i = 0; i < remaining; i++) { uint x = loopStart+i; sdl.protos[i] = convertProto(sdl.oldProtos[x]); sdl.qualities[i] = convertPurity(sdl.purities[x]); } uint startID = cards.mintCards(user, sdl.protos, sdl.qualities); v1Migrated[address(pack)][id] = true; uint loopEnd = loopStart + remaining; emit Migrated(user, address(pack), id, loopStart, loopEnd, startID); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function 'migrate' calls an external contract 'pack' to retrieve 'purchases' and then performs state changes by minting cards before updating the 'v1Migrated' mapping. An attacker could exploit this by re-entering the function through a malicious 'pack' contract, causing unexpected behavior or double migration.",
        "file_name": "0x5f38c57b268664015de387229bc9d3822b53ec32.sol"
    },
    {
        "function_name": "convertProto(uint16 proto)",
        "code": "function convertProto(uint16 proto) public view returns (uint16) { if (proto >= 1 && proto <= 377) { return proto; } if (proto == 380) { return 400; } if (proto == 381) { return 401; } if (proto == 394) { return 402; } (bool found, uint index) = getEtherbotsIndex(proto); if (found) { return uint16(380 + index); } if (proto == 378) { return 65000; } if (proto == 379) { return 65001; } if (proto == 383) { return 65002; } if (proto == 384) { return 65003; } require(false, \"BM: unrecognised proto\"); }",
        "vulnerability": "Denial of service through unrecognised proto",
        "reason": "The function 'convertProto' has a require statement that will always fail for certain 'proto' values that do not match any condition. This leads to a denial of service by causing the function to always revert if an unrecognized proto is passed, preventing any further execution.",
        "file_name": "0x5f38c57b268664015de387229bc9d3822b53ec32.sol"
    },
    {
        "function_name": "constructor(v1Migration _migration)",
        "code": "constructor(v1Migration _migration) public { migration = _migration; }",
        "vulnerability": "Unrestricted access to migration assignment",
        "reason": "The constructor of 'CanBeV1Migrated' allows any address to be set as the 'migration' contract without any access control. This could allow an attacker to instantiate the contract and set a malicious migration contract, potentially leading to unauthorized migrations or other malicious actions.",
        "file_name": "0x5f38c57b268664015de387229bc9d3822b53ec32.sol"
    }
]