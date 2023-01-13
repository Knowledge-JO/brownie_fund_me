//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe{
    //msg.sender msg.value keywords that go with transactions
    address public owner;
    AggregatorV3Interface public priceFeed;
    mapping(address => uint256 ) public addressToAmountFunded;
    address[] public funders;

    constructor (address _priceFeed) {
        priceFeed = AggregatorV3Interface(_priceFeed);
        owner = msg.sender;
    }


    function fund() public payable {
        uint256 minimumUSD = 50 * 10 ** 18;
        require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
        //what the eth -> usd concversion rate
    }


    function getVersion() public view returns(uint256){
        return priceFeed.version();
    }


    function getPrice() public view returns(uint256){
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 10**10);
    }


    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSd = (ethPrice * ethAmount) / 10**18;
        return ethAmountInUSd;
    }
    //0.000001717172979990

    function getEntranceFee() public view returns (uint256){
        //minimumUSD
        uint256 minimumUSD = 50 * 10**18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10**18;
        
        return (minimumUSD * precision) / price;
    }

    modifier onlyOwner {
        require(msg.sender == owner); 
        _;
    }

    function withdraw() payable onlyOwner public {
        payable(msg.sender).transfer(address(this).balance); 

        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);
    }
}