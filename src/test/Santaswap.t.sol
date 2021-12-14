// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./utils/SantaswapTest.sol";

contract TestOnERC721Received is SantaswapTest {
    function test_receives_ERC721() public {
        emit log_address(address(token1));
        emit log_address(address(token2));
        emit log_address(address(token3));
        emit log_address(address(token4));

        assertEq(token1.balanceOf(address(santaswap)), 0);

        token1.mint(address(this), 1);
        token1.safeTransferFrom(
            address(this),
            address(santaswap),
            1,
            TOKEN1_PROOF
        );

        assertEq(token1.balanceOf(address(santaswap)), 1);
    }

    function test_creates_gift_on_ERC721_received() public {
        token1.mint(address(this), 1);
        token1.safeTransferFrom(
            address(this),
            address(santaswap),
            1,
            TOKEN1_PROOF
        );

        (address token, uint256 tokenId) = santaswap.gifts(0);
        assertEq(token, address(token1));
        assertEq(tokenId, 1);
    }

    function test_adds_gift_sender_to_nice_list() public {
        assertEq(santaswap.niceList(address(user)), 0);

        token1.mint(address(user), 1);
        user.safeTransferFrom(
            address(token1),
            address(user),
            address(santaswap),
            1,
            TOKEN1_PROOF
        );

        assertEq(santaswap.niceList(address(user)), 1);
    }

    function test_one_gift_per_address() public {
        token1.mint(address(user), 1);
        token1.mint(address(user), 2);
        user.safeTransferFrom(
            address(token1),
            address(user),
            address(santaswap),
            1,
            TOKEN1_PROOF
        );
        try
            user.safeTransferFrom(
                address(token1),
                address(user),
                address(santaswap),
                2,
                TOKEN1_PROOF
            )
        {
            fail();
        } catch Error(string memory error) {
            assertEq(error, "You are on the list");
        }
    }

    function test_no_gifts_after_santa_visits() public {
        santa.setChristmasMagic(1, "msg");
        token1.mint(address(user), 1);
        try
            user.safeTransferFrom(
                address(token1),
                address(user),
                address(santaswap),
                1,
                TOKEN1_PROOF
            )
        {
            fail();
        } catch Error(string memory error) {
            assertEq(error, "Santa already visited");
        }
    }

    function testFail_reverts_on_direct_call() public {
        santaswap.onERC721Received(
            address(this),
            address(token1),
            1,
            abi.encode("")
        );
    }

    function test_must_send_valid_proof() public {
        santa.setChristmasMagic(1, "msg");
        token1.mint(address(user), 1);
        try
            user.safeTransferFrom(
                address(token1),
                address(user),
                address(santaswap),
                1,
                INVALID_PROOF
            )
        {
            fail();
        } catch Error(string memory error) {
            assertEq(error, "Token is not on the tree");
        }
    }
}

contract TestTotalGifts is SantaswapTest {
    function test_returns_total_gifts() public {
        assertEq(santaswap.totalGifts(), 0);

        token1.mint(address(user1), 1);
        user1.safeTransferFrom(
            address(token1),
            address(user1),
            address(santaswap),
            1,
            TOKEN1_PROOF
        );

        assertEq(santaswap.totalGifts(), 1);

        token2.mint(address(user2), 1);
        user2.safeTransferFrom(
            address(token2),
            address(user2),
            address(santaswap),
            1,
            TOKEN2_PROOF
        );

        assertEq(santaswap.totalGifts(), 2);
    }
}

