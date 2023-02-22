// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@klaytn/contracts/contracts/access/Ownable.sol";
import "@klaytn/contracts/contracts/KIP/token/KIP7/IKIP7.sol";

contract Lottery is Ownable {

  IKIP7 public token;

  struct Round {
    uint256 startTime;  // 시작시간
    uint256 endTime;  // 종료 시간
    RoundStatus status; // 라운드 상태
    uint256[7] winNumbers; // 당첨번호 마지막번호는 보너스번호
    uint256 totalQuantity; // 총개수
  }

  enum RoundStatus {
    Start,
    End
  }

  struct Ticket {
    address owner;  // 티켓 구매자
    uint256 round;
    uint256[6] number; // 로또번호
  }


  uint256 public TICKET_PRICE;
  uint256 public TICKET_TOKEN_PRICE;
  uint256 constant public MIN_NUMBER = 1;
  uint256 constant public MAX_NUMBER = 45;
  Round[] public rounds;
  Ticket[] public tickets;

  uint256 public round_interval;  // 라운드 기간

  uint256 public currentBlock;

  constructor(address _token, uint256 _round_interval, uint256 _ticket_price, uint256 _ticket_token_price) {
    token = IKIP7(_token);
    round_interval = _round_interval;
    TICKET_PRICE = _ticket_price;
    TICKET_TOKEN_PRICE = _ticket_token_price;
    createRound();
  }



  // 클레이튼 기준 1일 = 86400 블럭
  function createRound() internal {
    if(rounds.length > 0 && rounds[rounds.length - 1].status != RoundStatus.End) {
      revert("Round in progress");
    }

    uint256[7] memory winNum;
    
    Round memory round = Round(
      block.timestamp,
      block.timestamp + round_interval,
      RoundStatus.Start,
      winNum,
      0
    );

    rounds.push(round);
  }

  // 토큰으로 구매
  function tokenBuy(uint256[6] memory numbers) public {
    require(rounds[rounds.length - 1].endTime >= block.timestamp, "Round End");
    require(rounds[rounds.length - 1].status != RoundStatus.End, "Round End");
    require(token.balanceOf(msg.sender) >= TICKET_TOKEN_PRICE, "Not valid value");

    // 숫자 중복 검사
    for(uint256 i = 0; i < numbers.length - 1; i++) {
      for(uint256 j = i+1; j < numbers.length; j++) {
        require(numbers[i] != numbers[j]);
      }
    }
    

    // 0~45 검사
    for(uint256 i = 0; i < numbers.length; i++) {
      require(numbers[i] >= MIN_NUMBER && numbers[i] <= MAX_NUMBER, "Only numbers 0 ~ 45 can be entered");
    }

    // token.approve(address(this), TICKET_TOKEN_PRICE);

    token.transferFrom(msg.sender, address(this), TICKET_TOKEN_PRICE);

    Ticket memory ticket = Ticket(
      msg.sender,
      rounds.length-1,
      numbers
    );

    tickets.push(ticket);

    rounds[rounds.length - 1].totalQuantity += 1;
  }

  function buy(uint256[6] memory numbers) public payable {
    require(rounds[rounds.length - 1].endTime >= block.timestamp, "Round End");
    require(rounds[rounds.length - 1].status != RoundStatus.End, "Round End");
    require(msg.value == TICKET_PRICE, "Not valid value");

    // 숫자 중복 검사
    for(uint256 i = 0; i < numbers.length - 1; i++) {
      for(uint256 j = i+1; j < numbers.length; j++) {
        require(numbers[i] != numbers[j]);
      }
    }
    

    // 0~45 검사
    for(uint256 i = 0; i < numbers.length; i++) {
      require(numbers[i] >= MIN_NUMBER && numbers[i] <= MAX_NUMBER, "Only numbers 0 ~ 45 can be entered");
    }

    Ticket memory ticket = Ticket(
      msg.sender,
      rounds.length-1,
      numbers
    );

    tickets.push(ticket);

    rounds[rounds.length - 1].totalQuantity += 1;
  }


  // keccak256를 이용한 랜덤값 추출
  function drawNumbers() internal {
    uint256 drawBlock = rounds[rounds.length - 1].endTime;

    require(block.timestamp > rounds[rounds.length - 1].endTime);
    require(rounds[rounds.length - 1].winNumbers[0] == 0);

    uint256 i = 0;
    uint256 seed = 0;

    while(i < 7) {
      bytes32 source = blockhash(drawBlock);

      bytes memory encodedSource = abi.encode(source,seed);
      bytes32 _rand = keccak256(encodedSource);
      uint256 numberDraw = (uint256(_rand) % MAX_NUMBER) + 1;

      bool duplicate = false;
      for(uint256 j = 0; j < i; j++) {
        if(numberDraw == rounds[rounds.length - 1].winNumbers[j]) {
          duplicate = true;
          seed++;
          break;
        }
      }
      if(duplicate) continue;

      rounds[rounds.length - 1].winNumbers[i] = numberDraw;
      i++;
      seed++;
    }
    bytes32 source = blockhash((drawBlock));
    bytes memory encodedSource = abi.encode(source, seed);
    bytes32 _rand = keccak256(encodedSource);
    uint256 bonusNumber = (uint256(_rand) % MAX_NUMBER) + 1;
    rounds[rounds.length - 1].winNumbers[6] = bonusNumber;
  }

  // 상금 지급
  function claim(uint256 number) public {
    require(tickets[number].owner == msg.sender);
    require(rounds[tickets[number].round].status == RoundStatus.End);
    
    uint256[6] storage myNumbers = tickets[number].number;
    uint256[7] storage winNumbers = rounds[rounds.length - 1].winNumbers;

    uint256 reward = 0;
    uint256 numberMatches = 0;
    bool bonusNumMatches;

    for(uint256 i = 0; i < myNumbers.length; i++) {
      for(uint256 j = 0; j < winNumbers.length - 1; j++) {
        if(myNumbers[i] == winNumbers[j])
          numberMatches++;
        if(myNumbers[i] == winNumbers[6])
          bonusNumMatches = true;
      }
    }
        

      // 상금풀 설정
      // 1등
      if(numberMatches == 6) {
        //reward = address(this).balance * 75 / 100;
        reward = address(this).balance;
      } else if(numberMatches == 5 && bonusNumMatches) {   
        // 2등
        //reward += address(this).balance * 125 / 1000; 
      } else if(numberMatches == 5) {
        // 3등
        //reward += address(this).balance * 125 / 1000;
      } else if(numberMatches == 4) {
        // 4등

      } else if(numberMatches == 3) {
        // 5등

      } else {
        // 꽝
      }

    delete tickets[number];  // 당첨 티켓 삭제
    payable(msg.sender).transfer(reward); // 상금 지급
  }

  // 라운드 종료
  function closeRound() internal {
    // 이미 라운드 종료됨
    if(rounds[rounds.length - 1].status == RoundStatus.End)
      revert("Round already ended");

    // 라운드 종료 시간이 아님
    if(block.timestamp < rounds[rounds.length - 1].endTime)
      revert("The round not endtime");

    rounds[rounds.length - 1].status = RoundStatus.End;   // 라운드 상태를 종료로

    drawNumbers();  // 추첨 시작
  }

  // 다음 라운드 시작
  function nextRound() external onlyOwner{
    if(rounds.length > 0) {
      closeRound();
    }

    createRound();
  }

  // 자신의 복권 조회
  function getMyTicket(uint256 _round) public view returns(uint[6][] memory){

    uint256 myTicketLen = 0;
    uint256 arrayCnt = 0;

   for(uint i = 0; i < tickets.length; i++){
       if(tickets[i].owner == msg.sender && tickets[i].round == _round){
           myTicketLen++;
       }
   }

   uint[6][] memory numbers = new uint[6][](myTicketLen);

    for(uint i = 0; i < tickets.length; i++){
       if(tickets[i].owner == msg.sender && tickets[i].round == _round){
           numbers[arrayCnt] = tickets[i].number;
           arrayCnt++;
       }
   }

   return numbers;
  }


  // 당첨번호 조회
  function getWinNumbers(uint256 _round) public view returns(uint256[7] memory) {
    return rounds[_round].winNumbers;
  }

  function getContractBalance() public view returns(uint) {
    return address(this).balance;
  }

  function Stop() public onlyOwner{
    rounds[rounds.length - 1].status = RoundStatus.End;
    drawNumbers();
    createRound();
  }

  function changeInterval(uint256 _interval) external onlyOwner{
    round_interval = _interval;
  }

  function changePrice(uint256 _price) external onlyOwner {
    TICKET_PRICE = _price;
  }

  function tokenWithdraw(address payable toAdress) external onlyOwner {
    token.transfer(toAdress, token.balanceOf(address(this)));
  }

}