if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    // set the provider you want from Web3.providers
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}
 web3.eth.defaultAccount = web3.eth.accounts[0];
//  console.log(web3.eth.accounts[0]);
 var soraABI = '';
 var soraContractAddress = '0x179cb716448ac408c99f469b08feb94ad9bab584';

 var testWallet = '0x0b5f605761D85c17B9681f018f6dbD0b835B83F3';


 var testWallet0 = '0x996ef0613EA4D5aacb5925767408a7f6A61F50a5';
 var testWallet1 = '0x99F43B22c1D3202B891908540F6048D3e76Ea692';
 var testWallet2 = '0x31c63b4B57CF670CCa25B2A02f384e114FD4401E';
 $.getJSON('Sora.json', function(data) {
   soraABI = data.abi
   // init SoraContract Object
  //  var SoraContract = web3.eth.contract(
  //    soraABI,
  //    soraContractAddress,
  //    {
  //      from: testWallet,
  //      // gasPrice: '20000000000', // default gas price in wei, 20 gwei in this case
  //    }
  //  );
  let SoraContract = web3.eth.contract(soraABI).at(soraContractAddress);

  SoraContract.getCurrentRound.call(function(error, result){
      if(!error)
          {
              // $("#instructor").html(result[0]+' ('+result[1]+' years old)');
              console.log(result);
          }
      else
          console.error(error);
  });



  var transactionObj = {
    from: '0x996ef0613EA4D5aacb5925767408a7f6A61F50a5',
    value: 10e18,
    gas: 5000000
  };
  SoraContract.depositFund(7000000000000000000)
  .send(transactionObj, function(e, t) {
    console.log(e, t)
  })
    // .send(transactionObj, function (err, result) {
    //   console.log(err, result);
    //
    // });


 });
