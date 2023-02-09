var Token = artifacts.require("Token");

module.exports = function(deployer) {
    deployer.deploy(Token);
  };
  var presale = artifacts.require("presale");

  module.exports = function(deployer) {
      deployer.deploy(presale);
    };
  

  