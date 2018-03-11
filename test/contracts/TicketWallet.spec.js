const {toAscii} = require("../util/String.js");
const Retailers = artifacts.require("Retailers.sol");
const TicketWallet = artifacts.require("TicketWallet.sol");
const ECTools = artifacts.require("ECTools.sol");

contract("TicketWallet", ([owner, retailer]) => {

  it("can create tickets", async () => {
    const retailers = await Retailers.deployed();
    await retailers.addRetailer(retailer, "A Retailer", 0, "5d4f6s8df4524w6fd5s4f6ws8e4f65s4");
    
    const ticketWallet = await TicketWallet.deployed();
    const expiry = Math.floor(Date.now() / 1000) + 86400;
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
        from: owner
      }
    );
    
    const [description, payloadUrl] = await Promise.all([
      ticketWallet.getTicketDescriptionById(0, { from: owner }),
      ticketWallet.getTicketPayloadUrlById(0, { from: owner })
    ]);
    
    assert.equal(toAscii(description), "Anytime from Brighton to London");
    assert.equal(toAscii(payloadUrl), "ipfs://2fkfsd48f3654fsdx56f4gj3");
  });

  xit("ensures the ticket details are signed by an authorised retailer", async () => {

  });

  xit("ensures amount sent covers the cost of the ticket and the transaction fee", async () => {

  });

  xit("ensures offer has not expired", async () => {

  });

  xit("ensures the fulfilment method is valid", async () => {

  });

});
