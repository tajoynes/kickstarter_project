import web3 from "./web3";
import CampaignManager from "./build/CampaignManager.json";
import CONTRACT_ADDRESS from "../config";

const instance = new web3.eth.Contract(
  JSON.parse(CampaignManager.interface),
  CONTRACT_ADDRESS
);

export default instance;
