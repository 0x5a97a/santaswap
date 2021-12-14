// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "ds-test/test.sol";

import "../../Santaswap.sol";
import "./MockERC721.sol";
import "./Hevm.sol";

import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

contract User is ERC721Holder {
    Santaswap internal santaswap;
    MockERC721 internal token1;

    constructor(address _santaswap) {
        santaswap = Santaswap(_santaswap);
    }

    function unwrapGift() public {
        santaswap.unwrapGift();
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) public {
        MockERC721(token).safeTransferFrom(from, to, tokenId, data);
    }

    function setChristmasMagic(uint256 secret, string calldata message) public {
        santaswap.setChristmasMagic(secret, message);
    }
}

abstract contract SantaswapTest is DSTest {
    Hevm internal constant hevm = Hevm(HEVM_ADDRESS);

    // contracts
    Santaswap internal santaswap;
    MockERC721 internal token1;
    MockERC721 internal token2;
    MockERC721 internal token3;
    MockERC721 internal token4;

    // users
    User internal user;
    User internal user1;
    User internal user2;
    User internal santa;

    bytes32[] internal token1Proof = [
        bytes32(
            0x1d15872cb4155456457f39e7cfbcc6fd89602b562fba4b85f1a60566b8d20747
        ),
        bytes32(
            0x4d88d2b3f281b4b122775683110a9c31892a5b9d65f3bbcfb97679ea9eb80119
        )
    ];
    bytes32[] internal token2Proof = [
        bytes32(
            0x6dc83bfcf6c864d93ace3a5c9c1bdde73d568f0e2975bb770a4b81d720c7f569
        ),
        bytes32(
            0x4d88d2b3f281b4b122775683110a9c31892a5b9d65f3bbcfb97679ea9eb80119
        )
    ];
    bytes32[] internal token3Proof = [
        bytes32(
            0xbde3073f9a6c55859c733a607e5165fa434e9413dbeefbd17e3bf280e0db1130
        ),
        bytes32(
            0x1f15b6f86ac8139a9a8f776197b7aa7fe283c4518bd0ada0b582650f728cb167
        )
    ];
    bytes32[] internal token4Proof = [
        bytes32(
            0x1d26cd5f3de066042965f4dc6b00819d0614548319ed6a142880a967149e191e
        ),
        bytes32(
            0x1f15b6f86ac8139a9a8f776197b7aa7fe283c4518bd0ada0b582650f728cb167
        )
    ];
    bytes internal TOKEN1_PROOF = abi.encode(token1Proof);
    bytes internal TOKEN2_PROOF = abi.encode(token2Proof);
    bytes internal TOKEN3_PROOF = abi.encode(token3Proof);
    bytes internal TOKEN4_PROOF = abi.encode(token4Proof);

    bytes internal INVALID_PROOF = abi.encode([bytes32(0)]);

    function setUp() public virtual {
        santaswap = new Santaswap(
            0xe70cf37de7c89661d35b23ece8166749b86ada4ead19c5596e73f5fb949dd0ac
        );

        token1 = new MockERC721("Token 1", "ONE");
        token2 = new MockERC721("Token 2", "TWO");
        token3 = new MockERC721("Token 3", "THREE");
        token4 = new MockERC721("Token 4", "FOUR");

        user = new User(address(santaswap));
        user1 = new User(address(santaswap));
        user2 = new User(address(santaswap));

        santa = new User(address(santaswap));
        santaswap.transferOwnership(address(santa));
    }
}
