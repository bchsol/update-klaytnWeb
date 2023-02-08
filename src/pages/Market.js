import { useState, useEffect } from "react";
import { fetchNfts, fetchStakeNfts } from "../caver/FetchNfts";
import { Row, Col, Card, Button } from "react-bootstrap";
import MarketContractData from "../contracts/MarketContract";
import NFTContractData from "../contracts/MintContract";

import Caver from "caver-js";

const caver = new Caver(window.klaytn);
const MarketContract = new caver.contract(
  MarketContractData.Abi,
  MarketContractData.AddressBaobab
);
const NFTContract = new caver.contract(
  NFTContractData.Abi,
  NFTContractData.AddressBaobab
);
const Market = () => {
  const [myAddress, setMyAddress] = useState(
    window.sessionStorage.getItem("address") || ""
  );

  useEffect(() => {
    const currentAddress = window.klaytn.selectedAddress;

    if (myAddress !== currentAddress) {
      window.sessionStorage.setItem("address", currentAddress);
      setMyAddress(currentAddress);
    }
  }, []);

  const connectWallet = async () => {
    if (window.klaytn) {
      if (window.klaytn.networkVersion === 1001) {
        const tempAccounts = await window.klaytn.enable();
        window.sessionStorage.setItem("address", tempAccounts[0]);
        setMyAddress(tempAccounts[0]);
      } else if (window.klaytn.networkVersion === 8217) {
        // setModalHeader("Network Error");
        // setModalContent("Change to Baobab");
        // setShowModal(true);
      }

      console.log("Connected Kaikas");
    }
  };

  const test = async () => {};
  return (
    <div>
      <Button onClick={connectWallet}>wallet</Button>
      <Button onClick={test}>test</Button>
    </div>
  );
};

export default Market;
