// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@klaytn/contracts/contracts/KIP/token/KIP17/KIP17.sol";
import "@klaytn/contracts/contracts/utils/Counters.sol";
import "@klaytn/contracts/contracts/security/ReentrancyGuard.sol";

contract MarketPlace is ReentrancyGuard {
  using Counters for Counters.Counter;
  Counters.Counter private _itemIds;
  Counters.Counter private _itemSold;

  address payable owner;

  struct MarketItem{
    uint itemId;
    address nftContract;
    uint256 tokenId;
    address payable seller;
    address payable owner;
    uint256 price;
    bool sold;
  }

  event MarketItemCreate(
    uint itemId,
    address indexed nftContract,
    uint256 indexed tokenId,
    address seller,
    address owner,
    uint256 price,
    bool sold
  );

  mapping(uint256 => MarketItem) private idToMartketItem;

  constructor() {
    owner = payable(msg.sender);
  }

  function createMarketItem(address nftContract, uint256 tokenId, uint256 price) public payable nonReentrant {
    require(price > 0, "Price cannot be zero");
    //require(msg.value == listingFee, "Price must be equal to listing fee");
    _itemIds.increment();
    uint256 itemId = _itemIds.current();
    idToMartketItem[itemId] = MarketItem(itemId, nftContract, tokenId, payable(msg.sender), payable(address(0)),price,false);
    KIP17(nftContract).transferFrom(msg.sender, address(this), tokenId);
    emit MarketItemCreate(itemId, nftContract, tokenId, msg.sender, address(0), price, false);

  }

  function MarketSale(address nftContract, uint256 itemId) public payable nonReentrant{
    uint256 price = idToMartketItem[itemId].price;
    uint256 tokenId = idToMartketItem[itemId].tokenId;
    require(msg.value == price, "Not enough balance");
    idToMartketItem[itemId].seller.transfer(msg.value);
    KIP17(nftContract).transferFrom(address(this),msg.sender,tokenId);
    idToMartketItem[itemId].owner = payable(msg.sender);
    idToMartketItem[itemId].sold = true;
    _itemSold.increment();
    //payable(owner).transfer(listingFee);
  }

  function getAvailaleNft() public view returns (MarketItem[] memory){
    uint itemCount = _itemIds.current();
    uint unsoldItemCount = _itemIds.current() - _itemSold.current();
    uint currentIndex = 0;

    MarketItem[] memory items = new MarketItem[](unsoldItemCount);

    for(uint i=0; i< itemCount; i++){
      if (idToMartketItem[i + 1].owner == address(0)) {
        uint currentId = i + 1;
        MarketItem storage currentItem = idToMartketItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
  }

  function getMyNft() public view returns (MarketItem[] memory) {
    uint totalItemCount = _itemIds.current();
    uint itemCount = 0;
    uint currentIndex = 0;

    for (uint i = 0; i < totalItemCount; i++) {
      if (idToMartketItem[i + 1].owner == msg.sender) {
        itemCount += 1;
      }
    }

    MarketItem[] memory items = new MarketItem[](itemCount);
    for (uint i = 0; i < totalItemCount; i++) {
      if (idToMartketItem[i + 1].owner == msg.sender) {
        uint currentId = i + 1;
        MarketItem storage currentItem = idToMartketItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
    return items;
  }

  function getMyMarketNfts() public view returns (MarketItem[] memory) {
    uint totalItemCount = _itemIds.current();
    uint itemCount = 0;
    uint currentIndex = 0;

    for (uint i = 0; i < totalItemCount; i++) {
      if (idToMartketItem[i + 1].seller == msg.sender) {
        itemCount += 1;
      }
    }

    MarketItem[] memory items = new MarketItem[](itemCount);
    for (uint i = 0; i < totalItemCount; i++) {
      if (idToMartketItem[i + 1].seller == msg.sender) {
        uint currentId = i + 1;
        MarketItem storage currentItem = idToMartketItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
    return items;
  }

}