contract TestUnwrapGift is SantaswapTest {
    function test_cannot_unwrap_if_not_on_nice_list() public {
        try user.unwrapGift() {
            fail();
        } catch Error(string memory error) {
            assertEq(error, "Not on the nice list");
        }
    }

    function test_cannot_unwrap_before_santa_visits() public {
        token1.mint(address(user), 1);
        user.safeTransferFrom(
            address(token1),
            address(user),
            address(santaswap),
            1,
            TOKEN1_PROOF
        );
        try user.unwrapGift() {
            fail();
        } catch Error(string memory error) {
            assertEq(error, "Santa has not visited yet");
        }
    }

    function test_cannot_unwrap_before_christmas_morning() public {
        token1.mint(address(user), 1);
        user.safeTransferFrom(
            address(token1),
            address(user),
            address(santaswap),
            1,
            TOKEN1_PROOF
        );
        santa.setChristmasMagic(1, "msg");
        try user.unwrapGift() {
            fail();
        } catch Error(string memory error) {
            assertEq(error, "Be good for goodness sake");
        }
    }

    function test_sends_gift_to_caller() public {
        token1.mint(address(user), 1);
        user.safeTransferFrom(
            address(token1),
            address(user),
            address(santaswap),
            1,
            TOKEN1_PROOF
        );
        santa.setChristmasMagic(1, "msg");
        hevm.warp(santaswap.CHRISTMAS_MORNING());
        user.unwrapGift();

        assertEq(token1.balanceOf(address(user)), 1);
    }

    function test_deletes_gift() public {
        token1.mint(address(user), 1);
        user.safeTransferFrom(
            address(token1),
            address(user),
            address(santaswap),
            1,
            TOKEN1_PROOF
        );
        santa.setChristmasMagic(1, "msg");
        hevm.warp(santaswap.CHRISTMAS_MORNING());
        user.unwrapGift();

        (address token, uint256 tokenId) = santaswap.gifts(0);
        assertEq(token, address(0));
        assertEq(tokenId, 0);
    }

    function test_sends_santas_gift_to_caller() public {
        token1.mint(address(user), 1);
        user.safeTransferFrom(
            address(token1),
            address(user),
            address(santaswap),
            1,
            TOKEN1_PROOF
        );
        santa.setChristmasMagic(1, "msg");
        hevm.warp(santaswap.CHRISTMAS_MORNING());
        user.unwrapGift();

        assertEq(santaswap.balanceOf(address(user)), 1);
    }

    function test_sets_claim() public {
        token1.mint(address(user), 1);
        user.safeTransferFrom(
            address(token1),
            address(user),
            address(santaswap),
            1,
            TOKEN1_PROOF
        );
        santa.setChristmasMagic(1, "msg");
        hevm.warp(santaswap.CHRISTMAS_MORNING());
        user.unwrapGift();

        assertTrue(santaswap.claims(address(user)));
    }

    function test_can_only_unwrap_one_gift() public {
        token1.mint(address(user1), 1);
        user1.safeTransferFrom(
            address(token1),
            address(user1),
            address(santaswap),
            1,
            TOKEN1_PROOF
        );

        token2.mint(address(user2), 1);
        user2.safeTransferFrom(
            address(token2),
            address(user2),
            address(santaswap),
            1,
            TOKEN2_PROOF
        );
        santa.setChristmasMagic(2, "msg");
        hevm.warp(santaswap.CHRISTMAS_MORNING());
        user1.unwrapGift();
        try user1.unwrapGift() {
            fail();
        } catch Error(string memory error) {
            assertEq(error, "Already unwrapped");
        }
    }
}

contract TestGiftFor is SantaswapTest {
    function test_no_peeking_before_christmas() public {
        token1.mint(address(user), 1);
        user.safeTransferFrom(
            address(token1),
            address(user),
            address(santaswap),
            1,
            TOKEN1_PROOF
        );
        try santaswap.giftFor(address(user)) {
            fail();
        } catch Error(string memory error) {
            assertEq(error, "No peeking before Christmas");
        }
    }

    function test_returns_zero_for_one_gift() public {
        token1.mint(address(user), 1);
        user.safeTransferFrom(
            address(token1),
            address(user),
            address(santaswap),
            1,
            TOKEN1_PROOF
        );
        hevm.warp(santaswap.CHRISTMAS_MORNING());
        assertEq(santaswap.giftFor(address(user)), 0);
    }

    function test_returns_one_for_two_gifts() public {
        token1.mint(address(user), 1);
        user.safeTransferFrom(
            address(token1),
            address(user),
            address(santaswap),
            1,
            TOKEN1_PROOF
        );

        token2.mint(address(user1), 1);
        user1.safeTransferFrom(
            address(token2),
            address(user1),
            address(santaswap),
            1,
            TOKEN2_PROOF
        );
        hevm.warp(santaswap.CHRISTMAS_MORNING());

        assertEq(santaswap.giftFor(address(user)), 1);
        assertEq(santaswap.giftFor(address(user1)), 0);
    }

    function test_returns_two_for_three_gifts() public {
        token1.mint(address(user), 1);
        user.safeTransferFrom(
            address(token1),
            address(user),
            address(santaswap),
            1,
            TOKEN1_PROOF
        );

        token2.mint(address(user1), 1);
        user1.safeTransferFrom(
            address(token2),
            address(user1),
            address(santaswap),
            1,
            TOKEN2_PROOF
        );

        token3.mint(address(user2), 1);
        user2.safeTransferFrom(
            address(token3),
            address(user2),
            address(santaswap),
            1,
            TOKEN3_PROOF
        );
        hevm.warp(santaswap.CHRISTMAS_MORNING());

        assertEq(santaswap.giftFor(address(user)), 1);
        assertEq(santaswap.giftFor(address(user1)), 2);
        assertEq(santaswap.giftFor(address(user2)), 0);
    }
}

