import Caver from "caver-js";
import StakeContractData from "../contracts/StakingContract";
import NFTContractData from "../contracts/MintContract";
import LotteryContractData from "../contracts/LotteryContract";

export const caver = new Caver(window.klaytn);

export const StakeContract = new caver.contract(
  StakeContractData.Abi,
  StakeContractData.AddressBaobab
);

export const NFTContract = new caver.contract(
  NFTContractData.Abi,
  NFTContractData.AddressBaobab
);

export const LotteryContract = new caver.contract(
  LotteryContractData.Abi,
  LotteryContractData.AddressBaobab
);
