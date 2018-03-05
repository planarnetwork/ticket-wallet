var ECTools = artifacts.require("ECTools");
var Retailers = artifacts.require("Retailers");
var TicketWallet = artifacts.require("TicketWallet");

module.exports = async (deployer) => {
	return Promise.all([
  	deployer.deploy(Retailers),
		deployer.deploy(ECTools),
		deployer.link(ECTools, TicketWallet),
		deployer.deploy(TicketWallet, Retailers.address)
	]);
};
