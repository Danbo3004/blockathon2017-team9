var ethereumjsWallet = require('ethereumjs-wallet');
var ProviderEngine = require("web3-provider-engine");
var WalletSubprovider = require('web3-provider-engine/subproviders/wallet.js');
var Web3Subprovider = require("web3-provider-engine/subproviders/web3.js");
var Web3 = require("web3");
var FilterSubprovider = require('web3-provider-engine/subproviders/filters.js');

// replace with your private key
var privateKey = '42728dca3f4afa582709567c3e9fe9506202c89246b658f0fbad06c5c19b84f9';

// create wallet from existing private key
var wallet = ethereumjsWallet.fromPrivateKey(new Buffer(privateKey, "hex"));
var address = "0x" + wallet.getAddress().toString("hex");

// using ropsten testnet
var providerUrl = "http://www.blockathon.asia:8545/";
var engine = new ProviderEngine();

// filters
engine.addProvider(new FilterSubprovider());
engine.addProvider(new WalletSubprovider(wallet, {}));
engine.addProvider(new Web3Subprovider(new Web3.providers.HttpProvider(providerUrl)));
engine.on('error', function(err) {
  // report connectivity errors
  console.error(err.stack)
})
engine.start();

// See <http://truffleframework.com/docs/advanced/configuration>
// to customize your Truffle configuration!
module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      gas: 5999999,
      network_id: "*" // Match any network id
    },
    rinkeby: {
      from: address,
      provider: engine,
      network_id: 4,
      gas: 4600000
    }
  }
};