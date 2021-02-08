const WSBCoin = artifacts.require("WSBCoinTest");

contract('WSBCoinTest', (accounts) => {
  it('should have 10000 total supply', async () => {
    const instance = await WSBCoin.deployed();
    const balance = await instance.totalSupply();

    assert.equal(balance.valueOf(), 10000, "totalSupply is not 10000");
  });
  it('should mint tokens correctly', async () => {

    const instance = await WSBCoin.deployed();

    const account = accounts[0];
    const accountStartingBalance = (await instance.balanceOf.call(account)).toNumber();

    const amount = 1000;
    instance.mint(account, amount);

    const accountEndingBalance = (await instance.balanceOf.call(account)).toNumber();

    assert.equal(accountEndingBalance, accountStartingBalance + amount, "did not mint tokens");
  });
  /*it('should burn tokens correctly', async () => {
    const instance = await WSBCoin.deployed();

    const account = accounts[0];
    const accountStartingBalance = (await instance.balanceOf.call(account)).toNumber();

    const amount = 1000;
    instance.burn(account, amount);

    const accountEndingBalance = (await instance.balanceOf.call(account)).toNumber();

    assert.equal(accountEndingBalance, accountStartingBalance - amount, "did not burn tokens");
  });*/
  it('should send token correctly', async () => {
    const instance = await WSBCoin.deployed();

    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    const accountOneStartingBalance = (await instance.balanceOf.call(accountOne)).toNumber();
    const accountTwoStartingBalance = (await instance.balanceOf.call(accountTwo)).toNumber();

    const amount = 10;
    await instance.transfer(accountTwo, amount, { from: accountOne });

    const accountOneEndingBalance = (await instance.balanceOf.call(accountOne)).toNumber();
    const accountTwoEndingBalance = (await instance.balanceOf.call(accountTwo)).toNumber();

    assert.equal(accountOneEndingBalance, accountOneStartingBalance - amount, "Amount wasn't correctly taken from the sender");
    assert.equal(accountTwoEndingBalance, accountTwoStartingBalance + amount, "Amount wasn't correctly sent to the receiver");
  });

  it('returns the correct allowance amount after approval', async () => {
    const instance = await WSBCoin.deployed();
    const owner = accounts[0];
    const recipient = accounts[0];

    const tokenAmount = 100;
    await instance.approve(recipient, tokenAmount);
    const actualAllowance = await instance.allowance(owner, recipient);
    assert.equal(actualAllowance.toString(), tokenAmount.toString());
  });
});
