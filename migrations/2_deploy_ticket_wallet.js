var ECTools = artifacts.require("ECTools");
var TicketWallet = artifacts.require("TicketWallet");

module.exports = (deployer) => {
  deployer.deploy(ECTools);
  deployer.link(ECTools, TicketWallet);
  deployer.deploy(TicketWallet);
};
