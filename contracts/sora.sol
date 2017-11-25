// https://github.com/cillionaire/cillionaire2
pragma solidity ^0.4.4;

contract owned {

    address public owner;
    mapping (address => uint256) public balanceOf;

    event ContractOwnershipTransferred(address newOwner);

    function owned() { owner = msg.sender; }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function setContractOwner(address newOwner) external onlyOwner {
        owner = newOwner;
        ContractOwnershipTransferred(newOwner);
    }
}

contract mortal is owned {

    function kill() onlyOwner {
        selfdestruct(owner);
    }
}

contract Sora is mortal {

	uint public startTimestamp;
    uint public endTimestamp;
    uint public maxDonors;
    uint public duration;
    uint public donation;
    uint public fee;
	uint public amountDonation;
	uint[] public donationSum;
	uint public numDonors;
	uint public currentRound;
	address[][] public donors;
	mapping (address => mapping (uint => uint)) donorsHistory;

	address public beneficiary;

	event NewDonor(address _donor, uint _donationAfterFee, uint _fee);
	event RoundEnded(uint _donationSum);

	function Sora() {
		fee = 0 ether;
		duration = 1 days;
		maxDonors = 4;
		amountDonation = 10 ether;
		numDonors = 0;
		currentRound = 0;
		donationSum[currentRound] = 0;
	}

	function depositFund() external payable {
		require(msg.value <= amountDonation);
		uint amountAfterFee = msg.value - fee;
		donationSum[currentRound] += amountAfterFee;

		donors[currentRound][numDonors++] = msg.sender;

		donorsHistory[msg.sender][currentRound] = msg.value;

		NewDonor(msg.sender, amountAfterFee, fee);

		// this is to check whether to end round and start next round
		if(maxDonors == (numDonors + 1)) {
			calculateAndSendCashForWinner();
			endRoundAndStartNextRound();
		}
	}

	// send payment back to the beneficially
	function calculateAndSendCashForWinner() {
		// uint minValue = donorsHistory[][currentRound];
		// address winner;
		// //compare to decide who is the winner of the current Round
		// for(uint i=0;i<maxDonors;i++) {

		// }
	}

	function endRoundAndStartNextRound() internal {
		currentRound++;
		numDonors = 0;
		RoundEnded(donationSum[currentRound]);
	}

	function getCurrentFund(uint round) returns(uint) {
		return donationSum[round];
	}

  function transfer(address _from, address _to, uint256 _value) returns(bool success){
    require(balanceOf[_from] >= _value);
    require(msg.value > 0);

    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;
    return true;
  }

}
