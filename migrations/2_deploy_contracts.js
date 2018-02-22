var ECTools = artifacts.require("ECTools");
var Retailers = artifacts.require("Retailers");
var TicketWallet = artifacts.require("TicketWallet");

const runDeploy = async (deployer, retailersAddr) => {
	await deployer.deploy(ECTools)
	await deployer.link(ECTools, TicketWallet);
	await deployer.deploy(TicketWallet, retailersAddr);
}

module.exports = function(deployer) {
  deployer
  	.deploy(Retailers)
  	.then(() => {
  		runDeploy(deployer, Retailers.address)
  	});
};