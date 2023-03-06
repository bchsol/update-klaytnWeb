// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@klaytn/contracts/contracts/KIP/token/KIP7/KIP7.sol";
import "@klaytn/contracts/contracts/KIP/token/KIP17/utils/KIP17Holder.sol";
import "@klaytn/contracts/contracts/KIP/token/KIP17/extensions/KIP17Enumerable.sol";
import "./ContractAccessControl.sol";

contract NFTStaking is KIP17Holder{

    IKIP17Enumerable public nft;
    IKIP7 public rewardToken;

    uint256 decimal = 18;

    uint256 public rate;

    ContractAccessControl accessControls;

    constructor(address _nft, address _rewardToken, uint256 _rate, ContractAccessControl _accessControls) {
        nft = IKIP17Enumerable(_nft);
        rewardToken = IKIP7(_rewardToken);
        rate = _rate * 10**decimal / 1 days;   // 1days == 86400 seconds
        accessControls = _accessControls;
    }

    /**
        Struct to track what user is staking which tokens
        tokenIds are all the tokens staked by the staker
        balance is the current ether balance of the staker
        TokenStakeAt is the last block-timestamp that the staker
        unclaimedRewards is amount of KIP7 Reward Tokens that have not been claimed by the staker.
    */
    struct Staker {
        uint256[] tokenIds;
        uint256 balance;
        uint256 tokenStakeAt;
        uint256 unclaimedRewards;
    }

    /// mapping of a staker to its current properties
    mapping(address => Staker) public stakers;

    /// Mapping from token ID to owner address
    mapping(uint256=>address) public tokenOwner;

    /// event emitted when a user has staked a token
    event Staked(address owner, uint256 amount);

     /// event emitted when a user has unstaked a token
    event Unstaked(address owner, uint256 amount);

     /// event emitted when a user claims reward
    event RewardPaid(address user, uint256 reward);

    /// Function used to stake KIP17 Token
    function stake(uint256 tokenId) external {
        _stake(msg.sender, tokenId);
    }

    /// Function used to stake all your NFTs
    function stakeAll() external {
        uint256 balance = nft.balanceOf(msg.sender);
        uint256[] memory _tokenIds = new uint256[](balance);

        for(uint256 i = 0; i < balance; i++){
            _tokenIds[i] = nft.tokenOfOwnerByIndex(msg.sender, i);
        }

        for(uint256 i = 0; i < balance; i++) {
            _stake(msg.sender, _tokenIds[i]);
        }
    }

    /// All the staking goes through this function
    function _stake(address _user, uint256 _tokenId) internal {
        Staker storage staker = stakers[_user];

        updateRewards(_user);

        staker.balance++;
        staker.tokenIds.push(_tokenId);
        tokenOwner[_tokenId] = _user;

        nft.safeTransferFrom(_user, address(this), _tokenId);

        emit Staked(_user,_tokenId);
    }

    /// Function used to unstake KIP17 Token
    function unstake(uint256 _tokenId) external {
        require(tokenOwner[_tokenId] == msg.sender, "You can't unstake this token");
        //claimRewards(msg.sender);
        _unstake(msg.sender, _tokenId);
    }

    /// Function used to unstake all your NFTs
    function unstakeAll() external {
        Staker storage staker = stakers[msg.sender];

        for(uint i = 0; i < staker.balance; i++) {
            if(tokenOwner[staker.tokenIds[i]] == msg.sender) {
                _unstake(msg.sender, staker.tokenIds[i]);
            }
        }
    }

    /// All the unstaking goes through this function
    function _unstake(address _user, uint256 _tokenId) internal {
        Staker storage staker = stakers[_user];

        claimRewards(_user);

        staker.balance--;
        staker.tokenIds.pop();
        staker.tokenStakeAt = block.timestamp;

        if(staker.balance == 0) {
            delete stakers[_user];
        }
        delete tokenOwner[_tokenId];

        nft.safeTransferFrom(address(this), _user, _tokenId);

        emit Unstaked(_user, _tokenId);
    }

    /// Function used to claim the accrued Reward Tokens.
    function claimRewards(address _user) public {
        Staker storage staker = stakers[_user];

        uint256 rewards = calculateRewards(_user) + staker.unclaimedRewards;
        require(rewards > 0, "You have no rewards to claim");

        staker.tokenStakeAt = block.timestamp;
        staker.unclaimedRewards = 0;

        rewardToken.transfer(_user, rewards);

        emit RewardPaid(_user, rewards);
    }

    /// Function used to calculate the rewards for a user.
    function calculateRewards(address _user) public view returns (uint256){
        uint256 timeElapsed = (block.timestamp - stakers[_user].tokenStakeAt) * stakers[_user].balance;
        return timeElapsed * rate;
    }

    /// Function used to update the rewards for a user
    function updateRewards(address _user) internal {
        Staker storage staker = stakers[_user];

        staker.unclaimedRewards += calculateRewards(_user);
        staker.tokenStakeAt = block.timestamp;
    }

    /// Get the tokens staked by a user
    function getStakedTokens(address _user) external view returns(uint256[] memory tokenIds){
        return stakers[_user].tokenIds;
    }


    /// Owner Function

    ///  Function used to set the amount of Reward Tokens rate
    function setRewardRate(uint256 _rate) external {
        require(accessControls.hasAdminRole(_msgSender()), "Sender must have permission to admin");
        rate = _rate *10**decimal;
    }

}