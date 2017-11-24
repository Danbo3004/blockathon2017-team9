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

contract sora is mortal {

	uint public startTimestamp;
    uint public endTimestamp;
    uint public maxDonors;
    uint public duration;
    uint public donation;
    uint public fee;
	uint public amountDonation;
	uint public donationSum;
	uint public numDonors;
	uint public numRound;
	address[] public donors;
	address public beneficiary;

	event NewDonor(address _donor, uint _donationAfterFee, uint _fee);
	event RoundEnded(uint _donationSum);

	function sora() {
		fee = 0 ether;
		duration = 1 days;
		maxDonors = 4;
		amountDonation = 10 ether;
		donationSum = 0;
		numDonors = 0;
		numRound = 1;
	}

	function depositFund() external payable {
		require(msg.value <= amountDonation);
		uint amountAfterFee = msg.value - fee;
		donationSum += amountAfterFee;

		donors[numDonors++] = msg.sender;
		NewDonor(msg.sender, amountAfterFee, fee);

		// this is to check whether to end round and start next round
		if(maxDonors == numDonors){
			endRoundAndStartNextRound();
		}else{
			
		}
	}

	function endRoundAndStartNextRound() internal {
		numRound++;
		RoundEnded(donationSum);
	}

	function getCurrentFund() returns(uint) {
		return donationSum;
	}
}
