// import Caver from "caver-js";

//const userAddress = JSON.parse(localStorage.getItem("userAddress"));
// const caver = new Caver(userAddress);

export const connectWallet = async () => {
  if (window.klaytn) {
    if (window.klaytn.networkVersion === 1001) {
      // baobab
      console.log("kaikas enable");
      const wallet = await window.klaytn.enable();
      localStorage.setItem("userAddress", wallet[0]);
    }
  }
};
