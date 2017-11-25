Web3 = require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
var soraContractAddress = '0xff0ed5bbcec761c505f635178b2681cdab878999';
var soraABI = require('../build/contracts/Sora.json').abi;
var coinbaseAddress = '0x003AEd4ACe62d94dBD1cB19eaC763E1F2Cf07227';
describe('Running web3 test', function(){
  it('Test get block number', function(done){
    web3.eth.getBlockNumber(function(err, result){
      console.log(result);
      done();
    });
  });

  it('Test get coinbase address', function(done){
    web3.eth.getCoinbase(function(err, result){
      console.log(result);
      done();
    });
  });

  it('Test get balance of an address', function(done){
    web3.eth.getBalance(coinbaseAddress,function(err, result){
      console.log(result);
      done();
    });
  });

  it('Test init contract Sora and get MaxDonors', function(done){
    // init SoraContract Object
    var SoraContract = new web3.eth.Contract(
      soraABI,
      soraContractAddress,
      {
        from: coinbaseAddress,
        // gasPrice: '20000000000', // default gas price in wei, 20 gwei in this case
      }
    );

    SoraContract.methods.getMaxDonors().call().then(result => {
      console.log(`Max Donor = ${result}`);
      done();
    }, (err) => {console.log(err);done();});
  });
});