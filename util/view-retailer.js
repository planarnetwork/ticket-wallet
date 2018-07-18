
const Web3 = require("web3");
const HDWalletProvider = require("truffle-hdwallet-provider");
const Retailers = require("../build/contracts/Retailers");
const infura = require("../infura");

async function viewRetailer() {
  const web3 = new Web3(new HDWalletProvider(infura.mnemonic, infura.url));
  const retailerContract = new web3.eth.Contract(Retailers.abi, Retailers.networks["3"].address);

  console.log("Querying retailer");

  const name = await retailerContract.methods.nameById(0).call({
    from: "0x3bFa228819658A18164D69Bd983BE9E222B05F74"
  });

  console.log("Name", web3.utils.toAscii(name));
}

viewRetailer().catch(e => console.error(e));