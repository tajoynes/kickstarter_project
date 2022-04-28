const HDWalletProvider = require("@truffle/hdwallet-provider");
const Web3 = require("web3");
const compiledManager = require("./build/CampaignManager.json");

const provider = new HDWalletProvider(
  "immense pencil toy album brick vacuum unaware upon company bless donor alter",
  "https://rinkeby.infura.io/v3/bde427b2c83e484f9849e7b3209a7cb1"
);

const web3 = new Web3(provider);

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();

  console.log("Attempting to deploy from acconut", accounts[0]);

  const result = await new web3.eth.Contract(
    JSON.parse(compiledManager.interface)
  )
    .deploy({ data: compiledManager.bytecode })
    .send({ from: accounts[0], gas: "1000000" });
  console.log("Contract deployed to", result.options.address);
  provider.engine.stop();
};
deploy();
