
const Web3 = require("web3");
const HDWalletProvider = require("truffle-hdwallet-provider");
const Retailers = require("../build/contracts/Retailers");
const infura = require("../infura");

async function createRetailer() {
  const web3 = new Web3(new HDWalletProvider(infura.mnemonic, infura.url));
  const retailerContract = new web3.eth.Contract(Retailers.abi, Retailers.networks["3"].address);

  console.log("Adding retailer");

  const tx = await retailerContract.methods.addRetailer(
    "0x95F0a53a4CB2D8d58cd0552986206613C2F90844",
    web3.utils.fromAscii("Traintickets.to"),
    0
  ).send({
    from: "0x3bFa228819658A18164D69Bd983BE9E222B05F74"
  });

  console.log(tx);
}

createRetailer().catch(e => console.error(e));