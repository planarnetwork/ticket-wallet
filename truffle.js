const HDWalletProvider = require("truffle-hdwallet-provider");
const infura = require("./infura");

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*"
    },
    test: {
      provider: () => new HDWalletProvider(infura.mnemonic, infura.url),
      network_id: 3,
      gas: 2700000
    }
  },
  mocha: {
    reporter: "eth-gas-reporter",
    reporterOptions : {
      currency: "USD",
      gasPrice: 5
    }
  },
  solc: { optimizer: { enabled: true, runs: 200 } }
};
