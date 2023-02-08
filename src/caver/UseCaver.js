import Caver from "caver-js";
import StakeContractData from "../contracts/StakingContract";
import NFTContractData from "../contracts/MintContract";

export const caver = new Caver(window.klaytn);

export const StakeContract = new caver.contract(
  StakeContractData.Abi,
  StakeContractData.AddressBaobab
);

export const NFTContract = new caver.contract(
  NFTContractData.Abi,
  NFTContractData.AddressBaobab
);
