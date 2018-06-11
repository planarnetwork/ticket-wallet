const {toAscii} = require("../util/String.js");
const Retailers = artifacts.require("Retailers.sol");

contract("Retailers", ([owner, retailer, newRetailerAddress]) => {

  it("adds retailers", async () => {
    const retailers = await Retailers.deployed();
    
    await retailers.addRetailer(
      retailer,
      "A Retailer",
      10000
    );
    
    const [address, name, fee] = await Promise.all([
      retailers.ownerOf(0),
      retailers.nameById(0),
      retailers.txFeeAmountById(0)
    ]);
    
    assert.equal(address, retailer);
    assert.equal(toAscii(name), "A Retailer");
    assert.equal(fee, 10000);
  });

  it("sets a retailer's name", async () => {
    const retailers = await Retailers.deployed();
    
    await retailers.setNameById(0, "New Name", { from: retailer });
    
    const name = await retailers.nameById(0);
    
    assert.equal(toAscii(name), "New Name");
  });

  it("ensures only the retailer can change their name", async () => {
    const retailers = await Retailers.deployed();
    let set = false;
    
    try {
      await retailers.setNameById(0, "New Name", { from: owner });

      set = true;
    }
    catch (err) {}
    
    assert.equal(set, false);
  });

  it("sets a retailer's fee", async () => {
    const retailers = await Retailers.deployed();
    
    await retailers.setTxFeeAmountById(0, 0, { from: retailer });
    
    const fee = await retailers.txFeeAmountById(0);
    
    assert.equal(fee, 0);
  });

  it("ensures only the retailer can change their fee", async () => {
    const retailers = await Retailers.deployed();
    let set = false;
    
    try {
      await retailers.setTxFeeAmountById(0, 100, { from: owner });
      set = true;
    }
    catch (err) {}
    
    assert.equal(set, false);
  });

  it("transfer ownership of a retailer", async () => {
    const retailers = await Retailers.deployed();
    
    await retailers.transferFrom(retailer, newRetailerAddress, 0, { from: retailer });
    
    const address = await retailers.ownerOf(0);
    
    assert.equal(address, newRetailerAddress);
  });

});
