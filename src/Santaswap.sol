// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

/*
                                    ██████                      
                              ██████▒▒▒▒▒▒████                  
                          ████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                
                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██              
                      ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒██            
                    ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▒▒██            
                  ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██          
                ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▓██          
                ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▓██        
              ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓██  ██▓▓▓▓▓▓██        
            ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓██    ██▓▓▓▓▓▓██      
            ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓██      ██▓▓▓▓▓▓      
          ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓██        ██▓▓▓▓██    
        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██        ████████    
    ████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██      ██      ██  
  ██    ████▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██    ██          ██
  ██        ██▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██    ██          ██
██            ██████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██      ██      ██  
██                  ██████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓██        ██████    
██                            ██▓▓▓▓▓▓▓▓▓▓▓▓██                  
██                              ██████████████                  
  ██                                        ██                  
    ██████                                    ██                
          ████                                ██                
              ██████                          ██                
                    ████████████            ██                  
                                ████████████                    
 _____             _                                
/  ___|           | |                               
\ `--.  __ _ _ __ | |_ __ _ _____      ____ _ _ __  
 `--. \/ _` | '_ \| __/ _` / __\ \ /\ / / _` | '_ \ 
/\__/ / (_| | | | | || (_| \__ \\ V  V / (_| | |_) |
\____/ \__,_|_| |_|\__\__,_|___/ \_/\_/ \__,_| .__/ 
                                             | |    
                                             |_|   
*/

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Santaswap
 * @author 0x5a97a
 * @notice Merry Christmas to all, and to all a good swap!
 */
