const WSB = artifacts.require("WSBCoin");

module.exports = async function(deployer) {
  await deployer.deploy(WSB);
  WSBCoin = await WSB.deployed();
  await WSBCoin.initialize(10000, 'WallStreetBets Coin', 'WSBC');
};