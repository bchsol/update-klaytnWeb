import { useState } from "react";
import { Modal, Button } from "react-bootstrap";
import ToggleButtons from "./LotteryButton";
import { LotteryContract, caver } from "../caver/UseCaver";

const LotteryBuyModal = (props) => {
  const [userAddress, setUserAddress] = useState(
    localStorage.getItem("userAddress")
  );
  const [numbers, setNumbers] = useState();

  const BuyTicket = async (numbers) => {
    caver.klay
      .sendTransaction({
        type: "SMART_CONTRACT_EXECUTION",
        from: userAddress,
        to: LotteryContract._address,
        data: LotteryContract.methods.buy(numbers).encodeABI(),
        value: caver.utils.toPeb(1, "KLAY"),
        gas: "300000",
      })
      .once("receipt", (receipt) => {
        console.log("receipt", receipt);
      })
      .once("error", (error) => {
        console.log("error", error);
      });
  };

  return (
    <>
      <Modal
        {...props}
        size="lg"
        aria-labelledby="contained-modal-title-vcenter"
        centered
      >
        <Modal.Header closeButton>
          <Modal.Title id="contained-modal-title-vcenter">
            Buy Ticket
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <h4>Pick 6 numbers</h4>
          <ToggleButtons setNumbers={setNumbers} />
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={() => BuyTicket(numbers)}>Buy</Button>
          <Button onClick={props.onHide}>Close</Button>
        </Modal.Footer>
      </Modal>
    </>
  );
};

export default LotteryBuyModal;
