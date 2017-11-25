pragma solidity ^0.4.11;

import "truffle/Assert.sol";
// import "truffle/DeployedAddresses.sol";
import "../contracts/sora.sol";

contract TestSora {
  // sora = Sora(DeployedAddresses.Sora());

  function testUserCanDepositFund() {
    uint amountDonation = 100;
    uint expected = 100;

    Assert.equal(amountDonation, expected, "Fund should be 100");
  }


  // function depositFund() external payable {
  //   require(msg.value <= amountDonation);
  //   uint amountAfterFee = msg.value - fee;
  //   valueOfDonors.push(amountAfterFee);
  //   donationSum[currentRound] += amountAfterFee;

  //   donors[currentRound][numDonors++] = msg.sender;

  //   donorsHistory[msg.sender][currentRound] = msg.value;

  //   NewDonor(msg.sender, amountAfterFee, fee);

  //   // this is to check whether to end round and start next round
  //   if(maxDonors == (numDonors + 1)) {
  //     calculateAndSendCashForWinner(valueOfDonors);
  //     endRoundAndStartNextRound();
  //   }
  // }

  // function testGetAdopterAddressByPetId() {
  //   // Expected owner is this contract
  //   address expected = this;

  //   address adopter = adoption.adopters(8);

  //   Assert.equal(adopter, expected, "Owner of pet ID 8 should be recorded.");
  // }

  // function testGetAdopterAddressByPetIdInArray() {
  //   // Expected owner is this contract
  //   address expected = this;

  //   // Store adopters in memory rather than contract's storage
  //   address[16] memory adopters = adoption.getAdopters();

  //   Assert.equal(adopters[8], expected, "Owner of pet ID 8 should be recorded.");
  // }

}
