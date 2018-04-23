const {toAscii, toBytes32} = require("../util/String.js");
const Retailers = artifacts.require("Retailers.sol");
const TicketWallet = artifacts.require("TicketWallet.sol");
const ECTools = artifacts.require("ECTools.sol");
const Web3Utils = require('web3-utils');

contract("TicketWallet", ([owner, retailer]) => {

  it("can create tickets", async () => {
    const retailers = await Retailers.deployed();
    const retailTransactionFee = 100;

    await retailers.addRetailer(retailer, "A Retailer", retailTransactionFee);
    
    const ticketWallet = await TicketWallet.deployed();
    const expiry = Math.floor(Date.now() / 1000) + 86400;
    const ticketCost = 10000;
    const ticketDescription = "Anytime from Brighton to London";
    const ticketPayload = "ipfs://2fkfsd";
    const transactionCost = ticketCost + retailTransactionFee;
    const hash = Web3Utils.soliditySha3(toBytes32(ticketPayload), ticketCost, expiry);
    const signature = web3.eth.sign(retailer, hash).substr(2);
    console.log(owner, retailer);
    console.log("signature", signature);
    console.log("signature-hash", Web3Utils.soliditySha3(signature));

    await ticketWallet.createTicket(
      ticketDescription,
      expiry,
      ticketCost,
      0,
      ticketPayload,
      0, 
      signature,
      {
        value: transactionCost,
        from: owner
      }
    );
    
    const [description, payloadUrl] = await Promise.all([
      ticketWallet.getTicketDescriptionById(0, { from: owner }),
      ticketWallet.getTicketPayloadUrlById(0, { from: owner })
    ]);
    
    assert.equal(toAscii(description), ticketDescription);
    assert.equal(toAscii(payloadUrl), ticketPayload);
  });

  // xit("ensures the ticket details are signed by an authorised retailer", async () => {
  // 
  // });
  // 
  // it("ensures amount sent covers the cost of the ticket and the transaction fee", async () => {
  //   const ticketWallet = await TicketWallet.deployed();
  //   const expiry = Math.floor(Date.now() / 1000) + 86400;
  //   const ticketCost = 10000;
  //   let complete = false;
  // 
  //   try {
  //     await ticketWallet.createTicket(
  //       "Anytime from Brighton to London",
  //       expiry,
  //       ticketCost,
  //       0,
  //       "ipfs://2fkfsd48f3654fsdx56f4gj3",
  //       0, 
  //       {
  //         value: ticketCost,
  //         from: owner
  //       }
  //     );
  // 
  //     complete = true;
  //   }
  //   catch (err) {}
  // 
  //   assert.equal(complete, false);
  // });
  // 
  // it("ensures offer has not expired", async () => {
  //   const ticketWallet = await TicketWallet.deployed();
  //   const expiry = Math.floor(Date.now() / 1000) - 86400;
  //   const ticketCost = 10000;
  //   const retailTransactionFee = 100;
  //   const transactionCost = ticketCost + retailTransactionFee;
  // 
  //   let complete = false;
  // 
  //   try {
  //     await ticketWallet.createTicket(
  //       "Anytime from Brighton to London",
  //       expiry,
  //       ticketCost,
  //       0,
  //       "ipfs://2fkfsd48f3654fsdx56f4gj3",
  //       0, 
  //       {
  //         value: ticketCost,
  //         from: owner
  //       }
  //     );
  // 
  //     complete = true;
  //   }
  //   catch (err) {}
  // 
  //   assert.equal(complete, false);
  // });
  // 
  // xit("ensures the fulfilment method is valid", async () => {
  // 
  // });

});
