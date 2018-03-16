var ExchangeRateGBP = artifacts.require("ExchangeRateGBP");
var ExchangeRateETH = artifacts.require("ExchangeRateETH");

module.exports = (deployer) => {
  deployer.deploy(ExchangeRateGBP);
  deployer.deploy(ExchangeRateETH);
};