contract Santaswap is ERC721, IERC721Receiver, Ownable {
    struct Gift {
        address token;
        uint256 tokenId;
    }

    Gift[] public gifts;
    mapping(address => uint256) public niceList;
    mapping(address => bool) public claims;

    uint256 public christmasMagic;
    string public santasMessage;
    bytes32 public immutable christmasTree;

    uint256 public constant CHRISTMAS_MORNING = 1640426400;
    bytes32 public constant SANTAS_MESSAGE_HASH =
        0x58a354cd0b2b6a958c831c33dcadece99ddaf8fb4b9290946a9b5a1d83640134;

    constructor(bytes32 merkleRoot) ERC721("Santaswap 2021", "SANTA") {
        christmasTree = merkleRoot;
    }

    modifier onlySanta() {
        require(owner() == _msgSender(), "Must be Santa");
        _;
    }

    /**
     * @notice Send an ERC721 token to Santaswap and your
     * address will be added to Santa's nice list. You may only
     * send one token. You must use `safeTransferFrom` to be added to
     * the nice list. You must provide a Merkle proof that the token
     * is on Santa's Christmas tree in the `data` parameter.
     * Do not send ERC20 or ERC1155 tokens to Santaswap.
     */
    function onERC721Received(
        address,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        require(_verifyProof(data, msg.sender), "Token is not on the tree");
        require(_verifyTransfer(msg.sender, tokenId), "Coal for you");
        require(niceList[from] == 0, "You are on the list");
        require(christmasMagic == 0, "Santa already visited");

        gifts.push(Gift({token: msg.sender, tokenId: tokenId}));
        niceList[from] = gifts.length;

        return this.onERC721Received.selector;
    }

    /**
     * @notice If your address is on Santa's nice list, you may unwrap a
     * gift on CHRISTMAS_MORNING after Santa has visited. You will receive
     * a random ERC721 token contributed by another Santaswapper plus a
     * special gift from Santa. You may unwrap your gift only once.
     */
    function unwrapGift() external {
        require(!claims[msg.sender], "Already unwrapped");
        require(niceList[msg.sender] != 0, "Not on the nice list");
        require(christmasMagic != 0, "Santa has not visited yet");
        require(
            block.timestamp >= CHRISTMAS_MORNING,
            "Be good for goodness sake"
        );

        claims[msg.sender] = true;
        uint256 id = giftFor(msg.sender);
        Gift memory gift = gifts[id];
        delete gifts[id];

        _mint(msg.sender, niceList[msg.sender]);
        IERC721(gift.token).transferFrom(
            address(this),
            msg.sender,
            gift.tokenId
        );
    }

    /**
     * @notice Santa will visit on Christmas Eve, set a magic number,
     * and leave a message. He has already chosen this magic number.
     * It's possible that Santa's chosen number would make everyone get their
     * original gift back. If that's the case, Santa will increment his
     * number by one. You should believe in Santa, but if you don't,
     * you can verify that keccak256(santasMessage) == SANTAS_MESSAGE_HASH.
     */
    function setChristmasMagic(uint256 secret, string calldata message)
        external
        onlySanta
    {
        require(christmasMagic == 0, "Santa already visited");
        if (gifts.length > 1) {
            require(_rotate(1, secret) != 0, "Invalid swap");
        }
        christmasMagic = secret;
        santasMessage = message;
    }

    function totalGifts() external view returns (uint256) {
        return gifts.length;
    }

    function giftFor(address addr) public view returns (uint256) {
        require(
            block.timestamp >= CHRISTMAS_MORNING,
            "No peeking before Christmas"
        );
        return _rotate(niceList[addr], christmasMagic);
    }

    function tokenURI(uint256) public pure override returns (string memory) {
        return
            "data:application/json;base64,eyJuYW1lIjoiU2FudGFzd2FwIDIwMjEiLCJkZXNjcmlwdGlvbiI6Ik1lcnJ5IENocmlzdG1hcyB0byBhbGwsIGFuZCB0byBhbGwgYSBnb29kIHN3YXAhIiwiaW1hZ2UiOiJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lJSEJ5WlhObGNuWmxRWE53WldOMFVtRjBhVzg5SW5oTmFXNVpUV2x1SUcxbFpYUWlJSFpwWlhkQ2IzZzlJakFnTUNBek5UQWdNelV3SWo0OGMzUjViR1UrTG5SN1ptOXVkQzF6YVhwbE9qUTRjSFE3Wm05dWRDMW1ZVzFwYkhrNklraGxiSFpsZEdsallTQk9aWFZsSWl4SVpXeDJaWFJwWTJFc1FYSnBZV3dzYzJGdWN5MXpaWEpwWmp0bWIyNTBMWGRsYVdkb2REbzRNREE3YkdWMGRHVnlMWE53WVdOcGJtYzZMUzR3TldWdE8zMHVaWHRtYjI1MExYTnBlbVU2T1Rad2REdDlQQzl6ZEhsc1pUNDhaR1ZtY3o0OGJHbHVaV0Z5UjNKaFpHbGxiblFnYVdROUltSWlJR2R5WVdScFpXNTBWSEpoYm5ObWIzSnRQU0p5YjNSaGRHVW9NVEExS1NJK1BITjBiM0FnYjJabWMyVjBQU0kxSlNJZ2MzUnZjQzFqYjJ4dmNqMGlkMmhwZEdVaUx6NDhjM1J2Y0NCdlptWnpaWFE5SWpZd0pTSWdjM1J2Y0MxamIyeHZjajBpSTBaR1JrWkdNQ0l2UGp3dmJHbHVaV0Z5UjNKaFpHbGxiblErUEd4cGJtVmhja2R5WVdScFpXNTBJR2xrUFNKeUlpQm5jbUZrYVdWdWRGUnlZVzV6Wm05eWJUMGljbTkwWVhSbEtERXdOU2tpUGp4emRHOXdJRzltWm5ObGREMGlOU1VpSUhOMGIzQXRZMjlzYjNJOUlpTTRRakF3TURBaUx6NDhjM1J2Y0NCdlptWnpaWFE5SWprMUpTSWdjM1J2Y0MxamIyeHZjajBpY21Wa0lpOCtQQzlzYVc1bFlYSkhjbUZrYVdWdWRENDhMMlJsWm5NK1BISmxZM1FnZDJsa2RHZzlJakV3TUNVaUlHaGxhV2RvZEQwaU1UQXdKU0lnWm1sc2JEMGlkWEpzS0NjallpY3BJaTgrUEhSbGVIUWdlRDBpTlRBbElpQjVQU0l5TUNVaUlHTnNZWE56UFNKMElpQm1hV3hzUFNKMWNtd29KeU55SnlraUlIUmxlSFF0WVc1amFHOXlQU0p0YVdSa2JHVWlQbE5oYm5SaGMzZGhjRHd2ZEdWNGRENDhkR1Y0ZENCNFBTSTFNQ1VpSUhrOUlqWTFKU0lnWTJ4aGMzTTlJbVVpSUhSbGVIUXRZVzVqYUc5eVBTSnRhV1JrYkdVaVB2Q2Zqb1h3bjQrN1BDOTBaWGgwUGp4MFpYaDBJSGc5SWpVd0pTSWdlVDBpT1RBbElpQmpiR0Z6Y3owaWRDSWdabWxzYkQwaWRYSnNLQ2NqY2ljcElpQjBaWGgwTFdGdVkyaHZjajBpYldsa1pHeGxJajd3bjQ2RUlESXdNakVnOEorT2dUd3ZkR1Y0ZEQ0OEwzTjJaejQ9In0=";
    }

    function _rotate(uint256 idx, uint256 n) internal view returns (uint256) {
        return (idx + n) % gifts.length;
    }

    function _verifyProof(bytes calldata data, address token)
        internal
        view
        returns (bool)
    {
        return
            MerkleProof.verify(
                abi.decode(data, (bytes32[])),
                christmasTree,
                keccak256(abi.encodePacked(token))
            );
    }

    function _verifyTransfer(address token, uint256 tokenId)
        internal
        view
        returns (bool)
    {
        return IERC721(token).ownerOf(tokenId) == address(this);
    }
}
