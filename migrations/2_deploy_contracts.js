var Sora = artifacts.require("./Sora.sol");
var SoraThinh = artifacts.require("SoraThinh.sol");

module.exports = function(deployer) {
  deployer.deploy(Sora);
  deployer.deploy(SoraThinh);
};
