const {toAscii} = require("../util/String.js");
const Retailers = artifacts.require("Retailers.sol");
const TicketWallet = artifacts.require("TicketWallet.sol");
const ECTools = artifacts.require("ECTools.sol");

contract("TicketWallet", ([owner, retailer]) => {

  it("can create tickets", async () => {
    const ticketWallet = await TicketWallet.deployed();
    const expiry = Date.now() + 86400;
    const ticketCost = 10000;
    const retailTransactionFee = 0;
    const transactionCost = ticketCost + retailTransactionFee;
    
    await ticketWallet.createTicket(
      "Anytime from Brighton to London",
      expiry,
      ticketCost,
      0,
      "ipfs://2fkfsd48f3654fsdx56f4gj3",
      0, 
      {
        value: transactionCost,
        from: owner,
        gas: 1000000
      }
    );
    
    console.log("HERE");
    const [description, payloadUrl] = await Promise.all([
      ticketWallet.getTicketDescriptionById(0),
      ticketWallet.getTicketPayloadUrlById(0)
    ]);
    console.log("HERE");
    
    assert.equal(toAscii(description), "Anytime from Brighton to London Terminals");
    assert.equal(toAscii(payloadUrl), "ipfs://2fkfsd48f3654fsdx56f4gj354");
  });

  it("ensures the ticket details are signed by an authorised retailer", async () => {

  });

  it("ensures amount sent covers the cost of the ticket and the transaction fee", async () => {

  });

  it("ensures offer has not expired", async () => {

  });

  xit("ensures the fulfilment method is valid", async () => {

  });

});
