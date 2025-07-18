[
    {
        "function_name": "migrate(IPackFour pack, uint[] memory ids)",
        "code": "function migrate( IPackFour pack, uint[] memory ids ) public { for (uint i = 0; i < ids.length; i++) { migrate(pack, ids[i]); } }",
        "vulnerability": "Recursive function call",
        "reason": "The `migrate` function calls itself with each element of the `ids` array, leading to a potential stack overflow if the array is too large. This makes the contract vulnerable to attacks that exploit the gas limit, potentially resulting in a denial of service.",
        "file_name": "0x5f38c57b268664015de387229bc9d3822b53ec32.sol"
    },
    {
        "function_name": "migrate(IPackFour pack, uint id)",
        "code": "function migrate( IPackFour pack, uint id ) public { require( canMigrate[address(pack)], \"V1: must be migrating from an approved pack\" ); require( !v1Migrated[address(pack)][id], \"V1: must not have been already migrated\" ); ( uint16 current, uint16 count, address user, uint256 randomness, ) = pack.purchases(id); require( randomness != 0, \"V1: must have had randomness set\" ); uint remaining = ((count - current) * 5); require( remaining > 0, \"V1: no more cards to migrate\" ); require(limit >= remaining, \"too many cards remaining\"); StackDepthLimit memory sdl; sdl.protos = new uint16[](remaining); sdl.qualities = new uint8[](remaining); (sdl.oldProtos, sdl.purities) = pack.predictPacks(id); uint loopStart = (current * 5); for (uint i = 0; i < remaining; i++) { uint x = loopStart+i; sdl.protos[i] = convertProto(sdl.oldProtos[x]); sdl.qualities[i] = convertPurity(sdl.purities[x]); } uint startID = cards.mintCards(user, sdl.protos, sdl.qualities); v1Migrated[address(pack)][id] = true; uint loopEnd = loopStart + remaining; emit Migrated(user, address(pack), id, loopStart, loopEnd, startID); }",
        "vulnerability": "Lack of reentrancy protection",
        "reason": "The `migrate` function modifies the `v1Migrated` mapping only after the `cards.mintCards` call. If a malicious contract is called during `mintCards`, it could re-enter the `migrate` function before the `v1Migrated` mapping is updated, leading to potential double migration and exploitation.",
        "file_name": "0x5f38c57b268664015de387229bc9d3822b53ec32.sol"
    },
    {
        "function_name": "migrate(IPackFour pack, uint id)",
        "code": "function migrate( IPackFour pack, uint id ) public { require( canMigrate[address(pack)], \"V1: must be migrating from an approved pack\" ); require( !v1Migrated[address(pack)][id], \"V1: must not have been already migrated\" ); ( uint16 current, uint16 count, address user, uint256 randomness, ) = pack.purchases(id); require( randomness != 0, \"V1: must have had randomness set\" ); uint remaining = ((count - current) * 5); require( remaining > 0, \"V1: no more cards to migrate\" ); require(limit >= remaining, \"too many cards remaining\"); StackDepthLimit memory sdl; sdl.protos = new uint16[](remaining); sdl.qualities = new uint8[](remaining); (sdl.oldProtos, sdl.purities) = pack.predictPacks(id); uint loopStart = (current * 5); for (uint i = 0; i < remaining; i++) { uint x = loopStart+i; sdl.protos[i] = convertProto(sdl.oldProtos[x]); sdl.qualities[i] = convertPurity(sdl.purities[x]); } uint startID = cards.mintCards(user, sdl.protos, sdl.qualities); v1Migrated[address(pack)][id] = true; uint loopEnd = loopStart + remaining; emit Migrated(user, address(pack), id, loopStart, loopEnd, startID); }",
        "vulnerability": "Potential denial of service via gas limit",
        "reason": "The `migrate` function uses a loop to process each remaining card, and if `remaining` is large, it could exceed the block gas limit, causing the transaction to fail. This allows attackers to potentially lock out legitimate users by crafting transactions that intentionally run out of gas.",
        "file_name": "0x5f38c57b268664015de387229bc9d3822b53ec32.sol"
    }
]