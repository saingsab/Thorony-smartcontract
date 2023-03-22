// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IERC20 {
    function transfer(address recipient, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
}

contract StakingERC1155 is ERC1155Holder, Ownable{
    IERC1155 public token;
    IERC20 public rewardToken;
    mapping(uint256 => address) public tokenOwnerOf; // who's the owner of each tokenId
    mapping(uint256 => uint256) public tokenStakedAtTime; // time at which token was staked
    mapping(uint256 => uint256) public tokenAmountStaked; // how much amount of each tokenId is staked

    constructor(address _token, address _rewordToken) {
        token = IERC1155(_token);
        rewardToken = IERC20(_rewordToken);
    }

    function stakeNFT(uint tokenId, uint amount) external{
        token.safeTransferFrom(msg.sender, address(this), tokenId, amount, "0x"); // from, to, id, amount, data
        tokenOwnerOf[tokenId] = msg.sender;
        tokenStakedAtTime[tokenId] = block.timestamp;
        tokenAmountStaked[tokenId] = amount;
    }

    function stakeBatchNFT(uint[] memory tokenId, uint[] memory amount) external{
        token.safeBatchTransferFrom(msg.sender, address(this), tokenId, amount, "0x"); // from, to, id, amount, data
        for(uint i = 0; i < tokenId.length; i++)
        {
            tokenOwnerOf[tokenId[i]] = msg.sender;
            tokenStakedAtTime[tokenId[i]] = block.timestamp;
            tokenAmountStaked[tokenId[i]] = amount[i];
        }
    }

    function unstakeNFT(uint tokenId, uint amount) external{
        require(tokenOwnerOf[tokenId] == msg.sender);
       // _mint(msg.sender, );
       //address sender, address recipient, uint amount
       //transfer(address recipient, uint amount) external returns (bool);
        IERC20 _rewardToken = IERC20(rewardToken);
        _rewardToken.transfer(msg.sender, calculateTokens(tokenId)); // transferFrom(address(this), msg.sender, calculateTokens(tokenId));
        token.safeTransferFrom(address(this), msg.sender, tokenId, amount, "0x");
        delete tokenOwnerOf[tokenId];
        delete tokenStakedAtTime[tokenId];
    }

    function unstakeBatchNFT(uint[] memory tokenId, uint[] memory amount) external{
        for(uint i = 0; i < tokenId.length; i++)
        {
            require(tokenOwnerOf[tokenId[i]] == msg.sender);
        }
        token.safeBatchTransferFrom(address(this), msg.sender, tokenId, amount, "0x");
        for(uint i = 0; i < tokenId.length; i++)
        {
           // _mint(msg.sender, calculateTokens(tokenId[i]));
            IERC20(rewardToken).transferFrom(address(this), msg.sender, calculateTokens(tokenId[i]));
            delete tokenOwnerOf[tokenId[i]];
            delete tokenStakedAtTime[tokenId[i]];
        }
    }

    function calculateTokens(uint tokenId) public view returns(uint256){
        require(tokenOwnerOf[tokenId] != address(0), "No token staked with given token ID");
        uint amount = tokenAmountStaked[tokenId];
        uint timeElapsed = block.timestamp - tokenStakedAtTime[tokenId];
        uint interestRate;
        if(timeElapsed <= 30 days )
        {
            interestRate = 5; // 5% interest rate for upto 1 month (30 days)
        }
        else if(timeElapsed <= 26 weeks)
        {
            interestRate = 10; // 10% interest rate for upto 6 months
        }
        else if(timeElapsed <= 52 weeks)
        {
            interestRate = 15; // 15% interest rate for upto 1 year (52 weeks)
        }
        else interestRate = 18; // 18% fixed interest rate after 1 year
        return (timeElapsed*interestRate)*(amount)*(10**18)/100; // ERC20: 1 token = 10^18 subtokens
    }
}
