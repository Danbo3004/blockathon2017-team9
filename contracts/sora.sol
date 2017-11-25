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

	mapping(uint => uint) donationSum;

	mapping(address => bool) withdrawals;

	// number of donor in the system
	uint public numDonors;
	// current round
	uint public currentRound;
	// current donors
	//Donor[][] public donors;

	mapping(uint => mapping(uint => Donor)) donors;
	

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

	function getSumDonationOfRound(uint round) returns (uint) {
		return donationSum[round];
	}

	function isWithdrawal(address user) returns (bool) {
		return withdrawals[user];
	}

	function depositFund() public payable {
		// require(msgValue <= amountDonation);
		// require(currentRound < maxDonors);
		
		// to mark if the sender already deposited
		depositList[currentRound][msg.sender] = true;

		numDonors++;

		donationSum[currentRound] += msg.value;

		donors[currentRound][numDonors] = Donor(msg.sender, msg.value, numDonors);

		NewDonor(msg.sender, msg.value, fee);
		
		// check if this is the last round
		if(currentRound + 1 != maxDonors){
			//set min Dornor
			if(msg.value <= minBidDonor.value) {
				minBidDonor = Donor(msg.sender,  msg.value, numDonors);
			}
			
			//this is to check whether to end round and start next round
			if(maxDonors == numDonors) {
				calculateAndSendCashForWinner();
				endRoundAndStartNextRound();
			}
		}else {
			if(maxDonors == numDonors) {
				// send back all payment in the final round
				for (uint index = 0; index < maxDonors; index++) {
					if(withdrawals[donors[0][index].addr] == false) {
						// send all fund
						donors[0][index].addr.transfer(donationSum[currentRound]);
					}
				}
			}
		}
		
	}

	// send payment back to the beneficially
	function calculateAndSendCashForWinner() {
		uint redudant;

		minBidDonor.addr.transfer(minBidDonor.value*maxDonors);
		withdrawals[minBidDonor.addr] = true;

		for(uint i=1; i<=maxDonors;i++){
			if(i != minBidDonor.index){
				redudant = donors[currentRound][i].value - minBidDonor.value;
				donors[currentRound][i].addr.transfer(redudant);
			}
		}

	}

	function endRoundAndStartNextRound() internal {
		minBidDonor = Donor(0x00,0,0);
		currentRound++;
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
