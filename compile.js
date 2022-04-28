//Compile file flow
const path = require("path");
const solc = require("solc"); //Solidity compiler
const fs = require("fs-extra"); //Community file system module +

//Compile logic

//Creates a path to 'build' folder in the current working directory
const buildPath = path.resolve(__dirname, "build");
//Remove existing build file
fs.removeSync(buildPath);

const campaignPath = path.resolve(__dirname, "contracts", "Campaign.sol");
const source = fs.readFileSync(campaignPath, "utf8");
const output = solc.compile(source, 1).contracts;

//Checks to see if a directory exist, if not it creates it
fs.ensureDirSync(buildPath);

console.log(output);

for (let contract in output) {
  fs.outputJsonSync(
    path.resolve(buildPath, contract.replace(":", "") + ".json"),
    output[contract]
  );
}
