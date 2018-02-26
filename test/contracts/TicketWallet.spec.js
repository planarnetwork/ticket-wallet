const {toAscii} = require("../util/String.js");
const Retailers = artifacts.require("Retailers.sol");
const TicketWallet = artifacts.require("TicketWallet.sol");
const ECTools = artifacts.require("ECTools.sol");

contract("TicketWallet", ([owner, retailer]) => {

  it("can create tickets", async () => {
    console.log(TicketWallet.address);
    const ticketWallet = await TicketWallet.deployed();
    const expiry = Date.now() + 86400;
    
    await ticketWallet.createTicket(
      "Anytime from Brighton to London Terminals",
      expiry,
      10000,
      0,
      "",
      "ipfs://2fkfsd48f3654fsdx56f4gj354",
      0
    );
    
    const [description, payloadUrl] = await Promise.all([
      ticketWallet.getTicketDescriptionById(0),
      ticketWallet.getTicketPayloadUrlById(0)
    ]);

    console.log(description, payloadUrl);
    
    assert.equal(toAscii(description), "Anytime from Brighton to London Terminals");
    assert.equal(toAscii(payloadUrl), "ipfs://2fkfsd48f3654fsdx56f4gj354");
  });

  it("ensures the ticket details are signed by an authorised retailer", async () => {

  });

  it("ensures amount sent covers the cost of the ticket and the transaction fee", async () => {

  });

  it("ensures offer has not expired", async () => {

  });

  it("ensures the fulfilment method is valid", async () => {

  });

});
