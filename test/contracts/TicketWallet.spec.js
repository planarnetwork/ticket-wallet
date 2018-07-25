const TicketWallet = artifacts.require("TicketWallet.sol");
const Web3Utils = require("web3-utils");

contract("TicketWallet", ([owner, retailer]) => {

  it("can create tickets", async () => {
    const ticketWallet = await TicketWallet.deployed();
    const expiry = Math.floor(Date.now() / 1000) + 86400;
    const ticketCostEth = 10;
    const ticketCostWei = Web3Utils.toWei(ticketCostEth.toString(), "ether");
    const ticketDescription = "Anytime from Brighton to London";
    const ticketPayload = "ipfs://2fkfsd";
    const hash = Web3Utils.soliditySha3(ticketPayload, "_", ticketCostWei, "_", expiry);
    const signature = web3.eth.sign(retailer, hash);
    const originalWei = await web3.eth.getBalance(retailer);

    await ticketWallet.createTicket(
      ticketDescription,
      ticketPayload,
      expiry,
      retailer,
      signature,
      {
        value: ticketCostWei,
        from: owner
      }
    );

    const [description, payloadUrl] = await Promise.all([
      ticketWallet.getTicketDescriptionById(0, { from: owner }),
      ticketWallet.tokenURI(0, { from: owner })
    ]);

    const finalWei = await web3.eth.getBalance(retailer);
    const expectedEth = parseFloat(Web3Utils.fromWei(originalWei.toString(), "ether")) + ticketCostEth;
    const expectedWei = Web3Utils.toWei(expectedEth.toString(), "ether");

    assert.equal(finalWei.toNumber(), expectedWei);
    assert.equal(description, ticketDescription);
    assert.equal(payloadUrl, ticketPayload);
  });

  it("ensures amount sent covers the cost of the ticket", async () => {
    const ticketWallet = await TicketWallet.deployed();
    const expiry = Math.floor(Date.now() / 1000) + 86400;
    const ticketCostEth = 10;
    const ticketCostWei = Web3Utils.toWei(ticketCostEth.toString(), "ether");
    const ticketDescription = "Anytime from Brighton to London";
    const ticketPayload = "ipfs://2fkfsd";
    const hash = Web3Utils.soliditySha3(ticketPayload, "_", ticketCostWei, "_", expiry);
    const signature = web3.eth.sign(retailer, hash);

    let complete = false;

    try {
      await ticketWallet.createTicket(
        ticketDescription,
        ticketPayload,
        expiry,
        retailer,
        signature,
        {
          value: Web3Utils.toWei("9"),
          from: owner
        }
      );

      complete = true;
    }
    catch (err) {}

    assert.equal(complete, false);
  });

  it("ensures offer has not expired", async () => {
    const ticketWallet = await TicketWallet.deployed();
    const expiry = Math.floor(Date.now() / 1000) - 86400;
    const ticketCostEth = 10;
    const ticketCostWei = Web3Utils.toWei(ticketCostEth.toString(), "ether");
    const ticketDescription = "Anytime from Brighton to London";
    const ticketPayload = "ipfs://2fkfsd";
    const hash = Web3Utils.soliditySha3(ticketPayload, "_", ticketCostWei, "_", expiry);
    const signature = web3.eth.sign(retailer, hash);

    let complete = false;

    try {
      await ticketWallet.createTicket(
        ticketDescription,
        ticketPayload,
        expiry,
        retailer,
        signature,
        {
          value: ticketCostWei,
          from: owner
        }
      );

      complete = true;
    }
    catch (err) {}

    assert.equal(complete, false);
  });

  it("retailers can access their fulfilment queue", async () => {
    const ticketWallet = await TicketWallet.deployed();
    const items = await ticketWallet.getFulfilmentQueue({ from: retailer });

    assert.equal(items.length, 1);

    const payloadUrl = await ticketWallet.tokenURI(items[0].toNumber(), { from: retailer });

    assert.equal(payloadUrl, "ipfs://2fkfsd");
  });

  it("retailer can mark the order as fulfilled", async () => {
    const ticketWallet = await TicketWallet.deployed();
    const items = await ticketWallet.getFulfilmentQueue({ from: retailer });

    assert.equal(items.length, 1);

    const ticketId = items[0].toNumber();
    const inputState = await ticketWallet.getTicketStateById(ticketId, { from: retailer });

    assert.equal(inputState.toNumber(), 0);

    await ticketWallet.fulfilTicket(ticketId, "ipfs://fulfilment", { from: retailer });
    const outputState = await ticketWallet.getTicketStateById(ticketId, { from: retailer });

    assert.equal(outputState.toNumber(), 1);

    const fulfilmentURI = await ticketWallet.getFulfilmentURIById(ticketId, { from: owner });

    assert.equal(fulfilmentURI, "ipfs://fulfilment");

    const queue = await ticketWallet.getFulfilmentQueue({ from: retailer });

    assert.equal(queue.length, 0);
  });

  it("retailer can mark the order as cancelled", async () => {
    const ticketWallet = await TicketWallet.deployed();
    const ticketId = 0;
    const inputState = await ticketWallet.getTicketStateById(ticketId, { from: retailer });

    assert.equal(inputState.toNumber(), 1);

    await ticketWallet.cancelTicket(ticketId, { from: retailer });
    const outputState = await ticketWallet.getTicketStateById(ticketId, { from: retailer });

    assert.equal(outputState.toNumber(), 2);
  });

});
