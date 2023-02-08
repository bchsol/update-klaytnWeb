import axios from "axios";
import { NFTContract, StakeContract, caver } from "./UseCaver";

const fetchMetadata = async (tokenId) => {
  const metadataUrl = await NFTContract.methods.tokenURI(tokenId).call();
  const response = await axios.get(
    `https://gateway.moralisipfs.com/ipfs/${metadataUrl.substring(7)}`
  );
  return response.data;
};

export const fetchStakeNfts = async (address) => {
  const stakedTokens = await StakeContract.methods
    .getStakedTokens(address)
    .call();

  const stakeNfts = await Promise.all(
    stakedTokens.map(async ({ tokenId }) => {
      const { name, image } = await fetchMetadata(tokenId);
      return {
        name,
        uri: `https://gateway.moralisipfs.com/ipfs/${image.substring(7)}`,
        id: tokenId,
      };
    })
  );

  return stakeNfts;
};

export const fetchNfts = async (address) => {
  const balance = await NFTContract.methods.balanceOf(address).call();

  const tokenIds = [];
  for (let i = 0; i < balance; i++) {
    const id = await NFTContract.methods.tokenOfOwnerByIndex(address, i).call();
    tokenIds.push(id);
  }

  const nfts = await Promise.all(
    tokenIds.map(async (tokenId) => {
      const { name, image } = await fetchMetadata(tokenId);
      return {
        name,
        uri: `https://gateway.moralisipfs.com/ipfs/${image.substring(7)}`,
        id: tokenId,
      };
    })
  );

  return nfts;
};

export const getBalance = async (address) => {
  const response = await caver.klay.getBalance(address);
  const balance = caver.utils.convertFromPeb(response);
  return balance;
};
