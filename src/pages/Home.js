import * as s from "../Style/globalStyles";

function Home() {
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
          메인화면
        </span>
        <br />
        <div style={{ fontSize: 20 }}>
          <p>Mint : 민팅페이지로 넘어갑니다</p>
          <p>Staking : NFT를 스테이킹하고 코인을 받습니다.</p>
        </div>
      </s.Container>
    </s.Screen>
  );
}

export default Home;
