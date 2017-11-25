// https://github.com/cillionaire/cillionaire2
pragma solidity ^0.4.4;

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
		NewDonor(msg.sender, amountAfterFee, fee);

		// this is to check whether to end round and start next round
		if(maxDonors == (numDonors + 1)) {
			endRoundAndStartNextRound();
		}
	}

	function endRoundAndStartNextRound() internal {
		currentRound++;
		numDonors = 0;
		RoundEnded(donationSum[currentRound]);
	}

	function getCurrentFund(uint round) returns(uint) {
		return donationSum[round];
	}
}
