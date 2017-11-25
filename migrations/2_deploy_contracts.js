
//var MetaCoin = artifacts.require("./MetaCoin.sol");
var Sora = artifacts.require("./Sora.sol");

module.exports = function(deployer) {
  deployer.deploy(Sora);
};
