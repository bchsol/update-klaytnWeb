import { useState, useEffect } from "react";
import * as s from "../Style/globalStyles";
import { Button } from "react-bootstrap";

import LotteryBuyModal from "../utils/LotteryBuyModal";
import { LotteryContract } from "../caver/UseCaver";

function Lottery() {
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [rounds, setRounds] = useState([]);
  const [userAddress, setUserAddress] = useState("");

  let roundCount = 0;

  useEffect(() => {
    const currentAddress = window.klaytn.selectedAddress;
    if (userAddress !== currentAddress) {
      setUserAddress(currentAddress);
      localStorage.setItem("userAddress", currentAddress);
    }
    console.log(userAddress);
  }, [userAddress]);

  useEffect(() => {
    const getDate = (timeStamp) => {
      const milliSecToSec = new Date(timeStamp * 1000);
      return milliSecToSec.toLocaleString();
    };

    const getRound = async () => {
      var _round;
      do {
        _round = await LotteryContract.methods.rounds(roundCount).call();
        roundCount++;
      } while (_round.status == true);
      _round.startTime = getDate(_round.startTime);
      _round.endTime = getDate(_round.endTime);
      setRounds(_round);
    };
    getRound();
  }, []);

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

        <Button onClick={() => setIsModalOpen(true)}>티켓 구매</Button>
        <LotteryBuyModal
          show={isModalOpen}
          onHide={() => setIsModalOpen(false)}
        />
        <h4>시작시간 {rounds.startTime}</h4>
        <h4>종료시간 {rounds.endTime}</h4>
        <h4>응모현황 : {rounds.totalQuantity}</h4>

        <h4>{rounds.status == true ? "완료" : "추첨 전"}</h4>
      </s.Container>
    </s.Screen>
  );
}
export default Lottery;