contract TestSetSecret is SantaswapTest {
    function test_sets_magic_secret() public {
        assertEq(santaswap.christmasMagic(), 0);

        santa.setChristmasMagic(123, "msg");

        assertEq(santaswap.christmasMagic(), 123);
    }

    function test_sets_santas_message() public {
        assertEq(santaswap.christmasMagic(), 0);

        santa.setChristmasMagic(123, "msg");

        assertEq(santaswap.santasMessage(), "msg");
    }

    function test_cannot_set_secret_that_returns_gifts_to_senders() public {
        assertEq(santaswap.christmasMagic(), 0);

        token1.mint(address(user), 1);
        user.safeTransferFrom(
            address(token1),
            address(user),
            address(santaswap),
            1,
            TOKEN1_PROOF
        );

        token2.mint(address(user1), 1);
        user1.safeTransferFrom(
            address(token2),
            address(user1),
            address(santaswap),
            1,
            TOKEN2_PROOF
        );

        token3.mint(address(user2), 1);
        user2.safeTransferFrom(
            address(token3),
            address(user2),
            address(santaswap),
            1,
            TOKEN3_PROOF
        );

        try santa.setChristmasMagic(2, "msg") {
            fail();
        } catch Error(string memory error) {
            assertEq(error, "Invalid swap");
        }
    }

    function test_even_santa_cannot_reset_secret() public {
        assertEq(santaswap.christmasMagic(), 0);

        santa.setChristmasMagic(123, "msg");
        assertEq(santaswap.christmasMagic(), 123);

        try santa.setChristmasMagic(456, "msg") {
            fail();
        } catch Error(string memory error) {
            assertEq(error, "Santa already visited");
        }
    }

    function test_only_santa_can_set_secret() public {
        try user.setChristmasMagic(123, "msg") {
            fail();
        } catch Error(string memory error) {
            assertEq(error, "Must be Santa");
        }
    }
}

contract TestTokenMetadata is SantaswapTest {
    function test_fixed_token_uri() public {
        assertEq(santaswap.tokenURI(0), santaswap.tokenURI(1));
    }
}

contract TestManyGifts is SantaswapTest {
    User[] internal users;

    function sendGift(MockERC721 token, uint256 tokenId) public returns (User) {
        User u = new User(address(santaswap));
        token.mint(address(u), tokenId);
        u.safeTransferFrom(
            address(token),
            address(u),
            address(santaswap),
            tokenId,
            TOKEN1_PROOF
        );
        return u;
    }

    function test_everyone_gets_a_gift(uint8 n, uint8 s) public {
        if (n <= 1) return;
        if (s == 0) return;
        if (s == 255) return;
        if ((s + 1) % n == 0) return;
        assertEq(token1.balanceOf(address(santaswap)), 0);

        for (uint8 i = 0; i < n; i++) {
            User u = sendGift(token1, i);
            users.push(u);
            assertEq(token1.balanceOf(address(santaswap)), i + 1);
            assertEq(token1.balanceOf(address(u)), 0);
            assertEq(santaswap.niceList(address(u)), i + 1);
        }

        santa.setChristmasMagic(s, "msg");
        hevm.warp(santaswap.CHRISTMAS_MORNING());

        uint8 sameGift;
        for (uint8 i = 0; i < users.length; i++) {
            users[i].unwrapGift();
            if (santaswap.giftFor(address(users[i])) == i) {
                sameGift++;
            }
            assertEq(token1.balanceOf(address(users[i])), 1);
            assertEq(
                token1.ownerOf(santaswap.giftFor(address(users[i]))),
                address(users[i])
            );
            assertEq(santaswap.balanceOf(address(users[i])), 1);
        }
        assertLt(sameGift, 2);
        assertEq(token1.balanceOf(address(santaswap)), 0);
    }

    function test_cannot_set_invalid_secret(uint8 n, uint8 s) public {
        if (n <= 1) return;
        if (s == 0) return;
        if (s == 255) return;
        if ((s + 1) % n != 0) return;

        for (uint8 i = 0; i < n; i++) {
            User u = sendGift(token1, i);
            users.push(u);
        }

        try santa.setChristmasMagic(s, "msg") {
            fail();
        } catch Error(string memory error) {
            assertEq(error, "Invalid swap");
        }
    }

    function test_incrementing_invalid_secret(uint8 n, uint8 s) public {
        if (n <= 1) return;
        if (s == 0) return;
        if (s == 255) return;
        if ((s + 1) % n != 0) return;
        assertEq(token1.balanceOf(address(santaswap)), 0);

        for (uint8 i = 0; i < n; i++) {
            User u = sendGift(token1, i);
            users.push(u);
            assertEq(token1.balanceOf(address(santaswap)), i + 1);
            assertEq(token1.balanceOf(address(u)), 0);
            assertEq(santaswap.niceList(address(u)), i + 1);
        }

        santa.setChristmasMagic(s + 1, "msg");
        hevm.warp(santaswap.CHRISTMAS_MORNING());

        uint8 sameGift;
        for (uint8 i = 0; i < users.length; i++) {
            users[i].unwrapGift();
            if (santaswap.giftFor(address(users[i])) == i) {
                sameGift++;
            }
            assertEq(token1.balanceOf(address(users[i])), 1);
            assertEq(
                token1.ownerOf(santaswap.giftFor(address(users[i]))),
                address(users[i])
            );
            assertEq(santaswap.balanceOf(address(users[i])), 1);
        }
        assertLt(sameGift, 2);
        assertEq(token1.balanceOf(address(santaswap)), 0);
    }
}
