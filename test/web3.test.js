Web3 = require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
var soraABI = require('../build/contracts/Sora.json').abi;


var soraContractAddress = '0xebe56d9edeb58e69ed41c7b8799418ee935e31fe';

var testWallet = '0x003AEd4ACe62d94dBD1cB19eaC763E1F2Cf07227';


var hui1 = '0x007F9921DBb5c381Ffe9993DF50137Dc643de36C';
var hui2 = '0x003524F296Dab42c0421f30F67F69Ee46735Ba12';
var hui3 = '0x00095A47662e1c9F8dc77Eca92d67882dB0aCa92';

// init SoraContract Object
var SoraContract = new web3.eth.Contract(
  soraABI,
  soraContractAddress,
  {
    from: testWallet,
    // gasPrice: '20000000000', // default gas price in wei, 20 gwei in this case
  }
);


describe('Running web3 test', function () {
  this.timeout(25000);
  it.skip('Deposit Ether', function (done) {
    var transactionObj = {
      from: hui3,
      value: 10 * 1000000000000000000
    };
    SoraContract.methods.depositFund()
      .send(transactionObj).then(function (err, result) {
        console.log(err, result);
        done();
      });
  });

  it('Is Deposited of hui1', function (done) {
    SoraContract.methods.isDeposited(hui1, 0)
      .call()
      .then(result => {
        console.log(result);
        done();
      })
      .catch(err => {
        console.log('ERROR neeeeee');
        console.log(err);
        done();
      });

  });

  it('Check current Sum of round', function (done) {
    const roundNumber = 0;
    SoraContract.methods.getSumDonationOfRound(0)
      .call()
      .then(result => {
        console.log(`(Sum of Round ${roundNumber}) = ${result/1000000000000000000}`);
        done();
      })
      .catch(err => {
        console.log('ERROR neeeeee');
        console.log(err);
        done();
      });

  });

  it('check current round', function (done) {
    SoraContract.methods.getCurrentRound()
      .call()
      .then(result => {
        console.log(`Current Round = ${result}`);
        done();
      })
      .catch(err => {
        console.log('ERROR neeeeee');
        console.log(err);
        done();
      });

  });

});