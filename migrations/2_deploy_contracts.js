var ECTools = artifacts.require("ECTools");
var Retailers = artifacts.require("Retailers");
var TicketWallet = artifacts.require("TicketWallet");

module.exports = async (deployer) => {
  await deployer.deploy(Retailers);
	await deployer.deploy(ECTools)
	await deployer.link(ECTools, TicketWallet);
	await deployer.deploy(TicketWallet, Retailers.address);
  console.log(TicketWallet.address);
};
