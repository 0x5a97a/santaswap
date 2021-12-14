# <h1 align="center">🎅🏻 Santaswap 🎄</h1>

![Github Actions](https://github.com/0x53616e746120436c617573/santaswap/workflows/Tests/badge.svg)

Experimental, unaudited, no roadmap, no fees, no Discord, no DAO, absolutely no promises, but I want to wish you a Merry Christmas.

## How it works

Send an ERC721 token to Santaswap before Santa visits on Christmas Eve and your address will be added to Santa's nice list. 
You may only send one token. You must use `safeTransferFrom` to be added to the nice list.
You must provide a Merkle proof that the token is
on Santa's Christmas tree in the `data` parameter of the transfer.
Do not send ERC20 or ERC1155 tokens to Santaswap.

Santa will visit on Christmas Eve, set a magic number, and leave a message.
He has already chosen his magic number.
It's possible that Santa's chosen number would make everyone get their original gift back. If that's the case, Santa will increment his number by one.
You should believe in Santa, but if you don't, you can verify that `keccak256(santasMessage)` is equal to `SANTAS_MESSAGE_HASH`.

If your address is on Santa's nice list, you may unwrap a gift on `CHRISTMAS_MORNING` after Santa has visited. 
You will receive a random ERC721 token contributed by another Santaswapper, plus a special gift from Santa. 
You may unwrap your gift only once.