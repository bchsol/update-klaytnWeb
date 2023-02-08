import { useState } from "react";
import * as s from "../Style/globalStyles";
import { Button } from "react-bootstrap";
import Caver from "caver-js";
//import LotteryContractData from "../contracts/LotteryContract";

import ToggleButton from "../utils/LotteryButton";

const caver = new Caver(window.klaytn);

// const LotteryContract = new caver.contract(
//   LotteryContractData.Abi,
//   LotteryContractData.AddressBaobab
// );

function Lottery() {
  const [numbers, setNumbers] = useState();
  const [myAddress, setMyAddress] = useState(
    window.sessionStorage.getItem("address") || ""
  );
  const BuyTicket = async (numbers) => {
    //console.log(numbers);
    // caver.klay
    //   .sendTransaction({
    //     // senderRawTransaction: senderRawTransaction,
    //     // feePayer: feePayer.address,
    //     type: "SMART_CONTRACT_EXECUTION",
    //     from: myAddress,
    //     to: LotteryContract,
    //     data: LotteryContract.methods.buy(numbers).encodeABI(),
    //     value: 0,
    //     gas: "300000",
    //   })
    //   .once("receipt", (receipt) => {
    //     console.log("receipt", receipt);
    //   })
    //   .once("error", (error) => {
    //     console.log("error", error);
    //   });
  };
  return (
    <s.Screen>
      <s.Container
        flex={1}
        ai={"center"}
        style={{
          backgroundImage: "url(images/homebg.jpg)",
          textAlign: "center",
        }}
      >
        <span
          className="Title"
          style={{ fontSize: 30, fontWeight: "bold", marginTop: "25vmin" }}
        >
          로또
        </span>
        <br />
        {/* <LotteryButtonGroup setNumbers={setNumbers} /> */}
        <ToggleButton setNumbers={setNumbers} />

        <Button onClick={() => BuyTicket(numbers)}>test</Button>
      </s.Container>
    </s.Screen>
  );
}
export default Lottery;
