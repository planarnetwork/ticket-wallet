var HDWalletProvider = require("truffle-hdwallet-provider");

var mnemonic = "###";

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*"
    },
    test: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/VfWYr7OjdspjLol0LX6t");
      },
      network_id: 3,
      gas: 4700000
    }
  },
  mocha: {
    reporter: "eth-gas-reporter",
    reporterOptions : {
      currency: "USD",
      gasPrice: 21
    }
  },
  solc: { optimizer: { enabled: true, runs: 200 } }
};
