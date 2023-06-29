// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "hardhat/console.sol";

contract TARA is ERC721URIStorage {
   
     internal priceFeed;
    using SafeERC20 for IERC20;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint mintPrice,mintingPrice;

    struct Staker{
        mapping(uint=>address) stakedTokenIds;
        uint256[] mintedTokenIds;
         uint256 unclaimedRewards;
    }

    uint256 public TotalSupply = 50000;
    mapping (uint => address) public stakerAddresses;
    mapping (address=>Staker)Stakers;
    address[] public stakersArray;

    constructor () ERC721("TARA","TR") {
        address owner = msg.sender;
    }

    function _baseURI() internal pure override returns (string memory){
        return "https://google.com";
    }
    // modifier onlyOwner {
    //     require(msg.sender==owner);
    //     _;
    // }

    function minting(uint mintPrice,string memory tokenURI) external onlyOwner{
        require(mintPrice>=mintingPrice,"please provide sufficient minting price to mint")
           uint256 newItemId = _tokenIds.current();
        // Actually mint the NFT to the sender using msg.sender.
         _mint(msg.sender, newItemId);
        // Set the NFTs data.
        _setTokenURI(newItemId,tokenURI);
    }



    // function stake(uint _tokenId) external{
    //     Staker memory staker = Stakers[msg.sender] ;

    //     if( staker.stakedTokenIds.length > 0){
        
    //          updateRewards(msg.sender);
    //     }else{
    //        stakersArray.push(msg.sender);
    //     }
    //     uint len = _tokenIds.length;

    //     for(uint i=0;i<len;i++){
           
    //          nftCollection.transferFrom(msg.sender, address(this), _tokenIds[i]);
	//          Staker.stakedTokenIds.push(_tokenIds[i]);
	//          stakerAddresses[_tokenIds[i]] = msg.sender;
    //     }
    // }

    function userStakeInfo(address _user) public view returns (uint256[] memory _stakedTokenIds, uint256 _availableRewards)
    {
	        return (Stakers[_user].stakedTokenIds, availableRewards(_user));
    }

    function availableRewards(address _user) internal view returns (uint256 _rewards)
    {
	    Staker memory staker = Stakers[_user];
	    if (staker.stakedTokenIds.length == 0){
	         return staker.unclaimedRewards;
	    }
	    _rewards = staker.unclaimedRewards + calculateRewards(_user);
	}

    function updateRewards(address _staker) internal {
	        Staker storage staker = Stakers[_staker];
	        staker.unclaimedRewards += calculateRewards(_staker);
	        staker.timeOfLastUpdate = block.timestamp;
	}

    function getprice() public view returns (uint){
       AggregatorV3Interface priceFeed = AggregatorV3Interface("0x694AA1769357215DE4FAC081bf1f309aDC325306");
       (,int price,,,)= priceFeed.latestRoundData();
       return uint(price*1e10);
    }

    function calculateRewards(address _staker) internal view returns (uint256 _rewards){

    Staker memory staker = Stakers[_staker];
    uint ethAmount=getprice();
    uint ethinUsd=(ethAmount*mintingPrice)/1e18;
    uint reward=(ethinUsd/100);
    }
}
