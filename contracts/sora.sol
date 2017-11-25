// https://github.com/cillionaire/cillionaire2
pragma solidity ^0.4.17;

contract owned {

    address public owner;

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
	struct Donor {
        address addr;
        uint value;
		uint index;
    }

	uint public startTimestamp;
    uint public endTimestamp;
	// duration of a round
    uint public duration;



	// length of max donors, = 3
    uint public maxDonors;
    uint public fee;
	uint public amountDonation;

	uint[] public donationSum;

	// number of donor in the system
	uint public numDonors;
	// current round
	uint public currentRound;
	// current donors
	Donor[][] public donors;
	Donor minBidDonor;
	
	//mapping (address => mapping (uint => uint)) donorsHistory;

	event NewDonor(address _donor, uint _donationAfterFee, uint _fee);
	event RoundEnded(uint _donationSum);

	function Sora() {
		fee = 0 ether;
		duration = 1 days;
		maxDonors = 3;
		amountDonation = 10 ether;
		numDonors = 0;
		currentRound = 0;
		//donationSum[currentRound] = 0;
		minBidDonor = Donor(0x00,0,0);
	}

	function getCurrentRound() returns (uint) {
		return currentRound;
	}

	mapping(uint => mapping(address => bool)) depositList;


	function isDeposited(address user, uint round) returns (bool) {
		return depositList[round][user];
	}

	function() payable {
		depositFund(msg.value, msg.sender);
		//test(msg.value, msg.sender);
	}
	
	function depositFund(uint msgValue, address msgSender) payable {
		// require(msgValue <= amountDonation);
		// require(currentRound < maxDonors);
		
		// to mark if the sender already deposited
		depositList[currentRound][msgSender] = true;

		numDonors++;
		uint amountAfterFee = msgValue - fee;

		donationSum[currentRound] += amountAfterFee;

		donors[currentRound][numDonors] = Donor(msgSender, msgValue, numDonors);

		NewDonor(msgSender, amountAfterFee, fee);
		
		//set min Dornor
		if(msgValue <= minBidDonor.value){
			minBidDonor = Donor(msgSender, msgValue, numDonors);
		}
		
		// this is to check whether to end round and start next round
		currentRound++;
		if(maxDonors == numDonors) {
			calculateAndSendCashForWinner();
			endRoundAndStartNextRound();
		}
	}

	// send payment back to the beneficially
	function calculateAndSendCashForWinner() {
		uint redundantAmount = 0;

		minBidDonor.addr.transfer(minBidDonor.value);
		
		redundantAmount = (donationSum[currentRound] - minBidDonor.value)/(numDonors - 1);

		for(uint i=1; i<=donors[currentRound].length;i++){
			if(i != minBidDonor.index){
				donors[currentRound][i].addr.transfer(donors[currentRound][i].value);
			}
		}
	}

	function endRoundAndStartNextRound() internal {
		minBidDonor = Donor(0x00,0,0);
		if((currentRound + 1) < numDonors) {
			currentRound++;
		}else {
			currentRound = 0;
		}

		numDonors = 0;

		RoundEnded(donationSum[currentRound]);
	}

	function getCurrentFund(uint round) returns(uint) {
		return donationSum[round];
	}

		function getMaxDonors() returns(uint) {
		return maxDonors;
	}

	function getAmountDonation() returns(uint) {
		return amountDonation;
 	}

}
