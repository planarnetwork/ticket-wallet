var TicketWallet = artifacts.require("TicketWallet");

module.exports = (deployer) => {
  deployer.deploy(TicketWallet);
};
