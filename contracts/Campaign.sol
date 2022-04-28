// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.4.17;

//Campaign contract manager
contract CampaignManager {
    address[] public deployedCampaigns;

    function createCampaign(uint256 minimum) public {
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }

    function getDeployedCampaigns() public view returns (address[]) {
        return deployedCampaigns;
    }
}

//Initializing/Define a contract with the name Campaign
contract Campaign {
    //Define struct (similar to class/model}
    //Does not create a instance of Request
    //Introducing a new type to the contract
    struct Request {
        string description; //Defines a string field
        uint256 value;
        address recipient;
        bool complete;
        uint256 approvalCount;
        mapping(address => bool) approvals; //Reference type
    }

    uint256 public approversCount;
    Request[] public requests;
    //Initialize state variable
    //Address of the manager visibility is public
    address public manager;
    uint256 public minimumContribution;
    mapping(address => bool) public approvers;
    //Funciton modifier that specifies restricted access to certain functions
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    //Define constructor function
    //Takes a uint256 variable 'minimum' as an argument
    function Campaign(uint256 minimum, address campaignCreator) public {
        manager = campaignCreator; //Address of the person who's creating the contract is assigned to the manager variable
        minimumContribution = minimum; //Allows manager to set minimum funding amount
    }

    //Contribute function is marked as payable allowing it to recieve money
    function contribute() public payable {
        //Require method validating that the contribute value is greater than
        //The value of minimumContribution
        require(msg.value >= minimumContribution);

        //Adds new key (address) to approvers mapping
        //Gives it value of true
        approvers[msg.sender] = true;
        approversCount++;
    }

    //Create a function that takes three arguments
    function createRequest(
        string description,
        uint256 value,
        address recipient
    ) public restricted {
        //Creates a new instance of Request passing arguments via key value pairs
        //Utilize key value pairs to prevent from breaking code!!!!
        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            complete: false,
            approvalCount: 0
        });

        //Takes new instance of a request and pushes it to the request array
        requests.push(newRequest);
    }

    function approveRequest(uint256 index) public {
        Request storage request = requests[index];

        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finalizeRequest(uint256 index) public restricted {
        Request storage request = requests[index];

        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);

        request.recipient.transfer(request.value);
        request.complete = true;
    }

    function getSummary()
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            address
        )
    {
        return (
            minimumContribution,
            this.balance,
            requests.length,
            approversCount,
            manager
        );
    }

    function getRequestCount() public view returns (uint256) {
        return requests.length;
    }
}
