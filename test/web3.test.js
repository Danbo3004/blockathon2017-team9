Web3 = require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
var soraABI = require('../build/contracts/Sora.json').abi;


var soraContractAddress = '0xddc458e7db2f737720978176864b451d823765e2';

var testWallet = '0x003AEd4ACe62d94dBD1cB19eaC763E1F2Cf07227';


var testWallet0 = '0x00a329c0648769A73afAc7F9381E08FB43dBEA72';
var testWallet1 = '0x00A7482EAFc4318822019e30D4E6024Fe6f8bfd4';
var testWallet2 = '0x00e68a9f47eC93F2D75Ef3473bB09e6B5d5654e4';

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
  it('Deposit Ether', function (done) {
    //SoraContract.methods.depositFund()
    var transactionObj = {
      from: testWallet2,
      //to: soraContractAddress,
      value: 9 * 1000000000000000000
    };
    SoraContract.methods.depositFund()
      .send(transactionObj).then(function (err, result) {
        console.log(err, result);
        done();
      });
  });

  it('Is Deposited of testWallet0', function (done) {
    SoraContract.methods.isDeposited(testWallet2, 0)
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
    SoraContract.methods.getSumDonationOfRound(1)
      .call()
      .then(result => {
        console.log(`Sum of this round = ${result/1000000000000000000}`);
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
        console.log(`Round = ${result}`);
        done();
      })
      .catch(err => {
        console.log('ERROR neeeeee');
        console.log(err);
        done();
      });

  });



});