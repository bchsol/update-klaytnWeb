const json = {
  AddressBaobab: "0xf1d5414B34b3316d4A0A0b57aA51a649BB7b4c7b",
  Address: "0x...",
  Abi: [
    {
      inputs: [],
      stateMutability: "nonpayable",
      type: "constructor",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "uint256",
          name: "itemId",
          type: "uint256",
        },
        {
          indexed: true,
          internalType: "address",
          name: "nftContract",
          type: "address",
        },
        {
          indexed: true,
          internalType: "uint256",
          name: "tokenId",
          type: "uint256",
        },
        {
          indexed: false,
          internalType: "address",
          name: "seller",
          type: "address",
        },
        {
          indexed: false,
          internalType: "address",
          name: "owner",
          type: "address",
        },
        {
          indexed: false,
          internalType: "uint256",
          name: "price",
          type: "uint256",
        },
        {
          indexed: false,
          internalType: "bool",
          name: "sold",
          type: "bool",
        },
      ],
      name: "MarketItemCreate",
      type: "event",
    },
    {
      inputs: [
        {
          internalType: "address",
          name: "nftContract",
          type: "address",
        },
        {
          internalType: "uint256",
          name: "itemId",
          type: "uint256",
        },
      ],
      name: "MarketSale",
      outputs: [],
      stateMutability: "payable",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "address",
          name: "nftContract",
          type: "address",
        },
        {
          internalType: "uint256",
          name: "tokenId",
          type: "uint256",
        },
        {
          internalType: "uint256",
          name: "price",
          type: "uint256",
        },
      ],
      name: "createMarketItem",
      outputs: [],
      stateMutability: "payable",
      type: "function",
    },
    {
      inputs: [],
      name: "getAvailaleNft",
      outputs: [
        {
          components: [
            {
              internalType: "uint256",
              name: "itemId",
              type: "uint256",
            },
            {
              internalType: "address",
              name: "nftContract",
              type: "address",
            },
            {
              internalType: "uint256",
              name: "tokenId",
              type: "uint256",
            },
            {
              internalType: "address payable",
              name: "seller",
              type: "address",
            },
            {
              internalType: "address payable",
              name: "owner",
              type: "address",
            },
            {
              internalType: "uint256",
              name: "price",
              type: "uint256",
            },
            {
              internalType: "bool",
              name: "sold",
              type: "bool",
            },
          ],
          internalType: "struct MarketPlace.MarketItem[]",
          name: "",
          type: "tuple[]",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "getMyMarketNfts",
      outputs: [
        {
          components: [
            {
              internalType: "uint256",
              name: "itemId",
              type: "uint256",
            },
            {
              internalType: "address",
              name: "nftContract",
              type: "address",
            },
            {
              internalType: "uint256",
              name: "tokenId",
              type: "uint256",
            },
            {
              internalType: "address payable",
              name: "seller",
              type: "address",
            },
            {
              internalType: "address payable",
              name: "owner",
              type: "address",
            },
            {
              internalType: "uint256",
              name: "price",
              type: "uint256",
            },
            {
              internalType: "bool",
              name: "sold",
              type: "bool",
            },
          ],
          internalType: "struct MarketPlace.MarketItem[]",
          name: "",
          type: "tuple[]",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "getMyNft",
      outputs: [
        {
          components: [
            {
              internalType: "uint256",
              name: "itemId",
              type: "uint256",
            },
            {
              internalType: "address",
              name: "nftContract",
              type: "address",
            },
            {
              internalType: "uint256",
              name: "tokenId",
              type: "uint256",
            },
            {
              internalType: "address payable",
              name: "seller",
              type: "address",
            },
            {
              internalType: "address payable",
              name: "owner",
              type: "address",
            },
            {
              internalType: "uint256",
              name: "price",
              type: "uint256",
            },
            {
              internalType: "bool",
              name: "sold",
              type: "bool",
            },
          ],
          internalType: "struct MarketPlace.MarketItem[]",
          name: "",
          type: "tuple[]",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
  ],
};
export default json;
