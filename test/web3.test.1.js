Web3 = require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
var soraContractAddress = '0x301e684a51235d73ef651ac8b076e800772b2abf';
var soraABI = require('../build/contracts/Sora.json').abi;
var coinbaseAddress = '0x003AEd4ACe62d94dBD1cB19eaC763E1F2Cf07227';
var addressTest1 = '0x00e68a9f47eC93F2D75Ef3473bB09e6B5d5654e4';

// init SoraContract Object
var SoraContract = new web3.eth.Contract(
  soraABI,
  soraContractAddress,
  {
    from: coinbaseAddress,
    // gasPrice: '20000000000', // default gas price in wei, 20 gwei in this case
  }
);


describe('Running web3 test', function () {
  this.timeout(15000);
  it('Test get block number', function (done) {
    web3.eth.getBlockNumber(function (err, result) {
      console.log(result);
      done();
    });
  });

  it('Test get coinbase address', function (done) {
    web3.eth.getCoinbase(function (err, result) {
      console.log(result);
      done();
    });
  });

  it('Test get list of acc', function (done) {
    web3.eth.getAccounts(function (err, result) {
      console.log(result);
      done();
    });
  });

  it('Test get balance of an address', function (done) {
    web3.eth.getBalance(coinbaseAddress, function (err, result) {
      console.log(result);
      done();
    });
  });

  it('Test init contract Sora and get MaxDonors', function (done) {
    SoraContract.methods.getMaxDonors().call().then(result => {
      console.log(`Max Donor = ${result}`);
      done();
    }, (err) => { console.log(err); done(); });
  });
  


  it('Get balance of the contract test 1', function (done) {
    web3.eth.getBalance(addressTest1, function (err, result) {
      console.log(result/1000000000000000000);
      done();
    });
  });

  it('test send Fund to the contract', function (done) {
    // SoraContract.methods.testDepositFund('0x00e68a9f47eC93F2D75Ef3473bB09e6B5d5654e4')
    // .call().then(function(result, error){
    //   console.log('Result of Deposit fund = ' + result);
    //   done();
    // });
    
    var transactionObj = {
      from: coinbaseAddress,
      to: soraContractAddress,
      value: 4 * 1000000000000000000
    };

    web3.eth.sendTransaction(transactionObj).then(function (err, result) {
      console.log(err || result);
      return SoraContract.methods.getFallBackValue().call().then(result => {
        console.log(`Fall back value = ${result}`);
        done();
      }, (err) => { console.log(err); done(); });
    });

  });


});