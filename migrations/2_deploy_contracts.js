var TicketWallet = artifacts.require("TicketWallet");
var Operators = artifacts.require("Operators");
var Retailers = artifacts.require("Retailers");

module.exports = function(deployer) {
  deployer.deploy(TicketWallet);
  deployer.deploy(Operators);
  deployer.deploy(Retailers);
};